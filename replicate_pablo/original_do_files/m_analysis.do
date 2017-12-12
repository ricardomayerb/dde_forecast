clear all
macro drop _*
#delimit ;
include local.do;	

log using `country'_m_analysis.log, replace;

foreach depvar of local depvarlist {;
	local i=0;
	foreach pred of local predlist {;
		local num: word count `predlist';
		local ++i;
		noisily di "";
		noisily di "Variable " `i' " de " "`num'" "...";
		clear all; program drop _all;
		include local.do;
		local exo1 "L(0/0).l`pred'";
		local exo2 "L(0/1).l`pred'";
		local exo3 "L(0/2).l`pred'";
		local exo4 "L(0/3).l`pred'";
		
		foreach regtype of numlist `start_regtype'(1)`stop_regtype' {;
			use `country'.dta, clear;
			noisily di "";
			noisily di "     ...rezago " "`regtype'" " de " "`stop_regtype'";
			foreach num of numlist 0(1)`max_step' {;
				gen fcast_cond`num'=.;
				gen fcast_uncond`num'=.;
				gen fcast_cond_error`num'=.;
				gen fcast_uncond_error`num'=.;
				};
			sum date if l.`depvar'!=. & `depvar'!=. & f.`depvar'==. & f2.`depvar'==.;
			local q_obs_end=r(mean);
			local eval_start = `q_obs_end'-`eval_period';
			
			sum year if l.`depvar'!=. & `depvar'!=. & f.`depvar'==. & f2.`depvar'==.;
			local obs_end_yr=r(mean);
			* Forecast evaluation;
			local total = `q_obs_end' - `eval_start' + 1;
			foreach est_until of numlist `eval_start'(1)`q_obs_end' {;
			local paso = `total' - `q_obs_end' + `est_until';
			
			noisily di "          ...evaluación periodo " "`paso'" " de " "`total'";
				
			gen l`depvar'_actual = l`depvar';				
				gen l`pred'_actual = l`pred';

				* add the forecast values of predictors for `max_step' quarters from `est_until';
				replace l`depvar' =. if date>`est_until';
				replace l`pred' =. if date>`est_until';
				foreach step of numlist 0(1)`max_step' {;
					replace l`pred' = l`pred'_f`step' if date==`est_until'+`step'+1;
					};
				* generate conditional forecast;
				arima l`depvar' `exo`regtype'', `arima_`depvar'' robust iterate(30);
				predict fcast, y dynamic(tq(`e(tmaxs)')+1);
				foreach num of numlist 0(1)`max_step' {;
					replace fcast_cond`num' = s4.fcast if date==`est_until'+`num'+1;
					replace fcast_cond_error`num' = (fcast_cond`num' - s4.l`depvar'_actual)*100 if date==`est_until'+`num'+1;
					};		
					
				replace l`depvar' = l`depvar'_actual;
				replace l`pred' = l`pred'_actual;
				drop l`depvar'_actual l`pred'_actual fcast;
				* generate forecast values of the unconditional model for comparison;
				gen l`depvar'_actual = l`depvar';
				replace l`depvar' =. if date>`est_until';
				arima l`depvar', `arima_`depvar'' robust iterate(30);
				predict fcast, y dynamic(tq(`e(tmaxs)')+1); 
				foreach num of numlist 0(1)`max_step' {;
					replace fcast_uncond`num' = s4.fcast if date==`est_until'+`num'+1;
					replace fcast_uncond`num' = . if fcast_cond`num'==.;
					replace fcast_uncond_error`num' = (fcast_uncond`num' - s4.l`depvar'_actual)*100 if date==`est_until'+`num'+1;
					};
				replace l`depvar' = l`depvar'_actual;	
				drop l`depvar'_actual fcast;
				};
			* Unconditional forecast;
			arima l`depvar', `arima_`depvar'' robust iterate(30);
			predict fcast_uncond, y dynamic(tq(`e(tmaxs)')+1);
			replace fcast_uncond = l`depvar' if date<=tq(`e(tmaxs)'); 

			* Conditional forecast;
			gen l`pred'_original = l`pred';
			sum date if l`pred'!=. ;
			replace l`pred' = l`pred'_f0 if date==`r(max)'+1;
			foreach step of numlist 1(1)`max_step' {;
				replace l`pred' = l`pred'_f`step' if date==`r(max)'+`step' & l`pred'==.;
				replace l`pred' = l`pred'_f`step' if date==`r(max)'+`step'+1;
				};	
			arima l`depvar' `exo`regtype'', `arima_`depvar'' robust iterate(30);
			predict fcast_cond, y dynamic(tq(`e(tmaxs)')+1);
			replace fcast_cond = l`depvar' if date<=tq(`e(tmaxs)');
			* Residuals;
			predict resi, residuals;
			gen tempvar = l.resi;
			replace resi=. if tempvar==.;
			drop tempvar;

			* Store t-stats for each of the exogeneous indicators;
			gen t1=.; gen t2=.; gen t3=.; gen t4=.; local ite=0;
			if `regtype'!=0 {;
				foreach var of varlist `e(covariates)' {;
					local ite = `ite'+1 ;
					replace t`ite' = _b[`var']/_se[`var'];
				};	};
			* Specification test of the conditional model;
			* 1. Stability condition of estimates;
			cap: estat aroots, nograph;
			cap: mat A=r(Modulus_ar);
			cap: mat B=r(Modulus_ma);
			* 2. Skweness, curtosis and normality;
			sktest resi; /* Smirnov-Komogorov test */
			mat C=r(Utest); /* C[1,4] = [Pr(skewness), Pr(kurtosis), Chi2, Pro(joint)] */
			swilk resi; /* Shapiro-Wilk test */
			mat D=r(p); /* D[1,1] = [p-value] */
			* 3. Autocorrelation;
			corrgram resi; /* Box-Ljung Q tests (visial) */
			wntestq resi; /* Box-Ljung Q tests */
			mat E=r(p); /* E[1,1] = [p-value] */
			* 4. AIC and BIC scores;
			estat ic;
			mat F=r(S); /* F[1,5] = [AIC], F[1,6] = [BIC] */
			* Storing the results of the forecast evaluation and the spec tests;
			gen gr_cond = s4.fcast_cond*100;
			gen gr_uncond = s4.fcast_uncond*100;
			foreach step of numlist 1(1)`max_step' {;
				local step_minus_1 = `step'-1;
				/* MAE - Mean Absolute Forecast Error */
				egen mae`step'=mean(abs(fcast_cond_error`step_minus_1'));
				/* MSE - Mean Squared Forecast Error */
				gen fcast_cond_error`step_minus_1'_sq = fcast_cond_error`step_minus_1'^2;
				egen mse`step'=mean(fcast_cond_error`step_minus_1'_sq); 	
				/* RMSE - Root Mean Squared Forecast Error */
				/* The Theil's U score is a ratio of RMSPE to RMSPE of the naive model */
				gen rmse`step' = sqrt(mse`step');
				/* Diebold-Mariano test: H0: forecast accuracy is equal */
				gen fcast_uncond_error`step_minus_1'_sq = fcast_uncond_error`step_minus_1'^2;
				ttest fcast_cond_error`step_minus_1'_sq=fcast_uncond_error`step_minus_1'_sq;
				gen dmariano`step' = r(p_l);
				};
			foreach num of numlist 1(1)`max_step'{;
				gen stability1_`num'=.;
				gen stability2_`num'=.;
				cap: replace stability1_`num'=A[1,`num'];
				cap: replace stability2_`num'=B[1,`num'];
				};
			gen skewness=C[1,1]; 	/* Pr(skewness) */
			gen kurtosis=C[1,2]; 	/* Pr(kurtosis) */
			gen normal=D[1,1];		/* Pr(normal) */
			gen autocorr=E[1,1];	/* Pr(autocorrelation) */
			gen aic=F[1,5];			/* AIC */
			gen bic=F[1,6];			/* BIC */
			gen depvar = "`depvar'";
			gen arima_uncond = "`arima_diff'";
			gen cond_depvar = e(depvar);
			gen cond_exo = e(covariates);
			gen arima_cond = e(cmdline);
			gen arima_cond_regtype = `regtype';
			keep if year>=`obs_end_yr';
			keep date depvar gr_*
				skewness kurtosis normal autocorr aic bic t1-t4
				mae* mse* rmse* dmariano* 
				arima_uncond cond_depvar cond_exo arima_cond_regtype arima_cond
				stability*; 
			append using temp_`depvar'.dta;
			sort depvar arima_cond_regtype cond_exo date ;
			duplicates drop;
			save temp_`depvar'.dta, replace;
		};	};
	drop if date>=tq(`obs_end_yr'q1)+`max_step';
	reshape wide gr_*, i(depvar cond_exo) j(date);
			
	local max_step_year = `max_step'/4 - 1;
	foreach num of numlist 0(1)`max_step_year' {;
		local obs_end_yrp`num' = `obs_end_yr'+`num';
		local yrp`num' = `obs_end_yrp`num''-2000;
		};
	foreach q of numlist 1(1)4 {;
		foreach num of numlist 0(1)`max_step_year' {;
			local old_qnum`q' = tq(`obs_end_yrp`num''q`q');
			local new_qnum`q' = `yrp`num''*10 + `q';
			foreach var in cond uncond {;
				rename gr_`var'`old_qnum`q'' gr_`var'`new_qnum`q'';
		};	};	};
	foreach var in uncond cond {;
		foreach num of numlist 0(1)`max_step_year' {;
			gen gr_`var'`yrp`num'' = (gr_`var'`yrp`num''1+gr_`var'`yrp`num''2+gr_`var'`yrp`num''3+gr_`var'`yrp`num''4)/4;
		};	};
	foreach num of numlist 1(1)`max_step' {;
		egen temp1 = mean(mse`num') if arima_cond_regtype==0;
		egen temp2 = mean(temp1);
		gen rel_mse`num' = mse`num'/temp2;
		drop temp1 temp2;
		};
	order depvar cond_exo gr_cond`yrp0'-gr_cond`yrp`max_step_year'' gr_uncond`yrp0'-gr_uncond`yrp`max_step_year'' rel_mse* t1-t4
		skewness kurtosis normal autocorr aic bic dmariano* 
		gr_cond* gr_uncond*;
	replace year = `yrp0';
	gen q_obs_end = `q_obs_end';
	export excel using `country'_m_analysis_`depvar'.xlsx, replace sheet("result") firstrow(variables) datestring(%tq);
	
	};
* End of the file;
log close;

