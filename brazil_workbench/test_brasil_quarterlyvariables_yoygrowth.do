* log using stata_output1.txt, text replace

clear all       
set more off 

cd C:\Users\AKLEIN\Desktop\Econometrics\Data\VarForecasting

use brasilQ_yoy, clear
* tidy the data
gen qdate = quarterly(date, "YQ")
format qdate %tq

tsset qdate
* stationarity tests
dfuller rgdp, lags(4)
dfuller rpc, lags(4)
dfuller rgc, lags(4)
dfuller ri, lags(4)
dfuller fbcf, lags(4)
dfuller exist, lags(4)
dfuller rx, lags(4)
dfuller rm, lags(4)
dfuller primario, lags(4)
dfuller manuf, lags(4)
dfuller serv, lags(4)
** stationarity is still an isse so i take first differences
dfuller D1.rgdp, lags(4)
dfuller D1.rpc, lags(4)
dfuller D1.rgc, lags(4)
dfuller D1.ri, lags(4)
dfuller D1.fbcf, lags(4)
dfuller D1.exist, lags(4)
dfuller D1.rx, lags(4)
dfuller D1.rm, lags(4)
dfuller D1.primario, lags(4)
dfuller D1.manuf, lags(4)
dfuller D1.serv, lags(4)
** stationarity issues are solved

** VAR1: rgdp, rpc, rgc, rx
varsoc D1.rgdp D1.rpc D1.rgc D1.rx, maxlag(4)
varsoc D1.rgdp D1.rpc D1.rgc D1.rx, maxlag(5)
varsoc D1.rgdp D1.rpc D1.rgc D1.rx, maxlag(6)
varsoc D1.rgdp D1.rpc D1.rgc D1.rx, maxlag(7)
varsoc D1.rgdp D1.rpc D1.rgc D1.rx, maxlag(8)
** again little messy, but i take 6 lags based on all the different tests at several max lags
* 6 lags
var D1.rgdp D1.rpc D1.rgc D1.rx, lags(1/6)

* stability test: the tests shows that the model is stable
varstable
* Lagrange multiplier test for the joint null hypothesis of no autocorrelation of the residuals
varlmar, mlag(4)
* serial correlation does not seem to be a big issue. Only at 10% level 4th lag
vargranger 
* we see that all variables help predict D_rgdp

fcast compute p_, step(6)
* we can examine these forecast values in the data browser or we can graph them
fcast graph p_D_rgdp

** we can also make in-sample forecast and make a graph in which we see the observed and predicted values
** let's say we want to predict 4 quarters ahead from 2005q3 on. First forecast 2005q4
var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2005Q4)
fcast compute p1_, step(4)
fcast graph p1_D_rgdp, observed

** generate MSE
generate mse_Drgdp = D1.rgdp - p1_D_rgdp
summarize mse_Drgdp
* the stddev is the mse

