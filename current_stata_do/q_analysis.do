clear all
macro drop _*
#delimit ;
include local.do;

use `country'.dta;

* Unconditional forecasts of quarterly variables;
foreach depvar of local depvarlist {;
	arima l`depvar', `arima_`depvar'' robust iterate(30);
	predict fcast_l`depvar', y dynamic(tq(`e(tmaxs)')+1);
	replace fcast_l`depvar'=l`depvar' if date<=tq(`e(tmaxs)');
	
	* Residual;
	predict resi, residuals;
	gen tempvar = l.resi;
	replace resi=. if tempvar==.;
	drop tempvar;

	* Spec tests;
	* Stability condition of estimates;
	cap: estat aroots, nograph;
	cap: mat A_`depvar'=r(Modulus_ar);
	cap: mat B_`depvar'=r(Modulus_ma);
	* Skweness, curtosis and normality;
	sktest resi; /* Smirnov-Komogorov test */
	mat C_`depvar'=r(Utest); /* C[1,4] = [Pr(skewness), Pr(kurtosis), Chi2, Pro(joint)] */
	swilk resi; /* Sharpio-Wilk test */
	mat D_`depvar'=r(p); /* D[1,1] = [p-value] */
	* Autocorrelation;
	corrgram resi; /* Box-Ljung Q tests (visial) */
	wntestq resi; /* Box-Ljung Q tests */
	mat E_`depvar'=r(p); /* E[1,1] = [p-value] */
	* AIC and BIC scores;
	estat ic;	/* F[1,5] = [AIC], F[1,6] = [BIC] */
	mat F_`depvar'=r(S);
	drop resi;
	};

* Save quarterly forecast restuls;
preserve;
foreach pred of local predlist {;
	gen fcast_l`pred' = l`pred';
	sum date if fcast_l`pred'!=. ;
	replace fcast_l`pred' = l`pred'_f0 if date==`r(max)'+1;
	foreach step of numlist 1(1)`max_step' {;
		replace fcast_l`pred' = l`pred'_f`step' if date==`r(max)'+`step' & fcast_l`pred'==.;
		replace fcast_l`pred' = l`pred'_f`step' if date==`r(max)'+`step'+1;
		};
	local keeplist "`keeplist' `pred' l`pred' fcast_l`pred'";
	};
foreach depvar of local depvarlist {;
	local keeplist "`keeplist' `depvar' l`depvar' fcast_l`depvar'";
	};
keep date year quarter `keeplist';
order date year quarter `keeplist';
save `country'_q_forecast.dta, replace;
export excel using `country'_q_forecast.xlsx, replace sheet("forecast") firstrow(variables) datestring(%tq);
restore;

* Evaluate out-of-sample forecast;
foreach depvar of local depvarlist {;
	foreach step of numlist 0(1)`max_step' {;
		gen fcast_`depvar'`step'=.;
		gen ferror_`depvar'`step'=.;
	};	};



foreach depvar of local depvarlist {;

	sum date if l.`depvar'!=. & `depvar'!=. & f.`depvar'==. & f2.`depvar'==.;
	local q_obs_end=r(mean);
	local eval_start = `q_obs_end'-`eval_period';
	
	sum year if l.`depvar'!=. & `depvar'!=. & f.`depvar'==. & f2.`depvar'==.;
	local obs_end_yr=r(mean);
	di `obs_end_yr';
	foreach est_until of numlist `eval_start'(1)`q_obs_end' {;
		gen l`depvar'_actual = l`depvar';
		replace l`depvar' =. if date>`est_until';
		arima l`depvar', `arima_`depvar'' robust iterate(30);
		predict y, y dynamic(tq(`e(tmaxs)')+1);
		foreach step of numlist 0(1)`max_step' {;
			replace fcast_`depvar'`step' = y
				if date==`est_until'+`step'+1;
			replace l`depvar' = fcast_`depvar'`step'
				if date==`est_until'+`step'+1;
			replace ferror_`depvar'`step' = (fcast_`depvar'`step' - l`depvar'_actual)*100
				if date==`est_until'+`step'+1;
			};
		replace l`depvar' = l`depvar'_actual;
		drop y l`depvar'_actual;
	};	};
	
save temp1.dta, replace;
clear;
gen year=.;
save temp2.dta, replace;
clear;

foreach depvar of local depvarlist {;
	use temp1.dta, clear;
	gen gr_uncond = s4.fcast_l`depvar'*100;
	gen gr_cond = gr_uncond;
	gen depvar = "l`depvar'";
	foreach step of numlist 1(1)`max_step' {;
		local step_minus_1 = `step'-1;
		/* MAE - Mean Absolute Error */
		egen mae`step'=mean(abs(ferror_`depvar'`step_minus_1'));
		/* MSE - Mean Squared Error */
		gen ferror_`depvar'`step_minus_1'_sq = ferror_`depvar'`step_minus_1'^2;
		egen mse`step'=mean(ferror_`depvar'`step_minus_1'_sq); 		
		/* RMSE - Root Mean Squared Error */
		/* The Theil's U score is a ratio of RMSPE to PMSPE of the naive model */
		gen rmse`step' = sqrt(mse`step');
		};
	foreach num of numlist 1(1)`max_step'{;
		gen stability1_`num'=.;
		gen stability2_`num'=.;
		cap: replace stability1_`num'=A_`depvar'[1,`num'];
		cap: replace stability2_`num'=B_`depvar'[1,`num'];
		};
	gen skewness=C_`depvar'[1,1]; 	/* Pr(skewness) */
	gen kurtosis=C_`depvar'[1,2]; 	/* Pr(kurtosis) */
	gen normal=D_`depvar'[1,1];		/* Pr(normal) */
	gen autocorr=E_`depvar'[1,1];	/* Pr(autocorrelation) */
	gen aic=F_`depvar'[1,5];		/* AIC */
	gen bic=F_`depvar'[1,6];		/* BIC */
	gen arima_uncond = "`arima_`depvar''";
	gen cond_depvar = "";
	gen cond_exo = "";
	gen arima_cond = "";
	gen arima_cond_regtype = .;
	foreach num of numlist 1(1)`max_step' {;
		gen dmariano`num'=.;
		};
	keep if year>=`obs_end_yr';
	local max_step_year = `max_step'/4 - 1;
	foreach num of numlist 0(1)`max_step_year' {;
		local obs_end_yrp`num' = `obs_end_yr'+`num';
		sum gr_cond if year==`obs_end_yrp`num'';
		local yrp`num' = `obs_end_yrp`num''-2000;
		gen forecast`yrp`num''=r(mean);
		};
	keep depvar date gr_uncond gr_cond forecast`yrp0'-forecast`yrp`max_step_year''
		skewness kurtosis normal autocorr aic bic 
		mae1-mae`max_step' mse1-mse`max_step' rmse1-rmse`max_step' dmariano1-dmariano`max_step'
		arima_uncond cond_depvar cond_exo arima_cond_regtype arima_cond
		stability1_1-stability2_`max_step'; 
	append using temp2.dta;
	save temp2.dta, replace;
	};

sort depvar arima_cond_regtype date;
drop year;
erase temp1.dta;
erase temp2.dta;
drop ferror_* ;
drop if date>=tq(`obs_end_yr'q1)+`max_step';
reshape wide gr_cond gr_uncond, i(depvar) j(date);

foreach q of numlist 1(1)4 {;
	foreach num of numlist 0(1)`max_step_year' {;
		local old_qnum`q' = tq(`obs_end_yrp`num''q`q');
		local new_qnum`q' = `yrp`num''*10 + `q';
		foreach var in cond uncond {;
			rename gr_`var'`old_qnum`q'' gr_`var'`new_qnum`q'';
	};	};	};
order depvar forecast* gr_*
	skewness kurtosis normal autocorr aic bic 
	mae* mse* rmse* dmariano* stability*
	arima_uncond cond_depvar cond_exo arima_cond_regtype arima_cond;
export excel using `country'_q_analysis.xlsx, replace sheet("result") firstrow(variables) datestring(%tq);

* End of the file;

