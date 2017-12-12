clear all
macro drop _*
#delimit ;
*include "V:\USR\PCARVALLO\Proyecciones\Ejercicio 2017-06\Peru\local.do";
include local.do;

local hoy = "$S_DATE";
local cuadrocrec rgdp rpc rgc ri fbcf exist rx rm primario manuf serv;
import excel using `country'.xlsx, sheet("quarterly") firstrow clear;
gen q=yq(year, quarter); format q %tq;
keep q `cuadrocrec'; order q;
tsset q;
/* Crecimiento trimestral de cada variable */;
	foreach var of local cuadrocrec {;
		gen d`var' = 100*(s4.`var'/l4.`var');
	};
drop if rgdp==.;

gsort -q;
gen n= _n;
sort q;
replace n = . if n>8;
label var drgdp PIB;
label var drpc "Consumo privado";
label var drgc "Consumo gobierno";
label var dri Inversión;
label var dfbcf FBCF;
label var dexist "Var. Exist.";
label var drx Exports.;
label var drm Imports.;
label var dprimario Primario;
label var dmanuf Manufactura;
label var dserv Servicios;

local grafos rgdp rpc rgc rx rm;
sum q if n!=.; local minq = `r(min)'+1; local maxq = `r(max)'; di `minq';
	foreach var of local grafos {;
		local title "`: variable label d`var''";
		line d`var' q if n!=., lcolor(black) lwidth(medium) ///
		ylabel(, angle(horizontal) labsize(small) glcolor(gs13)) ///
		xlabel(`minq'(2)`maxq', labsize(small)) ///
		ytitle("") xtitle("") title({&Delta}%`title', size(small));
		gr save `country'_d`var'.gph, replace;
	};
	
	twoway (line dri q if n!=., lcolor(black) lwidth(medium)) ///
	(line dfbcf q if n!=., lcolor(black) lwidth(medium) lpattern(dash)), ///
	ylabel(, angle(horizontal) labsize(small) glcolor(gs13)) ///
	xlabel(`minq'(2)`maxq', labsize(small)) ///
	legend(off) ///
	ytitle("") xtitle("") title("{&Delta}%Inversión - {&Delta}%FBCF (línea punteada)", size(small));
	gr save `country'_dri.gph, replace;

sum q if n!=.;
local minq: di %tq `r(min)';
local maxq: di %tq `r(max)';
gr combine `country'_drgdp.gph `country'_drpc.gph `country'_drgc.gph ///
	   `country'_dri.gph `country'_drx.gph `country'_drm.gph ///
	   , col(3) ycommon title("`country': `minq'-`maxq'", size(small)) ///
	   note("Fecha actualización: `hoy'", size(vsmall)) ///
	   subtitle("(Variación trimestral interanual)", size(vsmall));
	   gr save proy_`country'.gph, replace;
	   gr export "`share'/4_`country'_crecDA.png", width(3000) replace;
* opción ycommon es para que en el combine, todos tengan el mismo eje y;

gen yr = yofd(dofq(q));
bys yr: gen qtr = _n;
bys yr: egen maxqtr = max(qtr);
egen maxyr = max(yr) if maxqtr == 4;
gen yrcompl = 2 if maxyr == yr;
qui sum maxyr; local yrcompleto = `r(mean)';
preserve;
	drop if yrcompl!=2;
	egen PIB = sum(rgdp) if yrcompl==2;
	egen C = sum(rpc) if yrcompl==2;
	egen G = sum(rgc) if yrcompl==2;
	egen I = sum(ri) if yrcompl==2;
	egen total_rx = sum(rx) if yrcompl==2;
	egen total_rm = sum(rm) if yrcompl==2;
	gen XN = total_rx - total_rm;
	keep PIB C G I XN;
	keep in 1;
	local pib = C + G + I + XN; local gto C G I XN;
		foreach var of local gto {;
			replace `var' = 100*`var'/`pib';};
	graph bar `gto', stack outergap(68) yscale(noline) ylabel(none) ///
			nolabel blabel(bar, pos(center) size(small) format(%2.1fc) c(white)) ///
			title("`country': Composición del PIB (`yrcompleto')", size(small)) ///
			note("Fecha actualización: `hoy'", size(vsmall)) ///
			legend(on cols(1) size(small) position(7) ring(0) region(lcolor(none)));
	gr save `country'_gto.gph, replace;
	gr export "`share'/2_`country'_compgto.png", width(3000) replace;
restore;

* Locales para la tabla;
local sigyr = maxyr - 1;
replace yrcompl = 1 if yr == `sigyr';
egen maxyrincomp = max(yr);
	if maxyrincomp > maxyr {;
		replace yrcompl = 3 if yofd(dofq(q)) == maxyrincomp;
	};
qui sum yrcompl;
	if `r(max)' == 3 {;	
		local yr3inc = 1;
		foreach k of numlist 1/3 {;
			sum yr if yrcompl == `k'; local year`k' = `r(mean)';
		};};
	else {; 
		local yr3inc = 0;
		foreach k of numlist 1/2 {;
			sum yr if yrcompl == `k'; local year`k' = `r(mean)';
	};};
	
tsset q;
	foreach var of varlist rgdp rpc rgc ri fbcf rx rm primario manuf serv {;
		di "************************";
		di "`var'";
		di "************************";
		gen d`var'_acum = 100*(((`var' + L.`var' + L2.`var' + L3.`var')/(L4.`var' + L5.`var' + L6.`var' + L7.`var'))-1);
			foreach k of numlist 1/3 {;
				sum qtr if yrcompl==`k' & d`var'_acum!=.; 
				if `r(N)'==0 {;
					local d`var'yr`k' .;
				};
				else {;
					sum d`var'_acum if yrcompl==`k' & qtr==`r(max)';
					local d`var'yr`k': di %2.1f `r(mean)';
				};
			};
		foreach num of numlist 1/8 {;
			qui sum d`var' if n == `num';
				if `r(N)' == 0 {; local d`var'`num' .; };
				else {; local d`var'`num': di %2.1f `r(mean)'; }; di "d`var'`num' = " `d`var'`num''; 
		};};

			
			
	foreach j of numlist 1/8 {;
		qui sum q if n == `j';
		local n`j': di %tq `r(mean)';
	};

file open myfile using `country'_ccnn.do, replace write;
	foreach lname in drgdp drpc drgc dri dfbcf drx drm dprimario dmanuf dserv {;
		foreach k of numlist 1/3 {;
			file write myfile "local `lname'yr`k' ``lname'yr`k''" _n;
		};
		foreach num of numlist 1/8 {;
			file write myfile "local `lname'`num' ``lname'`num''" _n;
		};	
	};
		foreach p of numlist 1/8 {;
			file write myfile "local n`p' `n`p''" _n;
		};	
	file write myfile "local yr3inc `yr3inc'" _n;
	file write myfile "local year1 `year1'" _n;
	file write myfile "local year2 `year2'" _n;
	file write myfile "local year3 `year3'" _n;
file close myfile;

if `yr3inc' == 0 {;
	putexcel A1 = ("`country': Crecimiento trimestral")
		A4=("PIB") A5=("Cons. priv.") A6=("Cons. gob.") A7=("Inversión") A8=("FBCF") A9=("Exports.")
		A10=("Imports.") A11=("Primario") A12=("Manuf.") A13=("Servicios")
		B3=("`n8'") C3=("`n7'") D3=("`n6'") E3=("`n5'") F3=("`n4'") G3=("`n3'")
		H3=("`n2'") I3=("`n1'") J3=("`year1'") K3=("`year2'")
		B4=(`drgdp8') C4=(`drgdp7') D4=(`drgdp6') E4=(`drgdp5') F4=(`drgdp4') G4=(`drgdp3')
		H4=(`drgdp2') I4=(`drgdp1') J4=(`drgdpyr1') K4=(`drgdpyr2')
		B5=(`drpc8') C5=(`drpc7') D5=(`drpc6') E5=(`drpc5') F5=(`drpc4') G5=(`drpc3')
		H5=(`drpc2') I5=(`drpc1') J5=(`drpcyr1') K5=(`drpcyr2')
		B6=(`drgc8') C6=(`drgc7') D6=(`drgc6') E6=(`drgc5') F6=(`drgc4') G6=(`drgc3')
		H6=(`drgc2') I6=(`drgc1') J6=(`drgcyr1') K6=(`drgcyr2')
		B7=(`dri8') C7=(`dri7') D7=(`dri6') E7=(`dri5') F7=(`dri4') G7=(`dri3')
		H7=(`dri2') I7=(`dri1') J7=(`driyr1') K7=(`driyr2')
		B8=(`dfbcf8') C8=(`dfbcf7') D8=(`dfbcf6') E8=(`dfbcf5') F8=(`dfbcf4') G8=(`dfbcf3')
		H8=(`dfbcf2') I8=(`dfbcf1') J8=(`dfbcfyr1') K8=(`dfbcfyr2')
		B9=(`drx8') C9=(`drx7') D9=(`drx6') E9=(`drx5') F9=(`drx4') G9=(`drx3')
		H9=(`drx2') I9=(`drx1') J9=(`drxyr1') K9=(`drxyr2')
		B10=(`drm8') C10=(`drm7') D10=(`drm6') E10=(`drm5') F10=(`drm4') G10=(`drm3')
		H10=(`drm2') I10=(`drm1') J10=(`drmyr1') K10=(`drmyr2')
		B11=(`dprimario8') C11=(`dprimario7') D11=(`dprimario6') E11=(`dprimario5') 
		F11=(`dprimario4') G11=(`dprimario3') H11=(`dprimario2') 
		I11=(`dprimario1') J11=(`dprimarioyr1') K11=(`dprimarioyr2')
		B12=(`dmanuf8') C12=(`dmanuf7') D12=(`dmanuf6') E12=(`dmanuf5') 
		F12=(`dmanuf4') G12=(`dmanuf3')	H12=(`dmanuf2') I12=(`dmanuf1') 
		J12=(`dmanufyr1') K12=(`dmanufyr2') 
		B13=(`dserv8') C13=(`dserv7') 
		D13=(`dserv6') E13=(`dserv5') F13=(`dserv4') G13=(`dserv3')	H13=(`dserv2') 
		I13=(`dserv1') J13=(`dservyr1') K13=(`dservyr2')
		A14=("El dato del último año corresponde al crecimiento acumulado anual al último trimestre disponible")
		using "`share'/`country'_CrecTrim.xlsx", sheet("crecimiento") modify;
		};
	else {;
	putexcel A1 = ("`country': Crecimiento trimestral")
		A4=("PIB") A5=("Cons. priv.") A6=("Cons. gob.") A7=("Inversión") A8=("FBCF") A9=("Exports.")
		A10=("Imports.") A11=("Primario") A12=("Manuf.") A13=("Servicios")
		B3=("`n8'") C3=("`n7'") D3=("`n6'") E3=("`n5'") F3=("`n4'") G3=("`n3'")
		H3=("`n2'") I3=("`n1'") J3=("`year1'") K3=("`year2'") L3=("`year3'")
		B4=(`drgdp8') C4=(`drgdp7') D4=(`drgdp6') E4=(`drgdp5') F4=(`drgdp4') G4=(`drgdp3')
		H4=(`drgdp2') I4=(`drgdp1') J4=(`drgdpyr1') K4=(`drgdpyr2') L4=(`drgdpyr3')
		B5=(`drpc8') C5=(`drpc7') D5=(`drpc6') E5=(`drpc5') F5=(`drpc4') G5=(`drpc3')
		H5=(`drpc2') I5=(`drpc1') J5=(`drpcyr1') K5=(`drpcyr2') L5=(`drpcyr3')
		B6=(`drgc8') C6=(`drgc7') D6=(`drgc6') E6=(`drgc5') F6=(`drgc4') G6=(`drgc3')
		H6=(`drgc2') I6=(`drgc1') J6=(`drgcyr1') K6=(`drgcyr2') L6=(`drgcyr3')
		B7=(`dri8') C7=(`dri7') D7=(`dri6') E7=(`dri5') F7=(`dri4') G7=(`dri3')
		H7=(`dri2') I7=(`dri1') J7=(`driyr1') K7=(`driyr2') L7=(`driyr3')
		B8=(`dfbcf8') C8=(`dfbcf7') D8=(`dfbcf6') E8=(`dfbcf5') F8=(`dfbcf4') G8=(`dfbcf3')
		H8=(`dfbcf2') I8=(`dfbcf1') J8=(`dfbcfyr1') K8=(`dfbcfyr2') L8=(`dfbcfyr3')
		B9=(`drx8') C9=(`drx7') D9=(`drx6') E9=(`drx5') F9=(`drx4') G9=(`drx3')
		H9=(`drx2') I9=(`drx1') J9=(`drxyr1') K9=(`drxyr2') L9=(`drxyr3')
		B10=(`drm8') C10=(`drm7') D10=(`drm6') E10=(`drm5') F10=(`drm4') G10=(`drm3')
		H10=(`drm2') I10=(`drm1') J10=(`drmyr1') K10=(`drmyr2') L10=(`drmyr3')
		B11=(`dprimario8') C11=(`dprimario7') D11=(`dprimario6') E11=(`dprimario5') 
		F11=(`dprimario4') G11=(`dprimario3') H11=(`dprimario2') 
		I11=(`dprimario1') J11=(`dprimarioyr1') K11=(`dprimarioyr2') L11=(`dprimarioyr3')
		B12=(`dmanuf8') C12=(`dmanuf7') D12=(`dmanuf6') E12=(`dmanuf5') 
		F12=(`dmanuf4') G12=(`dmanuf3')	H12=(`dmanuf2') I12=(`dmanuf1') 
		J12=(`dmanufyr1') K12=(`dmanufyr2') L12=(`dmanufyr3')
		B13=(`dserv8') C13=(`dserv7') 
		D13=(`dserv6') E13=(`dserv5') F13=(`dserv4') G13=(`dserv3')	H13=(`dserv2') 
		I13=(`dserv1') J13=(`dservyr1') K13=(`dservyr2') L13=(`dservyr3')
		A14=("El dato del último año corresponde al crecimiento acumulado anual al último trimestre disponible")
		using "`share'/`country'_CrecTrim.xlsx", sheet("crecimiento") modify;
		};

graph dir; local graf `r(list)'; di "`graf'";
foreach x of local graf {;
	cap:erase `x';};

***********************************************************;
***********************************************************;
* GRÁFICOS INDIVIDUALES DE ALGUNOS INDICADORES DE ACTIVIDAD;
***********************************************************;
***********************************************************;

import excel using `country'.xlsx, sheet("monthly") firstrow clear;
gen t=ym(year, month); format t %tm; tsset t;

foreach var of local indmes {;
	gen d`var' = 100*(`var'/l12.`var'-1); 
	preserve; drop if d`var'==.; gsort -t; gen n = _n; sort t;
	qui sum t if n<19; local min = `r(min)'+1; local max = `r(max)';
	line d`var' t if n<19, lcolor(black) lwidth(medium) ///
	ylabel(, angle(horizontal) labsize(small) glcolor(gs13)) ///
	xlabel(`min'(4)`max', labsize(vsmall)) ///
	ytitle("") xtitle("") title(`var', size(small));
	restore;
	gr save `country'_`var'.gph, replace;
};
local pais = lower(substr("`country'", 1, 1))+ substr("`country'", 2, .);
di "`pais'";
graph dir `pais'*; local graf `r(list)';
di "`graf'";
gr combine `graf', col(3) title("`country': Indicadores mensuales seleccionados", size(small)) ///
   note("Fecha actualización: `hoy'", size(vsmall)) ///
   subtitle("(Variación interanual, últimas 18 observaciones)", size(vsmall));
   gr save `country'_indmes.gph, replace;
   gr export "`share'/5_`country'_indmes.png", width(3000) replace;
* opción ycommon es para que en el combine, todos tengan el mismo eje y;

foreach x of local graf {;
		cap:erase `x';
	};
erase `country'_indmes.gph;

****************************************;
****************************************;
* GRÁFICO CONTRIBUCIÓN AL CRECIMIENTO DA;
****************************************;
****************************************;

import excel using `country'.xlsx, sheet("quarterly") firstrow clear;
local partcrec rgdp rpc rgc ri fbcf exist rx rm;
gen q=yq(year, quarter); format q %tq;
keep q `partcrec'; order q;
tsset q;
drop if rgdp==.;
/* Crecimiento trimestral de cada variable */;
	foreach var of local partcrec {;
		gen d`var' = 100*(s4.`var'/l4.`var');
	};
/* Participación de cada componente en la DA */;
	foreach var of local partcrec {;
		gen part1_`var' = `var'/rgdp;
	};
	replace part1_rm = -part1_rm;
/* Contribución */;
	foreach var of local partcrec {;
		gen part_`var' = d`var'*l4.part1_`var';
		format part_`var' %2.1f;
	};
drop part1*; gsort -q; gen n= _n; sort q; replace n = . if n>8; quiet sum n; local nmax = `r(max)';
gen test = part_rpc + part_rgc + part_ri + part_rx + part_rm - drgdp;
sum test;
gen trim = string(q, "%tq"); labmask q, values(trim);
	graph bar part_rpc part_rgc part_fbcf part_exist part_rx part_rm if n!=., ///
	over(q, label(labsize(small))) stack ///
	legend(size(small) label(1 "Cons. Priv.") label(2 "Cons. Gob.") label(3 "FBCF") ///
	label(4 "Var. Exist.") label(5 "Exports.") label(6 "Imports.")) ///
	ylabel(, angle(horizontal) labsize(small) format(%2.1fc)) ///
	title("`country': Contribución al crecimiento interanual del PIB", size(small)) ///
	subtitle("(Últimos `nmax' trimestres)", size(vsmall));
gr export "`share'/6_`country'_contrDA.png", width(3000) replace;
