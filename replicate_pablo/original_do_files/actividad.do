clear all
macro drop _*
#delimit ;
*include local.do;
include "V:\USR\PCARVALLO\Proyecciones\Ejercicio 2017-10\uruguay\local.do";

import excel using `country'_forecast_summary_`depvarlist'.xlsx, sheet("summary") firstrow;
local this_yr = year; local next_yr = `this_yr'+1;
local this_yr1 = year; local next_yr1 = `this_yr'+1;
di `this_yr';
* Año de la proyección de interés (año en curso);
sum w_gr_cond`this_yr'; local c1 = `r(mean)';
sum gr_cond`this_yr'; local c2 = `r(mean)';
	if `c1' == `c2' {;	local this_yr = `next_yr';	};
	else {; local this_yr = `this_yr'; };
local hoy = "$S_DATE";
			*************************************************************;
			*************************************************************;
			* Acá asignamos un valor para la proyección del año en curso;
			* Puede ser el que entrega el modelo;
			*local proy_this = w_gr_cond`this_yr';
			*local proy_next = w_gr_cond`next_yr';
			* O puede ser cualquier otro con el que se quiera probar;
			local proy_this = 3;
			*local proy_next = 1.6;
			*************************************************************;
			*************************************************************;
local ano1 = year; local ano2 = `ano1' + 1;
local prths: di %2.1f w_gr_cond`ano1';
local prnxt: di %2.1f w_gr_cond`ano2';

* Otras variables locales con todos los resultados de la proyección;
	foreach num of numlist 1/4 {;
			local proy_this`num' = w_gr_cond`this_yr'`num';
			local proy_next`num' = w_gr_cond`next_yr'`num';
	};
* Para el gráfico de la proyección;
		foreach num of numlist 1/4 {;
			local proy_this`num'_1: di %2.1f w_gr_cond`this_yr1'`num';
			local proy_next`num'_1: di %2.1f w_gr_cond`next_yr1'`num';
	};
* Gráfico de la proyección;
preserve;
clear;
set obs 8;
gen yr = .;
	foreach var of local depvarlist {;
		gen d`var' = .;
			foreach num of numlist 1/4 {;
				replace d`var' = `proy_this`num'_1' in `num';
				local num1 = `num'+4;
				replace d`var' = `proy_next`num'_1' in `num1';
	};};
	foreach num of numlist 1/4 {;replace yr = 2000 + `this_yr1' in `num';};
	foreach num of numlist 5/8 {;replace yr = 2000 + `next_yr1' in `num';};
bys yr: gen qtr = _n;
gen q=yq(yr, qtr); format q %tq; drop yr qtr; sort q;
save proy_trim_`country'.dta, replace;

import excel using `country'.xlsx, sheet("quarterly") firstrow clear;
gen q=yq(year, quarter); format q %tq;
keep q `depvarlist'; order q;
tsset q;
tsappend, add(8);
merge 1:1 q using proy_trim_`country'.dta;
gen crec = 100*(rgdp/l4.rgdp-1);
gen crec1 = crec; replace crec1 = drgdp if crec1 == .;
gsort -q; drop if crec1 == .; gen n = _n; keep if n<13; sort q;
gen aux = 1 if crec==.; replace aux = 1 if crec!=. & f.crec==.;
	/*twoway (line crec q, lwidth(medium) lcolor(black)) ///
		(line crec1 q if aux==1, lwidth(medium) lpattern(dash) lcolor(black)) ///
		, ylabel(, labsize(small) angle(horizontal) format(%2.1fc)) ///
		yti("") xti("") ///
		title("`country': Crecimiento actual y proyectado", size(medium)) ///
		note("Fecha actualización: `hoy'", size(vsmall)) ///
		legend(label(1 "Actual") label(2 "Proyectado") size(small)) ///
		caption("20`this_yr1': `prths'%" "20`this_yr1'q1: `proy_this1_1'%" ///
		"20`this_yr1'q2: `proy_this2_1'%" "20`this_yr1'q3: `proy_this3_1'%"
		"20`this_yr1'q4: `proy_this4_1'%" " " "20`next_yr1': `prnxt'%" ///
		"20`next_yr1'q1: `proy_next1_1'%" "20`next_yr1'q2: `proy_next2_1'%" ///
		"20`next_yr1'q3: `proy_next3_1'%" "20`next_yr1'q4: `proy_next4_1'%",
		size(vsmall) position(3) ///
		box fcolor(none) justification(left)) ///
		saving(`country'_proy.gph,replace);
gr export "`share'/1_`country'_proy.png", width(3000) replace;*/
restore;

gen proy=`proy_this';
	foreach num of numlist 5/1 {;
		gen proy_menos`num' = proy - 0.`num';
	};
	foreach num of numlist 1/5 {;
		gen proy_mas`num' = proy + 0.`num';
	};
keep proy*; keep in 1; order proy_menos* proy proy_mas*;
gen n = _n;
save crec_distintas_proy.dta, replace;

* Cálculo del crecimiento necesario en el/los trim faltantes para llegar al valor proyectado;
import excel using `country'.xlsx, sheet("quarterly") firstrow clear;
gen q=yq(year, quarter); format q %tq;
keep q `depvarlist'; order q;
tsset q;
gen d_`depvarlist' = 100*(s4.`depvarlist'/l4.`depvarlist');
replace d_`depvarlist' = . if mod(yofd(dofq(q)),100)!=`this_yr';
drop if d_rgdp==.;
gen n = 1;
merge m:1 n using crec_distintas_proy.dta;
drop n _merge;
local tasas proy_menos5 proy_menos4 proy_menos3 proy_menos2 proy_menos1 ///
proy proy_mas1 proy_mas2 proy_mas3 proy_mas4 proy_mas5;
sum d_rgdp; local aux `r(N)';
egen x = sum(d_rgdp);
	foreach r of local tasas {;
		gen crec_`r' = (4*`r'-x)/(4-`aux');
	};
	foreach num of numlist 1/5 {;
		local i = 5 - `num';
		rename proy_menos`num' proy`i';
		rename crec_proy_menos`num' crec`i';
	};
rename proy proy5;
	foreach num of numlist 1/5 {;
		local i = 5 + `num';
		rename proy_mas`num' proy`i';
		rename crec_proy_mas`num' crec`i';
	};
rename crec_proy crec5;
keep proy* crec*; keep in 1;
gen i=1;
reshape long proy crec, i(i) j(var1); drop i var1;
format proy %2.1fc;
rename crec crec_pib;

		*******************************************;
		*******************************************;
		save crec_distintas_proy.dta, replace; /* crea un dta con distintas proyecc y el crec. necesario para llegar */
		*******************************************;
		*******************************************;

* Importar los datos mensuales de actividad;
import excel using `country'.xlsx, sheet("monthly") firstrow clear;
gen t=ym(year, month); format t %tm; keep if year>=2000;
gen yract = mod(yofd(dofm(t)),100); qui sum yract if `act'!=.; local yract = `r(max)';
keep t `act'; order t;
tsset t;
gen d_`act' = 100*(s12.`act'/L12.`act')/12;
egen nm = count(`act') if mod(yofd(dofm(t)),100)==`yract'; /* meses con dato de ACT */;
sum nm; local nm = 12 - `r(mean)'; /* meses que faltan para completar el año*/;
egen suma_`act' = sum(d_`act') if nm!=. & d_`act'!=.;
sum suma_`act'; local suma_`act' = `r(mean)';
gen yr = yofd(dofm(t));
gen mes = month(dofm(t));
save `country'_`act'_data.dta, replace;

* Calcula el crec. necesario de la actividad para dar;
* con el crecimiento necesario del PIB, que da con la proyección;
use crec_distintas_proy.dta, clear;
gen act = 12*(crec_pib - `suma_`act'')/`nm';
gen str label = "";
	foreach num of numlist 5/1 {; local j = 5 - `num' + 1; 
		replace label = "Proy. base - `num' déc." in `j'; };
	foreach num of numlist 1/5 {; local j = 5 + `num' + 1;
		replace label = "Proy. base + `num' déc." in `j'; };
replace label = "Proy. base" in 6;
order label;
local trim_falt = 4 - `aux';
label var label " ";
label var proy "Proyección";
label var crec_pib "PIB necesario los últ. `trim_falt' trim.";
label var act "Crec. de la act. nec. para lograr el del pib";
export excel using "`share'/`country'_CrecTrim.xlsx", 
	sheet("datos") sheetmodify cell(a5) firstrow(varlabels);


* Correlación entre PIB e índice de actividad;
* Actividad;
import excel using `country'.xlsx, sheet("monthly") firstrow clear;
gen t=ym(year, month); format t %tm;
gen q = qofd(dofm(t));
format q %tq;
gen mes=month(dofm(t));
tsset t;
gen `act'_trim = (`act'*l.`act'*l2.`act')^(1/3);
keep if mes==3 | mes==6 | mes==9 | mes==12;
tsset q;
gen d_`act'_trim = 100*(s4.`act'_trim/l4.`act'_trim);
keep q `act'* d_`act';
save temp_`act'.dta, replace;
* PIB;
import excel using `country'.xlsx, sheet("quarterly") firstrow clear;
gen q=yq(year, quarter); format q %tq;
keep q `depvarlist'; order q;
tsset q;
gen d_`depvarlist' = 100*(s4.`depvarlist'/l4.`depvarlist');
merge 1:1 q using temp_`act'.dta;
correl d_`depvarlist' d_`act'_trim;
local correl=`r(rho)';
egen nq = count(`depvarlist') if mod(yofd(dofq(q)),100)==`this_yr';
sum nq;
local nq = 4 - `r(mean)'; /* trimestres que faltan para completar el año*/;
di `nq';
/*
					*********************************;
					******CUENTAS NACIONALES*********;
					*********************************;
					preserve;
					do "`root'/DO-files/ficha_CCNN.do";
					restore;
					include `country'_ccnn.do;
					*********************************;
					******CUENTAS NACIONALES*********;
					*********************************;
*/
/** Archivo con las variables locales que se usan en el reporte final;
file open mlocal using report_latex.do, replace write;
foreach lname in country depvarlist act correl proy_this proy_next 
		proy_this1 proy_this2 proy_this3 proy_this4 proy_next1 proy_next2
		proy_next3 proy_next4 this_yr next_yr nq nm {;
		file write mlocal "local `lname' ``lname''" _n;
		};
file close mlocal;*/

* Gráfico de actividad año actual y años pasados;
use `country'_`act'_data.dta, clear;
local correl: di %3.2f `correl';
*gen yr=yofd(dofm(t));
*bys yr: gen mes=_n;
replace d_`act' = 100*(s12.`act'/L12.`act');
drop t `act' nm suma_`act';
drop if d_`act'==.;
reshape wide d_`act', i(mes) j(yr);
label define mes 1 "ene" 2 "feb" 3 "mar" 4 "abr" 5 "may" 6 "jun" 7 "jul" ///;
8 "ago" 9 "sep" 10 "oct" 11 "nov" 12 "dic";
label values mes mes;
	foreach k of numlist 1/4 {;
		local thisyr_`k' = `yract' - `k';
	};
	
sum d_`act'20`thisyr_4'; gen max = `r(max)'; gen min = `r(min)';
	foreach k of numlist 20`thisyr_3'/20`yract' {;
		sum d_`act'`k'; 
		replace max = `r(max)' if `r(max)' > max;
		replace min = `r(min)' if `r(min)' < min;
	};
local act1 = upper("`act'");
sum min; local min = `r(min)';
sum max; local max = `r(max)';

twoway (connected d_`act'20`yract' mes, lcolor(red) lwidth(medium) msize(medsmall) ms(circle) mfcolor(white) mlcolor(red)) ///
	(connected d_`act'20`thisyr_1' mes, lcolor(black) lwidth(medium) msize(medsmall) ms(triangle) mfcolor(white) mlcolor(black)) ///
	(connected d_`act'20`thisyr_2' mes, lcolor(black) lwidth(medium) msize(medsmall) ms(square) mfcolor(white) mlcolor(black)), ///
	ylabel(#15, labsize(small) angle(horizontal) format(%2.1fc)) ///
	xlabel(1 "E" 2 "F" 3 "M" 4 "A" 5 "M" 6 "J" 7 "J" 8 "A" 9 "S" 10 "O" 11 "N" 12 "D", labsize(small) grid) ///
	yti("") xti("") ///
	title(`country': Variación interanual del índice de actividad (`act1'), size(medium)) ///
	subtitle("Últimos 3 años, en porcentaje", size(small)) ///
	caption("Fecha actualización: `hoy'", size(vsmall)) ///
	note("Correl(PIB, `act1') = `correl'", size(vsmall) position(7) fcolor(none) justification(left)) ///
	legend(size(small))
	saving(gr_`act'_`country'.gph,replace);
gr export "`share'/3_`country'_`act'.png", width(3000) replace;

keep mes d_`act'20`yract' d_`act'20`thisyr_1' d_`act'20`thisyr_2';
export excel using "`share'/`country'_CrecTrim.xlsx", 
	sheet("datos") sheetmodify cell(a21) firstrow(varlabels);

putexcel A1 = ("`country': Diferentes escenarios de crecimiento del PIB y del `act1'")
	A2 = ("Trimestres para completar la serie de PIB: `trim_falt'")
	A3 = ("Meses para completar la serie de `act': `nm'")
	A18 = ("Correl(PIB, `act1') = `correl'")
	A19 = ("`country': Variación interanual del índice de actividad (`act1')")
	using "`share'/`country'_CrecTrim.xlsx", sheet("datos") modify;	
	
erase gr_`act'_`country'.gph;
erase `country'_`act'_data.dta;
