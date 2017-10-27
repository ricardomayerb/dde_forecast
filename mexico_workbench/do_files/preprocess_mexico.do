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

*import excel "V:\USR\RMAYER\cw\dde_forecast\data_pablo\Mexico.xlsx", sheet("quarterly") firstrow
*import excel "V:\USR\RMAYER\cw\dde_forecast\data_pablo\Mexico.xlsx", sheet("monthly") firstrow
 
 

 
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
 
 
 
 
 
 