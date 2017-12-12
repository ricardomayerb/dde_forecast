*******************************************************************************
* Setting
*******************************************************************************
#delimit ;
cls;
gen x = arima_cond; split x, p(arima sarima robust); gen model = "ARIMA"+x3+x4;
replace model=subinstr(model," ","",.);
local this_yr=year; local next_yr=`this_yr'+1;
noisily di as text _dup(70) "*"; noisily di as text _dup(70) "*";
noisily di "Crecimiento del PIB en `country':"; noisily di "";
noisily di "Año 20`this_yr': " %2.1fc as result w_gr_cond`this_yr'[1] "%";
noisily di "Año 20`next_yr': " %2.1fc as result w_gr_cond`next_yr'[1] "%";
noisily di "";
noisily di "Resultados por trimestre:";
noisily di "20`this_yr'-Q1: " %2.1fc as result w_gr_cond`this_yr'1[1] "%";
noisily di "20`this_yr'-Q2: " %2.1fc as result w_gr_cond`this_yr'2[1] "%";
noisily di "20`this_yr'-Q3: " %2.1fc as result w_gr_cond`this_yr'3[1] "%";
noisily di "20`this_yr'-Q4: " %2.1fc as result w_gr_cond`this_yr'4[1] "%";
noisily di "***";
noisily di "20`next_yr'-Q1: " %2.1fc as result w_gr_cond`next_yr'1[1] "%";
noisily di "20`next_yr'-Q2: " %2.1fc as result w_gr_cond`next_yr'2[1] "%";
noisily di "20`next_yr'-Q3: " %2.1fc as result w_gr_cond`next_yr'3[1] "%";
noisily di "20`next_yr'-Q4: " %2.1fc as result w_gr_cond`next_yr'4[1] "%";
noisily di "";
noisily di "Variables utilizadas:";

egen instr1 = ends(cond_exo), last;
egen instr2 = ends(instr1), last punct(.);
gen instr3 = substr(instr2,2,.);
forvalues n = 1/`=_N' {;
    noisily di as result instr3[`n'];
};
noisily di ""; noisily di as text "{hline 40}";
noisily di "Resultado no condicional en `country':"; noisily di "";
noisily di "Modelo aplicado al PIB: " as result model[1]; noisily di "";
noisily di "Año 20`this_yr': " %2.1fc as result gr_uncond`this_yr'[1] "%";
noisily di "Año 20`next_yr': " %2.1fc as result gr_uncond`next_yr'[1] "%";
noisily di ""; noisily di as text _dup(70) "*"; noisily di as text _dup(70) "*";
drop x*;
