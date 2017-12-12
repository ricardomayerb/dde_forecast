* log using stata_output1.txt, text replace
* in case not isntalled yet: ssc install fcstats
* algorithm from Christopher F Baum, Boston College
* fcstats calculates several measures of forecast accuracy for one or two forecast
* series. The measures include root mean squared error (RMSE), mean absolute error
* (MAE), mean absolute percent error (MAPE) and Theil's U.

clear all       
set more off 

* cd C:\Users\AKLEIN\Desktop\Econometrics\Data\VarForecasting

use brasilQ_yoy, clear
* tidy the data
gen qdate = quarterly(date, "YQ")
format qdate %tq

tsset qdate
* stationarity tests

* we calculate ca = exports - imports
generate ca = (rx-rm)


**** THE OLD MODELS ****
* VAR 5
qui var D1.rgdp D1.rpc D1.rgc D1.ri, lags(1/4)
*VAR 7:
qui var D1.rgdp D1.rpc D1.rgc D1.ca, lags(1/4)
*VAR 8: 
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario, lags(1/6)
*VAR 9:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario, lags(1/6)

* VAR 10: VAR 5 but then with 3 lags
qui var D1.rgdp D1.rpc D1.rgc D1.ri, lags(1/3)
* VAR 11: VAR 7 but then with 3 lags
qui var D1.rgdp D1.rpc D1.rgc D1.ca, lags(1/3)
* VAR 12: VAR 8 but then with 3 lags
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario, lags(1/3)
* VAR 13: VAR 9 but then with 3 lags
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario, lags(1/3)

**** THE NEW MODELS ****
*VAR 14:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario, lags(1/6)
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf, lags(1/6)
*VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario, lags(1/3)
*VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf, lags(1/3)
*VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca, lags(1/4)
*VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca, lags(1/6)
***VAR14 AND 15 PERFORM VERY WELL WITH 3 LAGS, HOWEVER WITH 3 LAGS THE LAGRANGE MULTIPLIER TEST SHOWS BIG PROBLEMS OF AUTOCORRELATION IN THE RESIDUALS ***
*** FORECASTS ARE STILL UNBIASED WITH THE PRESENCE OF AUTOCORRELATED RESIDUALS, BUT THEY CAN BE INEFFICIENT. IN GENERAL MODELS WITHOUT AUTOCORRELATED RESIDUALS 
*** WILL FORECAST BETTER. NONETHELESS, I WILL TRY OUT BOTH VERSIONS OF THE MODEL. WITH 3 AND 6 LAGS. 

** LETS PUT THE MODELS TO THE TEST **
* period1 
* h =1 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p0001_, step(1)
fcstats D1.rgdp p0001_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/6)
fcast compute p0002_, step(1)
fcstats D1.rgdp p0002_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0003_, step(1)
fcstats D1.rgdp p0003_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/3)
fcast compute p0004_, step(1)
fcstats D1.rgdp p0004_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p005_, step(1)
fcstats D1.rgdp p005_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/6)
fcast compute p006_, step(1)
fcstats D1.rgdp p006_D_rgdp

* h = 2 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p0005_, step(2)
fcstats D1.rgdp p0005_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/6)
fcast compute p0006_, step(2)
fcstats D1.rgdp p0006_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0007_, step(2)
fcstats D1.rgdp p0007_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/3)
fcast compute p0008_, step(2)
fcstats D1.rgdp p0008_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p009_, step(2)
fcstats D1.rgdp p009_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/6)
fcast compute p010_, step(2)
fcstats D1.rgdp p010_D_rgdp

* h = 3 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p0009_, step(3)
fcstats D1.rgdp p0009_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/6)
fcast compute p0010_, step(3)
fcstats D1.rgdp p0010_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0011_, step(3)
fcstats D1.rgdp p0011_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/3)
fcast compute p0012_, step(3)
fcstats D1.rgdp p0012_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p013_, step(3)
fcstats D1.rgdp p013_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/6)
fcast compute p014_, step(3)
fcstats D1.rgdp p014_D_rgdp
* h = 4 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p0013_, step(4)
fcstats D1.rgdp p0013_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/6)
fcast compute p0014_, step(4)
fcstats D1.rgdp p0014_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0015_, step(4)
fcstats D1.rgdp p0015_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/3)
fcast compute p0016_, step(4)
fcstats D1.rgdp p0016_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p017_, step(4)
fcstats D1.rgdp p017_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/6)
fcast compute p018_, step(4)
fcstats D1.rgdp p018_D_rgdp

* h = 5 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p0017_, step(5)
fcstats D1.rgdp p0017_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/6)
fcast compute p0018_, step(5)
fcstats D1.rgdp p0018_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0019_, step(5)
fcstats D1.rgdp p0019_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/3)
fcast compute p0020_, step(5)
fcstats D1.rgdp p0020_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p021_, step(5)
fcstats D1.rgdp p021_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/6)
fcast compute p022_, step(5)
fcstats D1.rgdp p022_D_rgdp

* h = 6 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p0021_, step(6)
fcstats D1.rgdp p0021_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/6)
fcast compute p0022_, step(6)
fcstats D1.rgdp p0022_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0023_, step(6)
fcstats D1.rgdp p0023_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/3)
fcast compute p0024_, step(6)
fcstats D1.rgdp p0024_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p025_, step(6)
fcstats D1.rgdp p025_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/6)
fcast compute p026_, step(6)
fcstats D1.rgdp p026_D_rgdp



* h = 8 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p0029_, step(8)
fcstats D1.rgdp p0029_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/6)
fcast compute p0030_, step(8)
fcstats D1.rgdp p0030_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0031_, step(8)
fcstats D1.rgdp p0031_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/3)
fcast compute p0032_, step(8)
fcstats D1.rgdp p0032_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p033_, step(8)
fcstats D1.rgdp p033_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/6)
fcast compute p034_, step(8)
fcstats D1.rgdp p034_D_rgdp

*h=8
graph twoway line p0029_D_rgdp p0030_D_rgdp p0031_D_rgdp p0032_D_rgdp p033_D_rgdp p034_D_rgdp D1.rgdp qdate if qdate>tq(2009Q2) & qdate<tq(2012Q2)

* period2: 2012Q2

* h =1 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p0035_, step(1)
fcstats D1.rgdp p0035_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/6)
fcast compute p0036_, step(1)
fcstats D1.rgdp p0036_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0037_, step(1)
fcstats D1.rgdp p0037_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/3)
fcast compute p0038_, step(1)
fcstats D1.rgdp p0038_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p0039_, step(1)
fcstats D1.rgdp p0039_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/6)
fcast compute p0040_, step(1)
fcstats D1.rgdp p0040_D_rgdp

* h = 2 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p0041_, step(2)
fcstats D1.rgdp p0041_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/6)
fcast compute p0042_, step(2)
fcstats D1.rgdp p0042_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0043_, step(2)
fcstats D1.rgdp p0043_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/3)
fcast compute p0044_, step(2)
fcstats D1.rgdp p0044_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p0045_, step(2)
fcstats D1.rgdp p0045_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/6)
fcast compute p0046_, step(2)
fcstats D1.rgdp p0046_D_rgdp

* h = 3 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p0047_, step(3)
fcstats D1.rgdp p0047_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/6)
fcast compute p0048_, step(3)
fcstats D1.rgdp p0048_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0049_, step(3)
fcstats D1.rgdp p0049_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/3)
fcast compute p0050_, step(3)
fcstats D1.rgdp p0050_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p0051_, step(3)
fcstats D1.rgdp p0051_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/6)
fcast compute p0052_, step(3)
fcstats D1.rgdp p0052_D_rgdp
* h = 4 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p0053_, step(4)
fcstats D1.rgdp p0053_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/6)
fcast compute p0054_, step(4)
fcstats D1.rgdp p0054_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0055_, step(4)
fcstats D1.rgdp p0055_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/3)
fcast compute p0056_, step(4)
fcstats D1.rgdp p0056_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p057_, step(4)
fcstats D1.rgdp p057_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/6)
fcast compute p058_, step(4)
fcstats D1.rgdp p058_D_rgdp

* h = 5 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p0059_, step(5)
fcstats D1.rgdp p0059_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/6)
fcast compute p0060_, step(5)
fcstats D1.rgdp p0060_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0061_, step(5)
fcstats D1.rgdp p0061_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/3)
fcast compute p0062_, step(5)
fcstats D1.rgdp p0062_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p0063_, step(5)
fcstats D1.rgdp p0063_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/6)
fcast compute p0064_, step(5)
fcstats D1.rgdp p0064_D_rgdp

* h = 6 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p0065_, step(6)
fcstats D1.rgdp p0065_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/6)
fcast compute p0066_, step(6)
fcstats D1.rgdp p0066_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0067_, step(6)
fcstats D1.rgdp p0067_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/3)
fcast compute p0068_, step(6)
fcstats D1.rgdp p0068_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p0069_, step(6)
fcstats D1.rgdp p0069_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/6)
fcast compute p0070_, step(6)
fcstats D1.rgdp p0070_D_rgdp



* h = 8 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p0071_, step(8)
fcstats D1.rgdp p0071_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/6)
fcast compute p0072_, step(8)
fcstats D1.rgdp p0072_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0073_, step(8)
fcstats D1.rgdp p0073_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/3)
fcast compute p0074_, step(8)
fcstats D1.rgdp p0074_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p0075_, step(8)
fcstats D1.rgdp p0075_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/6)
fcast compute p0076_, step(8)
fcstats D1.rgdp p0076_D_rgdp


* period3: 2013q4

* h =1 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/6)
fcast compute p0077_, step(1)
fcstats D1.rgdp p0077_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/6)
fcast compute p0078_, step(1)
fcstats D1.rgdp p0078_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0079_, step(1)
fcstats D1.rgdp p0079_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/3)
fcast compute p0080_, step(1)
fcstats D1.rgdp p0080_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p0081_, step(1)
fcstats D1.rgdp p0081_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/6)
fcast compute p0082_, step(1)
fcstats D1.rgdp p0082_D_rgdp

* h = 2 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/6)
fcast compute p0083_, step(2)
fcstats D1.rgdp p0083_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/6)
fcast compute p0084_, step(2)
fcstats D1.rgdp p0084_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0085_, step(2)
fcstats D1.rgdp p0085_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/3)
fcast compute p0086_, step(2)
fcstats D1.rgdp p0086_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p0087_, step(2)
fcstats D1.rgdp p0087_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/6)
fcast compute p0088_, step(2)
fcstats D1.rgdp p0088_D_rgdp

* h = 3 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/6)
fcast compute p0089_, step(3)
fcstats D1.rgdp p0089_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/6)
fcast compute p0090_, step(3)
fcstats D1.rgdp p0090_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0091_, step(3)
fcstats D1.rgdp p0091_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/3)
fcast compute p0092_, step(3)
fcstats D1.rgdp p0092_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p000092_, step(3)
fcstats D1.rgdp p000092_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/6)
fcast compute p0093_, step(3)
fcstats D1.rgdp p0093_D_rgdp
* h = 4 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/6)
fcast compute p0094_, step(4)
fcstats D1.rgdp p0094_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/6)
fcast compute p0095_, step(4)
fcstats D1.rgdp p0095_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0096_, step(4)
fcstats D1.rgdp p0096_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/3)
fcast compute p0097_, step(4)
fcstats D1.rgdp p0097_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p098_, step(4)
fcstats D1.rgdp p098_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/6)
fcast compute p099_, step(4)
fcstats D1.rgdp p099_D_rgdp

* h = 5 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/6)
fcast compute p0100_, step(5)
fcstats D1.rgdp p0100_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/6)
fcast compute p0101_, step(5)
fcstats D1.rgdp p0101_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0102_, step(5)
fcstats D1.rgdp p0102_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/3)
fcast compute p0103_, step(5)
fcstats D1.rgdp p0103_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p0104_, step(5)
fcstats D1.rgdp p0104_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/6)
fcast compute p0105_, step(5)
fcstats D1.rgdp p0105_D_rgdp

* h = 6 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/6)
fcast compute p0106_, step(6)
fcstats D1.rgdp p0106_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/6)
fcast compute p0107_, step(6)
fcstats D1.rgdp p0107_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0108_, step(6)
fcstats D1.rgdp p0108_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/3)
fcast compute p0109_, step(6)
fcstats D1.rgdp p0109_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p0110_, step(6)
fcstats D1.rgdp p0110_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/6)
fcast compute p0111_, step(6)
fcstats D1.rgdp p0111_D_rgdp



* h = 8 
* VAR14
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/6)
fcast compute p0112_, step(8)
fcstats D1.rgdp p0112_D_rgdp
*VAR 15:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/6)
fcast compute p0113_, step(8)
fcstats D1.rgdp p0113_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0114_, step(8)
fcstats D1.rgdp p0114_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013q4), lags(1/3)
fcast compute p0115_, step(8)
fcstats D1.rgdp p0115_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p0116_, step(8)
fcstats D1.rgdp p0116_D_rgdp
* VAR 19:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013q4), lags(1/6)
fcast compute p0117_, step(8)
fcstats D1.rgdp p0117_D_rgdp

* TheilU is considered as the most reliable measure:
* Best overall: VAR7 & VAR17
* Second bests: VAR12 (performs very well in terms of the traditional measures RMSE and MAE)
*Third Best: VAR 18 & VAR 16

*For each period i have put these VARs together in a graph and compare their forecasts to the realized values in each period for h=8

*Period 1
*VAR 7:
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute pVAR7_, step(8)
fcstats D1.rgdp pVAR7_D_rgdp
*VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/3) 
fcast compute pVAR12_, step(8)
fcstats D1.rgdp pVAR12_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2010q1), lags(1/3)
fcast compute pVAR16_, step(8)
fcstats D1.rgdp pVAR16_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2010Q1), lags(1/3)
fcast compute pVAR17_, step(8)
fcstats D1.rgdp pVAR17_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute pVAR18_, step(8)
fcstats D1.rgdp pVAR18_D_rgdp

graph twoway line pVAR7_D_rgdp pVAR12_D_rgdp pVAR16_D_rgdp pVAR17_D_rgdp pVAR18_D_rgdp D1.rgdp qdate if qdate>tq(2009Q2) & qdate<tq(2012Q2)

*Period 2
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute pVAR7b_, step(8)
fcstats D1.rgdp pVAR7b_D_rgdp
*VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/3) 
fcast compute pVAR12b_, step(8)
fcstats D1.rgdp pVAR12b_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2012q2), lags(1/3)
fcast compute pVAR16b_, step(8)
fcstats D1.rgdp pVAR16b_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2012Q2), lags(1/3)
fcast compute pVAR17b_, step(8)
fcstats D1.rgdp pVAR17b_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute pVAR18b_, step(8)
fcstats D1.rgdp pVAR18b_D_rgdp

graph twoway line pVAR7b_D_rgdp pVAR12b_D_rgdp pVAR16b_D_rgdp pVAR17b_D_rgdp pVAR18b_D_rgdp D1.rgdp qdate if qdate>tq(2011Q4) & qdate<tq(2014Q3)

*Period 3
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013Q4), lags(1/4)
fcast compute pVAR7c_, step(8)
fcstats D1.rgdp pVAR7c_D_rgdp
*VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013Q4), lags(1/3) 
fcast compute pVAR12c_, step(8)
fcstats D1.rgdp pVAR12c_D_rgdp
* VAR 16:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf primario if qdate<tq(2013q4), lags(1/3)
fcast compute pVAR16c_, step(8)
fcstats D1.rgdp pVAR16c_D_rgdp
* VAR 17:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.fbcf if qdate<tq(2013Q4), lags(1/3)
fcast compute pVAR17c_, step(8)
fcstats D1.rgdp pVAR17c_D_rgdp
* VAR 18:
qui var D1.rgdp D1.rpc D1.rgc D1.fbcf D1.ca if qdate<tq(2013Q4), lags(1/4)
fcast compute pVAR18c_, step(8)
fcstats D1.rgdp pVAR18c_D_rgdp

graph twoway line pVAR7c_D_rgdp pVAR12c_D_rgdp pVAR16c_D_rgdp pVAR17c_D_rgdp pVAR18c_D_rgdp D1.rgdp qdate if qdate>tq(2013Q2) & qdate<tq(2016Q1)
