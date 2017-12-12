clear all
macro drop _*
#delimit ;
include local.do;
foreach depvar of local depvarlist {;
	* Import the forecast results;
	clear;
	import excel using `country'_m_analysis_`depvar'_selected.xlsx, sheet("result") firstrow allstring;
	destring *, replace;
	drop if cond_exo == "_NONE" ;
	order depvar;

	* Compute weighted average;
	sum q_obs_end; local q_obs_end = r(mean);	
	local max_step_year = `max_step'/4 - 1;
	sum year; local yrp0 = r(mean);	local yrp1 = `yrp0'+1;
	local yrp2 = `yrp0'+2; local yrp3 = `yrp0'+3;
	foreach y of numlist `yrp0'(1)`yrp`max_step_year'' {;
		foreach q of numlist 1(1)4 {;
			local date = tq(20`y'q`q');
			if `q_obs_end'>=`date' {;
				egen w_gr_cond`y'`q' = mean(gr_cond`y'`q');
				} ;
			else {;
				local step = `date'-`q_obs_end';
				egen temp_numerator`step' = sum((1/mse`step')*gr_cond`y'`q');
				egen temp_denominator`step' = sum(1/mse`step');
				gen w_gr_cond`y'`q' = temp_numerator`step'/temp_denominator`step';
				drop temp_numerator`step' temp_denominator`step';
		};	};	};
		
	foreach num of numlist 0(1)`max_step_year' {;
		gen w_gr_cond`yrp`num'' = (w_gr_cond`yrp`num''1+w_gr_cond`yrp`num''2+w_gr_cond`yrp`num''3+w_gr_cond`yrp`num''4)/4;
		};
	sort depvar arima_cond_regtype cond_exo;
	
	foreach num of numlist 5(1)1 {;
		gen pr_menos`num' = w_gr_cond`yrp0' - 0.`num';
		gen pr_mas`num' = w_gr_cond`yrp0' + 0.`num';
		};
	
	
	
	order depvar cond_exo w_gr_cond`yrp0'-w_gr_cond`yrp`max_step_year''
		gr_cond`yrp0'-gr_cond`yrp`max_step_year'' gr_uncond`yrp0' gr_uncond`yrp`max_step_year'' ;
	export excel using `country'_forecast_summary_`depvar'.xlsx, replace sheet("summary") firstrow(variables) datestring(%tq);
	};
