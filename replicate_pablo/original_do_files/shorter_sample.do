clear all
#delimit ;
set more off ; set matsize 3000; set niceness 5;
macro drop _all; graph drop _all; mat drop _all; cap: log close;

import excel "V:\USR\RMAYER\Proyecciones\Ejercicio 2017-10\Brasil\Brasil.xlsx", sheet("quarterly") firstrow;

drop if date > td("01sep2015"); 







