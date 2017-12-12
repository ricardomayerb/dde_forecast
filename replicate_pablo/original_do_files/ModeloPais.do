*******************************************************************************
* Bridge model with SARIMAX for short-term forecasting
* by Yusuke Tateno, tateno0728@gmail.com
*******************************************************************************
* Setting
*******************************************************************************
clear all
#delimit ;
set more off ; set matsize 3000; set niceness 5;
macro drop _all; graph drop _all; mat drop _all; cap: log close;

*******************************************************************************;
* Define locals;
*******************************************************************************;
* Root folder;
local root "V:\USR\RMAYER\Proyecciones";
local exerc "Ejercicio 2017-10";
*local share "V:\DAT\DATA\Grupo_Proyecciones\Bridge_Model\Insumos";

* Elegir país;
* Desmarcar el que se usará;

*local country "Argentina";
*local country "Bolivia";
local country "Brasil";
*local country "Chile";
*local country "Colombia";
*local country "Ecuador";
*local country "Paraguay";
*local country "Peru";
*local country "Uruguay";
*local country "Venezuela";
*local country "Mexico";
*local country "Trinidad_y_Tobago";

local eval_period = 16; 		/* 1~4*5, in quarters */
local max_step 8;				/* 4 or 8, in quarters */
local stop_regtype 3;

* Indicar acá el o los pasos que se ejecutan;
local step_start = 4;
local step_stop = 4;

* Re-running Step 3? (1-Yes, 0-No) (0 la primera vez, y 1 las siguientes);
local rerun 0;
*******************************************************************************;
* Variables por país;
*******************************************************************************;
* ARGENTINA;
* Variables dependientes;
local dep_Argentina rgdp;
* Var. indep. domésticas;
local dom_Argentina emae ip construction cpi cap tot exp exp_agro imp imp_capital ///
imp_intermediate imp_consumer vta_mall vta_supermerc cemento vta_elect ///
act_eco_bra ip_bra icc_capital icc_nacional expectativa_inflacion ing_gob ///
recaud_iva cred faena;
* Var. indep. externas; 
local ext_Argentina ip_us ip_ue act_chn icf;
* Var. de shock;
local shock_Argentina psoy;
* Var. de actividad;
local act_Argentina emae;
* Var. mensuales para graficar;
local indmes_Argentina emae ip exp imp vta_supermerc recaud_iva cred vta_mall;

* BOLIVIA;
* Variables dependientes;
local dep_Bolivia rgdp;
* Var. indep. domésticas;
local dom_Bolivia igae cpi act_eco_bra ip_bra exp exp_mineral exp_hydrocarbon ///
imp imp_consumer imp_capital imp_intermediate cred m1 ing_trib ing_trib_renta
ing_vta_hidroc gto_total gto_corriente_bs gto_k;
* Var. indep. externas; 
local ext_Bolivia ip_us ip_ue act_chn icf;
* Var. de shock;
local shock_Bolivia poil;
* Var. de actividad;
local act_Bolivia igae;
* Var. mensuales para graficar;
local indmes_Bolivia igae ip exp exp_hydrocarbon imp cred ing_trib;

* BRASIL;
* Variables dependientes;
local dep_Brasil rgdp;
* Var. indep. domésticas;
local dom_Brasil retail vta_bs_k tcr ibc ip ip_mining ip_manufacturing ///
ip_capital_goods ip_intermediate_goods ip_consumer_goods ip_dura ip_nodura ///
conf_cons tot exp exp_primary imp imp_consumer imp_intermediate ///
imp_capital tax cred conf_ibre;

*conf_cons conf_emp tot exp exp_primary imp imp_consumer imp_intermediate ///

 *local dom_Brasil ibc;

* Var. indep. externas; 
*local ext_Brasil ip_us ip_ue act_chn;


* Var. de shock;
local shock_Brasil poil;
* Var. de actividad;
local act_Brasil ibc;
* Var. mensuales para graficar;
local indmes_Brasil ibc ip ip_manufacturing retail exp imp cred tax conf_ibre;

* CHILE;
* Variables dependientes;
local dep_Chile rgdp;
* Var. indep. domésticas;
local dom_Chile imacec ipec imce m1 m2 tcr exp exp_mining imp imp_consumer imp_intermediate ///
imp_capital electricity ip_ine vtas_ine vta_auto copper_output cred tot bolsa cta_fin;
* Var. indep. externas; 
local ext_Chile ip_us ip_ue act_chn icf;*/
* Var. de shock;
local shock_Chile pcopper;
* Var. de actividad;
local act_Chile imacec;
* Var. mensuales para graficar;
local indmes_Chile imacec ip_ine exp imp vtas_ine cred copper_output imce electricity;

* COLOMBIA;
* Variables dependientes;
local dep_Colombia rgdp;
* Var. indep. domésticas;
local dom_Colombia ip ip_sales ip_emp retail construction ise tot exp ///
exp_tradicional exp_notradictional imp imp_consumer imp_consumer_nd ///
imp_consumer_d imp_intermediate imp_capital m1 m2 tcr cred bolsa cta_fin;
* Var. indep. externas; 
local ext_Colombia ip_us ip_ue act_chn icf;
* Var. de shock;
local shock_Colombia poil;
* Var. de actividad;
local act_Colombia ise;
* Var. mensuales para graficar;
local indmes_Colombia ise eco ip retail exp imp cred;

* ECUADOR;
* Variables dependientes;
local dep_Ecuador rgdp;
* Var. indep. domésticas;
local dom_Ecuador ideac inar salary gto_gob oil_production oil_export_barril 
exp exp_nonoil imp imp_fuel imp_cons imp_int imp_k confianza_con m1 cred 
confianza_emp ing_gob recaud_iva gto_gob_k;
* Var. indep. externas; 
local ext_Ecuador ip_us ip_ue act_chn icf;
* Var. de shock;
local shock_Ecuador poil;
* Var. de actividad;
local act_Ecuador ideac;
* Var. mensuales para graficar;
local indmes_Ecuador ideac exp imp recaud_iva oil_production cred;

* PARAGUAY;
* Variables dependientes;
local dep_Paraguay rgdp;
* Var. indep. domésticas;
local dom_Paraguay imaep ecn vtas_super retail mat_cons exp exp_prim exp_manuf_agro ///
exp_manuf_ind exp_combus imp imp_con imp_int imp_cap cred tcr m1 m2 remesa act_eco_bra ip_bra;
* Var. indep. externas; 
local ext_Paraguay ip_us ip_ue act_chn icf;
* Var. de shock;
local shock_Paraguay psoy;
* Var. de actividad;
local act_Paraguay imaep;
* Var. mensuales para graficar;
local indmes_Paraguay imaep ecn vtas_super retail mat_cons exp imp cred;

* PERU;
* Variables dependientes;
local dep_Peru rgdp;
* Var. indep. domésticas;
local dom_Peru pib pib_primary pib_nonprimary pib_manu pib_commerce ///
pib_construction exp imp imp_consumer imp_intermediate imp_capital tot ///
expec_eco expec_indus expec_demand gto_gob_k gto_gob cred tax_cons_prod;
* Var. indep. externas; 
local ext_Peru ip_us ip_ue act_chn icf;
* Var. de shock;
local shock_Peru pcopper;
* Var. de actividad;
local act_Peru pib;
* Var. mensuales para graficar;
local indmes_Peru pib pib_manu exp imp tax_cons_prod pib_commerce cred;

* URUGUAY;
* Variables dependientes;
local dep_Uruguay rgdp;
* Var. indep. domésticas;
local dom_Uruguay ip;
local dom_Uruguay ip ipc emae_arg act_eco_bra ip_bra tot ///
exp imp imp_consumer imp_capital imp_intermediate imp_petro imp_nonpetro ///
m1 m2 iva tax cred;
* Var. indep. externas; 
local ext_Uruguay ip_us ip_ue act_chn icf;
* Var. de shock;
local shock_Uruguay psoy;
* Var. de actividad;
local act_Uruguay ip_sinancap;
* Var. mensuales para graficar;
local indmes_Uruguay ip ip_sinancap exp imp cred tax iva;

* VENEZUELA;
* Variables dependientes;
local dep_Venezuela rgdp;
* Var. indep. domésticas;
local dom_Venezuela reservas dolartoday_r ocupados desempl credit_total ///
cred_cons cred_comerc iva islr oil_prod;
* Var. indep. externas; 
local ext_Venezuela ip_us ip_ue act_chn icf;
* Var. de shock;
local shock_Venezuela poil;

* MEXICO;
* Variables dependientes;
local dep_Mexico rgdp;
* Var. independientes;
local dom_Mexico igae retail ip ip_mineral ip_energy ip_construction ///
ip_manufacturing finv consumo confianza_emp confianza_con p_exp p_imp tot ///
exp exp_petro imp imp_consumer imp_intermediate imp_capital ing_gob gto_gob ///
remesa cred tcr m1 m2 bolsa cta_fin;
* Var. externas; 
local ext_Mexico ip_us ip_ue act_chn icf;
* Var. de shock;
local shock_Mexico poil;

* Country file location;
cd "`root'/`exerc'/`country'";
* External file location;
local cd_ext "`root'/`exerc'";
* Programme file location;
local prog "`root'/DO-files";
* Demetra forecast location;
local demetra "`root'/`exerc'/`country'/Workspace_1/SAProcessing-1";
* Dependent variables;
local depvarlist "`dep_`country''";
* Domestic predictor variables;
local domlist "`dom_`country''";
* External variables;
local extlist "`ext_`country''";
* exogeneous shocks (optional);
local shocklist "`shock_`country''";
* Variable de actividad;
local act "`act_`country''";
* Variables mensuales para graficar;
local indmes "`indmes_`country''";
* rerun step 3;
local rerun `rerun';

*******************************************************************************;
* Code - DO NOT TOUCH;
*******************************************************************************;
* Import preditermined optimal ARIMA structure;
import excel using `country'.xlsx, sheet("optimal") firstrow allstring;
destring Log Mean P D Q BP BD BQ, replace;
di "`depvarlist'";
foreach var of local depvarlist {;
	mkmat Log Mean P D Q BP BD BQ if A=="quarterly - `var'", matrix(B);
	local log_`var'=B[1,1]; local mean_`var'=B[1,2];
	local p=B[1,3]; local d=B[1,4]; local q=B[1,5];
	local bp=B[1,6]; local bd=B[1,7]; local bq=B[1,8];
	local arima_`var' "arima(`p',`d',`q') sarima(`bp',`bd',`bq',4)";
	};
	di "`domlist'";
	di "`arima_`var''";
foreach var of local domlist {;
	mkmat Log Mean P D Q BP BD BQ if A=="monthly - `var'", matrix(B);
	local log_`var'=B[1,1]; local mean_`var'=B[1,2];
	local p=B[1,3]; local d=B[1,4]; local q=B[1,5];
	local bp=B[1,6]; local bd=B[1,7]; local bq=B[1,8];
	local arima_`var' "arima(`p',`d',`q') sarima(`bp',`bd',`bq',12)";
	};
clear;
import excel using "`cd_ext'\external.xlsx", sheet("optimal") firstrow allstring;
destring Log Mean P D Q BP BD BQ, replace;
foreach var of local extlist {;
	mkmat Log Mean P D Q BP BD BQ if A=="monthly - `var'", matrix(B);
	local log_`var'=B[1,1]; local mean_`var'=B[1,2];
	local p=B[1,3]; local d=B[1,4]; local q=B[1,5];
	local bp=B[1,6]; local bd=B[1,7]; local bq=B[1,8];
	local arima_`var' "arima(`p',`d',`q') sarima(`bp',`bd',`bq',12)";
	};
* Generate local.do file;
local predlist "`domlist' `extlist'";
local max_step_m = `max_step'*3;
local start_regtype 0;
file open local using local.do, replace write;
foreach var in `depvarlist' `predlist' {;
	local loglist "`loglist' log_`var'";
	local meanlist "`meanlist' mean_`var'";
	local arimalist "`arimalist' arima_`var'";
	};
foreach lname in country eval_period max_step max_step_m
	start_regtype stop_regtype depvarlist predlist domlist extlist shocklist 
	act indmes exerc root share cd_ext demetra rerun `loglist' `meanlist' `arimalist' {;
		file write local "local `lname' ``lname''" _n; };
file close local;


* Run programme files;
if `step_start'==1 {; run "`prog'\format"; };
if `step_start'<=2 & `step_stop'>=2 {; run "`prog'\q_analysis"; };
if `step_start'<=3 & `step_stop'>=3 {;
	foreach depvar of local depvarlist {;
		clear; gen year=.;
		if `rerun'==0 {;
			save temp_`depvar'.dta, replace; }; };
	run "`prog'\m_analysis"; };
if `step_start'<=4 & `step_stop'>=4 {; run "`prog'\forecast_summary"; 
include "`prog'\final_report";};
if `step_start'<=5 & `step_stop'>=5 {; include "`prog'\actividad"; };
if `step_start'<=6 & `step_stop'>=6 {; include "`prog'\ficha_CCNN"; };
/*if `step_start'<=5 & `step_stop'>=5 {; do "`prog'\graf_proyeccion_demetra";};
if `step_start'<=6 & `step_stop'>=6 {; do "`prog'\scenario"; };*/
erase local.do;
* End of the file;
