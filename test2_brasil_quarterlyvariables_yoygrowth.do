* log using stata_output1.txt, text replace
* in case not isntalled yet: ssc install fcstats
* algorithm from Christopher F Baum, Boston College
* fcstats calculates several measures of forecast accuracy for one or two forecast
* series. The measures include root mean squared error (RMSE), mean absolute error
* (MAE), mean absolute percent error (MAPE) and Theil's U.

clear all       
set more off 

cd C:\Users\AKLEIN\Desktop\Econometrics\Data\VarForecasting

use brasilQ_yoy, clear
* tidy the data
gen qdate = quarterly(date, "YQ")
format qdate %tq

tsset qdate
* stationarity tests

* we calculate ca = exports - imports
generate ca = (rx-rm)

* VAR 5
qui var D1.rgdp D1.rpc D1.rgc D1.ri, lags(1/4)
*VAR 7:
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/4)
*VAR 8: 
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario, lags(1/6)
*VAR 9:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/6)

* VAR 5 and 7 seem to be the best allround models. Lets play around with their specification to see whether we can improve them 
* VAR 10: VAR 5 but then with 3 lags
qui var D1.rgdp D1.rpc D1.rgc D1.ri, lags(1/3)
* VAR 11: VAR 7 but then with 3 lags
qui var D1.rgdp D1.rpc D1.rgc D1.ca, lags(1/3)
* VAR 12: VAR 8 but then with 3 lags
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario, lags(1/3)
* VAR 13: VAR 9 but then with 3 lags
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario, lags(1/3)


* period1 
* h =1 
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/3)
fcast compute p0001_, step(1)
fcstats D1.rgdp p0001_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/3)
fcast compute p0002_, step(1)
fcstats D1.rgdp p0002_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0003_, step(1)
fcstats D1.rgdp p0003_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0004_, step(1)
fcstats D1.rgdp p0004_D_rgdp

* h = 2 
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/3)
fcast compute p0005_, step(2)
fcstats D1.rgdp p0005_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/3)
fcast compute p0006_, step(2)
fcstats D1.rgdp p0006_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0007_, step(2)
fcstats D1.rgdp p0007_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0008_, step(2)
fcstats D1.rgdp p0008_D_rgdp

* h = 3 
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/3)
fcast compute p0009_, step(3)
fcstats D1.rgdp p0009_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/3)
fcast compute p0010_, step(3)
fcstats D1.rgdp p0010_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0011_, step(3)
fcstats D1.rgdp p0011_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0012_, step(3)
fcstats D1.rgdp p0012_D_rgdp

* h = 4 
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/3)
fcast compute p0013_, step(4)
fcstats D1.rgdp p0013_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/3)
fcast compute p0014_, step(4)
fcstats D1.rgdp p0014_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0015_, step(4)
fcstats D1.rgdp p0015_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0016_, step(4)
fcstats D1.rgdp p0016_D_rgdp

* h = 5 
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/3)
fcast compute p0017_, step(5)
fcstats D1.rgdp p0017_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/3)
fcast compute p0018_, step(5)
fcstats D1.rgdp p0018_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0019_, step(5)
fcstats D1.rgdp p0019_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0020_, step(5)
fcstats D1.rgdp p0020_D_rgdp

* h = 6 
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/3)
fcast compute p0021_, step(6)
fcstats D1.rgdp p0021_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/3)
fcast compute p0022_, step(6)
fcstats D1.rgdp p0022_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0023_, step(6)
fcstats D1.rgdp p0023_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0024_, step(6)
fcstats D1.rgdp p0024_D_rgdp

* h = 8 
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/3)
fcast compute p0029_, step(8)
fcstats D1.rgdp p0029_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/3)
fcast compute p0030_, step(8)
fcstats D1.rgdp p0030_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0031_, step(8)
fcstats D1.rgdp p0031_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/3)
fcast compute p0032_, step(8)
fcstats D1.rgdp p0032_D_rgdp

*h=8
graph twoway line p0029_D_rgdp p0030_D_rgdp p0031_D_rgdp p0032_D_rgdp D1.rgdp qdate if qdate>tq(2009Q2) & qdate<tq(2012Q2)

* I have tried several lags and several horizons. And i found that 3 lags can severly improve the model
*lag 3 improves the model from h=4 on

* period2 

* h = 1
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/3)
fcast compute p0033_, step(1)
fcstats D1.rgdp p0033_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/3)
fcast compute p0034_, step(1)
fcstats D1.rgdp p0034_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0035_, step(1)
fcstats D1.rgdp p0035_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0036_, step(1)
fcstats D1.rgdp p0036_D_rgdp

* h = 2
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/3)
fcast compute p0037_, step(2)
fcstats D1.rgdp p0037_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/3)
fcast compute p0038_, step(2)
fcstats D1.rgdp p0038_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0039_, step(2)
fcstats D1.rgdp p0039_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0040_, step(2)
fcstats D1.rgdp p0040_D_rgdp

* h = 3
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/3)
fcast compute p0041_, step(3)
fcstats D1.rgdp p0041_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/3)
fcast compute p0042_, step(3)
fcstats D1.rgdp p0042_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0043_, step(3)
fcstats D1.rgdp p0043_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0044_, step(3)
fcstats D1.rgdp p0044_D_rgdp

* h = 4
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/3)
fcast compute p0045_, step(4)
fcstats D1.rgdp p0045_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/3)
fcast compute p0046_, step(4)
fcstats D1.rgdp p0046_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0047_, step(4)
fcstats D1.rgdp p0047_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0048_, step(4)
fcstats D1.rgdp p0048_D_rgdp

* h = 5
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/3)
fcast compute p0049_, step(5)
fcstats D1.rgdp p0049_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/3)
fcast compute p0050_, step(5)
fcstats D1.rgdp p0050_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0051_, step(5)
fcstats D1.rgdp p0051_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0052_, step(5)
fcstats D1.rgdp p0052_D_rgdp

* h = 6
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/3)
fcast compute p0053_, step(6)
fcstats D1.rgdp p0053_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/3)
fcast compute p0054_, step(6)
fcstats D1.rgdp p0054_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0055_, step(6)
fcstats D1.rgdp p0055_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0056_, step(6)
fcstats D1.rgdp p0056_D_rgdp

* h = 8
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/3)
fcast compute p0057_, step(8)
fcstats D1.rgdp p0057_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/3)
fcast compute p0058_, step(8)
fcstats D1.rgdp p0058_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0059_, step(8)
fcstats D1.rgdp p0059_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/3)
fcast compute p0060_, step(8)
fcstats D1.rgdp p0060_D_rgdp

*h=8
graph twoway line p0057_D_rgdp p0058_D_rgdp p0059_D_rgdp p0060_D_rgdp D1.rgdp qdate if qdate>tq(2011Q2) & qdate<tq(2014Q3)

* period3 

* h = 1
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/3)
fcast compute p0061_, step(1)
fcstats D1.rgdp p0061_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/3)
fcast compute p0062_, step(1)
fcstats D1.rgdp p0062_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0063_, step(1)
fcstats D1.rgdp p0063_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0064_, step(1)
fcstats D1.rgdp p0064_D_rgdp

* h = 2
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/3)
fcast compute p0065_, step(2)
fcstats D1.rgdp p0065_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/3)
fcast compute p0066_, step(2)
fcstats D1.rgdp p0066_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0067_, step(2)
fcstats D1.rgdp p0067_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0068_, step(2)
fcstats D1.rgdp p0068_D_rgdp

* h = 3
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/3)
fcast compute p0069_, step(3)
fcstats D1.rgdp p0069_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/3)
fcast compute p0070_, step(3)
fcstats D1.rgdp p0070_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0071_, step(3)
fcstats D1.rgdp p0071_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0072_, step(3)
fcstats D1.rgdp p0072_D_rgdp

* h = 4
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/3)
fcast compute p0073_, step(4)
fcstats D1.rgdp p0073_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/3)
fcast compute p0074_, step(4)
fcstats D1.rgdp p0074_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0075_, step(4)
fcstats D1.rgdp p0075_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0076_, step(4)
fcstats D1.rgdp p0076_D_rgdp

* h = 5
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/3)
fcast compute p0077_, step(5)
fcstats D1.rgdp p0077_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/3)
fcast compute p0078_, step(5)
fcstats D1.rgdp p0078_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0079_, step(5)
fcstats D1.rgdp p0079_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0080_, step(5)
fcstats D1.rgdp p0080_D_rgdp

* h = 6
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/3)
fcast compute p0081_, step(6)
fcstats D1.rgdp p0081_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/3)
fcast compute p0082_, step(6)
fcstats D1.rgdp p0082_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0083_, step(6)
fcstats D1.rgdp p0083_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0084_, step(6)
fcstats D1.rgdp p0084_D_rgdp

* h = 8
* VAR10
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/3)
fcast compute p0085_, step(8)
fcstats D1.rgdp p0085_D_rgdp
* VAR11
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/3)
fcast compute p0086_, step(8)
fcstats D1.rgdp p0086_D_rgdp
* VAR 12:
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0087_, step(8)
fcstats D1.rgdp p0087_D_rgdp
* VAR 13:
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/3)
fcast compute p0088_, step(8)
fcstats D1.rgdp p0088_D_rgdp


*h=8
graph twoway line p0085_D_rgdp p0086_D_rgdp p0087_D_rgdp p0088_D_rgdp D1.rgdp qdate if qdate>tq(2013Q1) & qdate<tq(2016Q1)


** next move: experiment with fbcf and ask pablo if he can run the command
