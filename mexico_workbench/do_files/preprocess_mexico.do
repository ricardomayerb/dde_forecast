clear all
#delimit ;
set more off ; set matsize 3000; set niceness 5;
macro drop _all; graph drop _all; mat drop _all; cap: log close;

*******************************************************************************;
* Define locals;
*******************************************************************************;
* Root folder;
*local root "V:\USR\RMAYER\Proyecciones";
*local exerc "Ejercicio 2017-10";

cd "C:\Users\ricar\Documents\GitHub\dde_forecast"

import excel ".\data_pablo\Mexico.xlsx", sheet("monthly") firstrow

tsset date

gen qdate = qofd(dofm(ym(year, month)))

format qdate %tq

collapse hlookup - cta_fin , by(qdate)

tsset qdate

save ".\mexico_workbench\produced_data\mx_m_to_q.dta" , replace

clear

import excel ".\data_pablo\Mexico.xlsx", sheet("quarterly") firstrow
 
gen qdate = qofd(dofq(yq(year, quarter)))

format qdate %tq

drop date year quarter

tsset qdate

merge 1:1 qdate using ".\mexico_workbench\produced_data\mx_m_to_q.dta"

save ".\mexico_workbench\produced_data\mx_merged_q_m.dta" , replace

*import excel "V:\USR\RMAYER\cw\dde_forecast\data_pablo\Mexico.xlsx", sheet("quarterly") firstrow
*import excel "V:\USR\RMAYER\cw\dde_forecast\data_pablo\Mexico.xlsx", sheet("monthly") firstrow
 
*import excel "C:\Users\ricar\Documents\GitHub\dde_forecast\data_pablo\Mexico.xlsx", sheet("monthly") firstrow

 
* * MEXICO;
** Variables dependientes;
*local dep_Mexico rgdp;
** Var. independientes;
*local dom_Mexico igae retail ip ip_mineral ip_energy ip_construction ///
*ip_manufacturing finv consumo confianza_emp confianza_con p_exp p_imp tot ///
*exp exp_petro imp imp_consumer imp_intermediate imp_capital ing_gob gto_gob ///
*remesa cred tcr m1 m2 bolsa cta_fin;
** Var. externas; 
*local ext_Mexico ip_us ip_ue act_chn icf;
** Var. de shock;
*local shock_Mexico poil;


************************************#
**FILE LOCATIONS**
*if `"`c(os)'"' == "Windows" & `"`c(username)'"' == "ericbooth" global sf `"S:/Data//"'
*if `"`c(os)'"' == "Windows" & `"`c(username)'"' == "server" global sf `"/Volumes/shared/data//"'
*if `"`c(os)'"' == "MacOSX" & `"`c(username)'"' == "ebooth" global sf `"/volumes/sdrive/data//"'


*di `"${sf}"' //here's the base file

***subdirectories::
*global raw `"${sf}/raw//"'
*global converted `"${sf}/converted//"'
*global final `"${sf}/final//"'
*global results `"${sf}/results//"'
*global syntax `"${sf}/syntax//"'
*global latex   `"${sf}/latex//"'


*di `"The raw data is here: ${raw}"'
**on my mac laptop prints: /volumes/sdrive/data///raw//
************************************#

*dis "`c(username)'"
*dis "`c(machine_type)'"
*dis "`c(os)'" 
 
 
 
 
 
