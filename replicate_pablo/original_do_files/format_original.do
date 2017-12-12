clear all
macro drop _*
#delimit ;
include local.do;

* Import monthly data;
import excel using `country'.xlsx, sheet("monthly") firstrow;
destring `domlist', replace;
keep year month `domlist';
sort year month;
save temp.dta, replace;
clear;
import excel using "`cd_ext'\external.xlsx", sheet("monthly") firstrow;
destring `extlist', replace;
keep year month `extlist';
sort year month;
merge year month using temp.dta;
erase temp.dta;
gen quarter=.;
replace quarter=month/3 if month==3 | month==6 | month==9 | month==12;
gen date=ym(year, month);
format date %tm ;
tset date;
tsappend, add(`max_step_m');
drop if date==. ;
foreach var of local predlist { ;
	if `log_`var''==1 {;
		gen l`var' = ln(`var') ;
		};
	else {;
		gen l`var' = `var' ;
		};
	} ;

* Produce unconditional forecasts;
local i=0;
foreach var of local predlist {;
		local num: word count `predlist';
		local ++i;
		noisily di "";
		noisily di "Variable " `i' " de " "`num'" "...";
	foreach step of numlist 0(1)`max_step_m' {;
		gen l`var'_f`step'=.;
		};
	sum date if l.`var'!=. & `var'!=. & f.`var'==. & f2.`var'==.;
	local m_obs_end=r(mean);
	local est_start=`m_obs_end'-(`eval_period'*3);
	
	
	local total = (`m_obs_end' - `est_start')/3 + 1;
	foreach est_until of numlist `est_start'(3)`m_obs_end' {;
		local paso = `total' - (`m_obs_end' - `est_until')/3;
		noisily di "     ...ARIMA " "`paso'" " de " "`total'";
		sum l`var' if date<=`est_until';
		if `r(N)'>=48 {;
			arima l`var' if date<=`est_until', `arima_`var'' robust iterate(30);
			predict l`var'_f, y dynamic(tm(`e(tmaxs)')+1);
			replace l`var'_f = l`var' if date<=tm(`e(tmaxs)');
			replace l`var'_f = (l`var'_f + l.l`var'_f + l2.l`var'_f)/3 if quarter!=.;
			replace l`var'_f = . if quarter==. | date<`est_until';
	
			* Store the averaged forecast in "l`var'_f`step'";
			foreach step of numlist 0(1)`max_step_m' {;
				replace l`var'_f`step'=l`var'_f if date>=`est_until'+3*(`step') & date<`est_until'+3*(`step'+1) & quarter!=.;
				};
			drop l`var'_f;
		};	};
		
	* Average over the correspoinding quarters;
	replace l`var' = (l`var'+l.l`var'+l2.l`var')/3 if quarter!=.;
	};

keep if quarter!=.;
drop date month ;
gen date=yq(year, quarter) ;
format date %tq ;
tset date;
foreach var of local predlist {;
	local keeplist1 "`keeplist1' `var' l`var' l`var'_f0-l`var'_f`max_step_m'";
	};
keep date year quarter `keeplist1';

save temp.dta, replace;
clear;

* import quarterly data;
import excel using `country'.xlsx, sheet("quarterly") firstrow;
keep year quarter `depvarlist';
gen date=yq(year, quarter);
format date %tq ;
tset date;
tsappend, add(`max_step');

foreach var of local depvarlist { ;
	gen l`var' = ln(`var') ;
	} ;
foreach var of local depvarlist {;
	local keeplist2 "`keeplist2' `var' l`var'";
	};
keep date year quarter `keeplist2';

* Combine the two data files;
merge date using temp.dta;
drop _merge;
erase temp.dta;
tset date;
drop if date==.;
order date year quarter;
save `country'.dta, replace;

* End of the file;

