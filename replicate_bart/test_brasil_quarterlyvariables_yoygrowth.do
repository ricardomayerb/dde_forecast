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
* 6 lags. 
var D1.rgdp D1.rpc D1.rgc D1.rx, lags(1/6)

* stability test: the tests shows that the model is stable
varstable
* Lagrange multiplier test for the joint null hypothesis of no autocorrelation of the residuals
varlmar, mlag(4)
* serial correlation does not seem to be a big issue. Only at 10% level 4th lag
vargranger 
* we see that all variables help predict D_rgdp

fcast compute p_, step(6)
fcstats D1.rgdp p_D_rgdp
* we can examine these forecast values in the data browser or we can graph them
fcast graph p_D_rgdp

** we can also make in-sample forecast and make a graph in which we see the observed and predicted values
** let's say we want to predict 4 quarters ahead from 2005q3 on. First forecast 2005q4
var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2010Q1), lags(1/6)
*Note: I am not sure if i can still put the lags behind here but i think i can and have to. I did not do that before. 
fcast compute p1_, step(8)
fcstats D1.rgdp p1_D_rgdp
fcast graph p1_D_rgdp, observed

** generate MSE
generate mse_Drgdp = D1.rgdp - p1_D_rgdp
summarize mse_Drgdp
* the stddev is the mse

** VAR2: rgdp, rpc, ri, rx. Based on granger I try out to drop rgc and plug in ri
varsoc D1.rgdp D1.rpc D1.ri D1.rx, maxlag(4)
varsoc D1.rgdp D1.rpc D1.ri D1.rx, maxlag(5)
varsoc D1.rgdp D1.rpc D1.ri D1.rx, maxlag(6)
varsoc D1.rgdp D1.rpc D1.ri D1.rx, maxlag(7)
varsoc D1.rgdp D1.rpc D1.ri D1.rx, maxlag(8)

** very confusing again. i for 5 lags
var D1.rgdp D1.rpc D1.ri D1.rx, lags(1/5)
* stability test: the tests shows that the model is stable
varstable
* Lagrange multiplier test for the joint null hypothesis of no autocorrelation of the residuals
varlmar, mlag(4)
* serial correlation does not seem to be a big issue at 5% level. Only at 10% level 1th and 4th lag
vargranger 
* all variables seem to explain ri very well but the other relationships are less significant than before
fcast compute p2_, step(6)
* we can examine these forecast values in the data browser or we can graph them
fcast graph p2_D_rgdp

** we can also make in-sample forecast and make a graph in which we see the observed and predicted values
** let's say we want to predict 4 quarters ahead from 2005q3 on. First forecast 2005q4
var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/5)
fcast compute p3_, step(8)
fcast graph p3_D_rgdp, observed
fcstats D1.rgdp p3_D_rgdp

** generate MSE
generate mse_1Drgdp = D1.rgdp - p3_D_rgdp
summarize mse_1Drgdp

** VAR3: rgdp, rpc, rgc, ri, rx
varsoc D1.rgdp D1.rpc D1.rgc D1.ri D1.rx, maxlag(4)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri D1.rx, maxlag(5)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri D1.rx, maxlag(6)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri D1.rx, maxlag(7)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri D1.rx, maxlag(8)
** very confusing again. i opt for 6 lags
var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx, lags(1/6)
* stability test: the tests shows that the model is stable
varstable
* Lagrange multiplier test for the joint null hypothesis of no autocorrelation of the residuals
varlmar, mlag(4)
* serial correlation does not seem to be a big issue at 5% level. Only at 10% level 2th lag
vargranger

fcast compute p4_, step(6)
* we can examine these forecast values in the data browser or we can graph them
fcast graph p4_D_rgdp

** we can also make in-sample forecast and make a graph in which we see the observed and predicted values
** let's say we want to predict 4 quarters ahead from 2005q3 on. First forecast 2005q4
var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p5_, step(8)
fcast graph p5_D_rgdp, observed

** VAR4: rgdp, rpc, rgc, ri
varsoc D1.rgdp D1.rpc D1.rgc D1.ri, maxlag(4)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri, maxlag(5)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri, maxlag(6)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri, maxlag(7)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri, maxlag(8)
** very confusing again. i opt for 6 lags
var D1.rgdp D1.rpc D1.rgc D1.ri, lags(1/6)
* stability test: the tests shows that the model is stable
varstable
* Lagrange multiplier test for the joint null hypothesis of no autocorrelation of the residuals
varlmar, mlag(4)
* serial correlation does not seem to be an issue
vargranger

fcast compute p6_, step(6)
* we can examine these forecast values in the data browser or we can graph them
fcast graph p6_D_rgdp

** we can also make in-sample forecast and make a graph in which we see the observed and predicted values
** let's say we want to predict 4 quarters ahead from 2005q3 on. First forecast 2005q4
var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/6)
fcast compute p7_, step(8)
fcast graph p7_D_rgdp, observed

* show the in-sample predictions of all models in one graph and compare
graph twoway line p1_D_rgdp p3_D_rgdp p5_D_rgdp p7_D_rgdp D1.rgdp qdate if qdate>tq(2009Q4) & qdate<tq(2012Q2)
fcstats D1.rgdp p1_D_rgdp
fcstats D1.rgdp p3_D_rgdp
fcstats D1.rgdp p5_D_rgdp
fcstats D1.rgdp p7_D_rgdp

*VAR 5:same model but with 4 lags
var D1.rgdp D1.rpc D1.rgc D1.ri, lags(1/4)
* stability test: the tests shows that the model is stable
varstable
* Lagrange multiplier test for the joint null hypothesis of no autocorrelation of the residuals
varlmar, mlag(4)
* serial correlation does not seem to be an issue
vargranger
var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/4)
fcast compute p9_, step(8)
fcast graph p9_D_rgdp, observed
fcstats D1.rgdp p7_D_rgdp
fcstats D1.rgdp p9_D_rgdp
*4 lag models seem to have a better in sample fit
*VAR 6:same model but different order
var D1.rgc D1.ri D1.rpc D1.rgdp, lags(1/4)
* stability test: the tests shows that the model is stable
varstable
* Lagrange multiplier test for the joint null hypothesis of no autocorrelation of the residuals
varlmar, mlag(4)
* serial correlation does not seem to be an issue
vargranger
var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/4)
fcast compute p11_, step(8)
fcast graph p11_D_rgdp, observed
fcstats D1.rgdp p7_D_rgdp
fcstats D1.rgdp p9_D_rgdp
fcstats D1.rgdp p11_D_rgdp
* as you can see changing order doesnt matter for forecasting results
*VAR 7: we calculate ca = exports - imports
generate ca = (rx-rm)
var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p13_, step(8)
fcast graph p13_D_rgdp, observed
fcstats D1.rgdp p13_D_rgdp
*VAR 7 does not seem to improve the other models
*VAR 8: we add primario
varsoc D1.rgdp D1.rpc D1.rgc D1.ri D1.primario, maxlag(4)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri D1.primario, maxlag(5)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri D1.primario, maxlag(6)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri D1.primario, maxlag(7)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri D1.primario, maxlag(8)
* choose 6 lags
var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario, lags(1/6)
* stability test: the tests shows that the model is stable
varstable
* Lagrange multiplier test for the joint null hypothesis of no autocorrelation of the residuals
varlmar, mlag(4)
* serial correlation does not seem to be a big issue at 5% level. Only at 10% level 1th and 4th lag
vargranger 
var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p15_, step(8)
fcast graph p15_D_rgdp, observed
fcstats D1.rgdp p15_D_rgdp
fcstats D1.rgdp p7_D_rgdp
fcstats D1.rgdp p9_D_rgdp
fcstats D1.rgdp p11_D_rgdp
*VAR 8: this is the best model so far
*VAR 9: primario is one of the variables that is also stationary without taking D1, so lets try that out

varsoc D1.rgdp D1.rpc D1.rgc D1.ri primario, maxlag(4)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri primario, maxlag(5)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri primario, maxlag(6)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri primario, maxlag(7)
varsoc D1.rgdp D1.rpc D1.rgc D1.ri primario, maxlag(8)
* choose 6 lags
var D1.rgdp D1.rpc D1.rgc D1.ri primario, lags(1/6)
* stability test: the tests shows that the model is stable
varstable
* Lagrange multiplier test for the joint null hypothesis of no autocorrelation of the residuals
varlmar, mlag(4)
* serial correlation does not seem to be a big issue at 5% level. Only at 10% level 1th and 4th lag
vargranger
var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p17_, step(8)
fcast graph p17_D_rgdp, observed
fcstats D1.rgdp p17_D_rgdp
fcstats D1.rgdp p15_D_rgdp
fcstats D1.rgdp p7_D_rgdp
fcstats D1.rgdp p9_D_rgdp
fcstats D1.rgdp p11_D_rgdp
* VAR9 performs slightly better than VAR8 it seems
*forecast 8q ahead is quite far ahead given the use of dynamic forecast they quickly deteriorate in accuracy
var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p19_, step(4)
fcast graph p19_D_rgdp, observed
fcstats D1.rgdp p19_D_rgdp
fcstats D1.rgdp p17_D_rgdp
*overview of all the models at h=8
fcstats D1.rgdp p1_D_rgdp
fcstats D1.rgdp p3_D_rgdp
fcstats D1.rgdp p5_D_rgdp
fcstats D1.rgdp p7_D_rgdp
fcstats D1.rgdp p9_D_rgdp
fcstats D1.rgdp p13_D_rgdp
fcstats D1.rgdp p15_D_rgdp
fcstats D1.rgdp p17_D_rgdp

* So to make it better representable. These are all the models for h=8
* VAR1
fcstats D1.rgdp p1_D_rgdp
* VAR2
fcstats D1.rgdp p3_D_rgdp
* VAR3
fcstats D1.rgdp p5_D_rgdp
* VAR4
fcstats D1.rgdp p7_D_rgdp
* VAR5
fcstats D1.rgdp p9_D_rgdp
* VAR7
fcstats D1.rgdp p13_D_rgdp
* VAR8
fcstats D1.rgdp p15_D_rgdp
* VAR9
fcstats D1.rgdp p17_D_rgdp

gen var001 = (p9_D_rgdp+p13_D_rgdp+p15_D_rgdp+p17_D_rgdp)/4
fcstats D1.rgdp var001
pwcorr D1.rgdp p1_D_rgdp p3_D_rgdp p5_D_rgdp p7_D_rgdp p9_D_rgdp p13_D_rgdp p15_D_rgdp p17_D_rgdp, sig obs
* so over 8 quarters VAR9 was the most accurate but over 4q ahead it performs a lot better than over 8q
* Theil's U is finally far below 1 meaning that the model performs better than the naive model (Yt+1=Yt)
* lets make a h=1 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p501_, step(1)
fcstats D1.rgdp p501_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/5)
fcast compute p502_, step(1)
fcstats D1.rgdp p502_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p503_, step(1)
fcstats D1.rgdp p503_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/6)
fcast compute p504_, step(1)
fcstats D1.rgdp p504_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/4)
fcast compute p505_, step(1)
fcstats D1.rgdp p505_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p506_, step(1)
fcstats D1.rgdp p506_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p507_, step(1)
fcstats D1.rgdp p507_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p508_, step(1)
fcstats D1.rgdp p508_D_rgdp
pwcorr D1.rgdp p501_D_rgdp p502_D_rgdp p503_D_rgdp p504_D_rgdp p505_D_rgdp p506_D_rgdp p507_D_rgdp p508_D_rgdp, sig obs

* lets make a h=2 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p509_, step(2)
fcstats D1.rgdp p509_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/5)
fcast compute p510_, step(2)
fcstats D1.rgdp p510_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p511_, step(2)
fcstats D1.rgdp p511_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/6)
fcast compute p512_, step(2)
fcstats D1.rgdp p512_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/4)
fcast compute p513_, step(2)
fcstats D1.rgdp p513_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p514_, step(2)
fcstats D1.rgdp p514_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p515_, step(2)
fcstats D1.rgdp p515_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p516_, step(2)
fcstats D1.rgdp p516_D_rgdp
pwcorr D1.rgdp p509_D_rgdp p510_D_rgdp p511_D_rgdp p512_D_rgdp p513_D_rgdp p514_D_rgdp p515_D_rgdp p516_D_rgdp, sig obs

* lets make a h=3 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p37_, step(3)
fcstats D1.rgdp p37_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/5)
fcast compute p39_, step(3)
fcstats D1.rgdp p39_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p41_, step(3)
fcstats D1.rgdp p41_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/6)
fcast compute p43_, step(3)
fcstats D1.rgdp p43_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/4)
fcast compute p45_, step(3)
fcstats D1.rgdp p45_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p47_, step(3)
fcstats D1.rgdp p47_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p49_, step(3)
fcstats D1.rgdp p49_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p51_, step(3)
fcstats D1.rgdp p51_D_rgdp
pwcorr D1.rgdp p37_D_rgdp p39_D_rgdp p41_D_rgdp p43_D_rgdp p45_D_rgdp p47_D_rgdp p49_D_rgdp p51_D_rgdp, sig obs

* lets make a h=4 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p21_, step(4)
fcstats D1.rgdp p21_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/5)
fcast compute p23_, step(4)
fcstats D1.rgdp p23_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p25_, step(4)
fcstats D1.rgdp p25_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/6)
fcast compute p27_, step(4)
fcstats D1.rgdp p27_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/4)
fcast compute p29_, step(4)
fcstats D1.rgdp p29_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p31_, step(4)
fcstats D1.rgdp p31_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p33_, step(4)
fcstats D1.rgdp p33_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p35_, step(4)
fcstats D1.rgdp p35_D_rgdp
pwcorr D1.rgdp p21_D_rgdp p23_D_rgdp p25_D_rgdp p27_D_rgdp p29_D_rgdp p31_D_rgdp p33_D_rgdp p35_D_rgdp, sig obs



* lets make a h=5 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p53_, step(5)
fcstats D1.rgdp p53_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/5)
fcast compute p55_, step(5)
fcstats D1.rgdp p55_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p57_, step(5)
fcstats D1.rgdp p57_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/6)
fcast compute p59_, step(5)
fcstats D1.rgdp p59_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/4)
fcast compute p61_, step(5)
fcstats D1.rgdp p61_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p63_, step(5)
fcstats D1.rgdp p63_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p65_, step(5)
fcstats D1.rgdp p65_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p67_, step(5)
fcstats D1.rgdp p67_D_rgdp
pwcorr D1.rgdp p53_D_rgdp p55_D_rgdp p57_D_rgdp p59_D_rgdp p61_D_rgdp p63_D_rgdp p65_D_rgdp p67_D_rgdp, sig obs

* lets make a h=6 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p69_, step(6)
fcstats D1.rgdp p69_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/5)
fcast compute p71_, step(6)
fcstats D1.rgdp p71_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2010Q1), lags(1/6)
fcast compute p73_, step(6)
fcstats D1.rgdp p73_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/6)
fcast compute p75_, step(6)
fcstats D1.rgdp p75_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2010Q1), lags(1/4)
fcast compute p77_, step(6)
fcstats D1.rgdp p77_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2010Q1), lags(1/4)
fcast compute p79_, step(6)
fcstats D1.rgdp p79_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p81_, step(6)
fcstats D1.rgdp p81_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2010Q1), lags(1/6)
fcast compute p83_, step(6)
fcstats D1.rgdp p83_D_rgdp

pwcorr D1.rgdp p69_D_rgdp p71_D_rgdp p73_D_rgdp p75_D_rgdp p77_D_rgdp p79_D_rgdp p81_D_rgdp p83_D_rgdp, sig obs



* i have put all the stats in an excel file and from there it is easy to see
* that model 5,7,8 and 9 work the best
* lets make for each step-ahead forecast a graph
*h=1
graph twoway line p505_D_rgdp p506_D_rgdp p507_D_rgdp p508_D_rgdp D1.rgdp qdate if qdate>tq(2009Q3) & qdate<tq(2010Q3)
*h=2
graph twoway line p512_D_rgdp p513_D_rgdp p514_D_rgdp p515_D_rgdp p516_D_rgdp D1.rgdp qdate if qdate>tq(2009Q3) & qdate<tq(2010Q4)
*h=3
graph twoway line p45_D_rgdp p47_D_rgdp p49_D_rgdp p51_D_rgdp D1.rgdp qdate if qdate>tq(2009Q3) & qdate<tq(2011Q1)
*h=5
graph twoway line p61_D_rgdp p63_D_rgdp p65_D_rgdp p67_D_rgdp D1.rgdp qdate if qdate>tq(2009Q3) & qdate<tq(2011Q3)
*h=4
graph twoway line p29_D_rgdp p31_D_rgdp p33_D_rgdp p35_D_rgdp D1.rgdp qdate if qdate>tq(2009Q3) & qdate<tq(2011Q2)
*h=6
graph twoway line p77_D_rgdp p79_D_rgdp p81_D_rgdp p83_D_rgdp D1.rgdp qdate if qdate>tq(2009Q3) & qdate<tq(2011Q4)
*h=8
graph twoway line p9_D_rgdp p13_D_rgdp p15_D_rgdp p17_D_rgdp D1.rgdp qdate if qdate>tq(2009Q4) & qdate<tq(2012Q2)

*h=8
graph twoway line rgdp qdate if qdate>tq(2009Q4) & qdate<tq(2012Q2)
* I noticed that VAR9 seems to perform well in certain periods in which GDP is declining. And indeeed in this period GDP declines


* We have done a pseudo out of sample forecast for 1 specific period. Lets try a second period from 2012q2
* lets make a h=1 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p601_, step(1)
fcstats D1.rgdp p601_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/5)
fcast compute p602_, step(1)
fcstats D1.rgdp p602_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p603_, step(1)
fcstats D1.rgdp p603_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/6)
fcast compute p604_, step(1)
fcstats D1.rgdp p604_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/4)
fcast compute p605_, step(1)
fcstats D1.rgdp p605_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p606_, step(1)
fcstats D1.rgdp p606_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p607_, step(1)
fcstats D1.rgdp p607_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p608_, step(1)
fcstats D1.rgdp p608_D_rgdp
pwcorr D1.rgdp p601_D_rgdp p602_D_rgdp p603_D_rgdp p604_D_rgdp p605_D_rgdp p606_D_rgdp p607_D_rgdp p608_D_rgdp, sig obs

* lets make a h=2 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p609_, step(2)
fcstats D1.rgdp p609_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/5)
fcast compute p610_, step(2)
fcstats D1.rgdp p610_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p611_, step(2)
fcstats D1.rgdp p611_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/6)
fcast compute p612_, step(2)
fcstats D1.rgdp p612_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/4)
fcast compute p613_, step(2)
fcstats D1.rgdp p613_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p614_, step(2)
fcstats D1.rgdp p614_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p615_, step(2)
fcstats D1.rgdp p615_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p616_, step(2)
fcstats D1.rgdp p616_D_rgdp
pwcorr D1.rgdp p609_D_rgdp p610_D_rgdp p611_D_rgdp p612_D_rgdp p613_D_rgdp p614_D_rgdp p615_D_rgdp p616_D_rgdp, sig obs

* lets make a h=3 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p84_, step(3)
fcstats D1.rgdp p84_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/5)
fcast compute p85_, step(3)
fcstats D1.rgdp p85_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p86_, step(3)
fcstats D1.rgdp p86_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/6)
fcast compute p87_, step(3)
fcstats D1.rgdp p87_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/4)
fcast compute p89_, step(3)
fcstats D1.rgdp p89_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p90_, step(3)
fcstats D1.rgdp p90_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p91_, step(3)
fcstats D1.rgdp p91_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p92_, step(3)
fcstats D1.rgdp p92_D_rgdp
pwcorr D1.rgdp p84_D_rgdp p85_D_rgdp p86_D_rgdp p87_D_rgdp p89_D_rgdp p90_D_rgdp p91_D_rgdp p92_D_rgdp, sig obs

* lets make a h=4 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p93_, step(4)
fcstats D1.rgdp p93_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/5)
fcast compute p94_, step(4)
fcstats D1.rgdp p94_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p95_, step(4)
fcstats D1.rgdp p95_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/6)
fcast compute p96_, step(4)
fcstats D1.rgdp p96_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/4)
fcast compute p97_, step(4)
fcstats D1.rgdp p97_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p98_, step(4)
fcstats D1.rgdp p98_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p99_, step(4)
fcstats D1.rgdp p99_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p100_, step(4)
fcstats D1.rgdp p100_D_rgdp
graph twoway line p97_D_rgdp p98_D_rgdp p99_D_rgdp p100_D_rgdp D1.rgdp qdate if qdate>tq(2011Q4) & qdate<tq(2013Q3)
pwcorr D1.rgdp p93_D_rgdp p94_D_rgdp p95_D_rgdp p96_D_rgdp p97_D_rgdp p98_D_rgdp p99_D_rgdp p100_D_rgdp, sig obs

* lets make a h=5 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p101_, step(5)
fcstats D1.rgdp p101_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/5)
fcast compute p102_, step(5)
fcstats D1.rgdp p102_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p103_, step(5)
fcstats D1.rgdp p103_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/6)
fcast compute p104_, step(5)
fcstats D1.rgdp p104_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/4)
fcast compute p105_, step(5)
fcstats D1.rgdp p105_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p106_, step(5)
fcstats D1.rgdp p106_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p107_, step(5)
fcstats D1.rgdp p107_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p108_, step(5)
fcstats D1.rgdp p108_D_rgdp
graph twoway line p105_D_rgdp p106_D_rgdp p107_D_rgdp p108_D_rgdp D1.rgdp qdate if qdate>tq(2011Q4) & qdate<tq(2013Q4)
pwcorr D1.rgdp p101_D_rgdp p102_D_rgdp p103_D_rgdp p104_D_rgdp p105_D_rgdp p106_D_rgdp p107_D_rgdp p108_D_rgdp, sig obs


* lets make a h=6 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p109_, step(6)
fcstats D1.rgdp p109_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/5)
fcast compute p110_, step(6)
fcstats D1.rgdp p110_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p111_, step(6)
fcstats D1.rgdp p111_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/6)
fcast compute p112_, step(6)
fcstats D1.rgdp p112_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/4)
fcast compute p113_, step(6)
fcstats D1.rgdp p113_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p114_, step(6)
fcstats D1.rgdp p114_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p115_, step(6)
fcstats D1.rgdp p115_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p116_, step(6)
fcstats D1.rgdp p116_D_rgdp
graph twoway line p113_D_rgdp p114_D_rgdp p115_D_rgdp p116_D_rgdp D1.rgdp qdate if qdate>tq(2011Q4) & qdate<tq(2014Q2)
pwcorr D1.rgdp p109_D_rgdp p110_D_rgdp p111_D_rgdp p112_D_rgdp p113_D_rgdp p114_D_rgdp p115_D_rgdp p116_D_rgdp, sig obs

* lets make a h=8 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p117_, step(8)
fcstats D1.rgdp p117_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/5)
fcast compute p118_, step(8)
fcstats D1.rgdp p118_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2012Q2), lags(1/6)
fcast compute p119_, step(8)
fcstats D1.rgdp p119_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/6)
fcast compute p120_, step(8)
fcstats D1.rgdp p120_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2012Q2), lags(1/4)
fcast compute p121_, step(8)
fcstats D1.rgdp p121_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2012Q2), lags(1/4)
fcast compute p122_, step(8)
fcstats D1.rgdp p122_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p123_, step(8)
fcstats D1.rgdp p123_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2012Q2), lags(1/6)
fcast compute p124_, step(8)
fcstats D1.rgdp p124_D_rgdp
graph twoway line p121_D_rgdp p122_D_rgdp p123_D_rgdp p124_D_rgdp D1.rgdp qdate if qdate>tq(2011Q4) & qdate<tq(2014Q3)
*VAR 9 performs very bad so I suspect that this is a perid in which GDP is increasing
graph twoway line rgdp qdate if qdate>tq(2011Q4) & qdate<tq(2014Q2)
* Indeed this is a period in which GDP yoy is increasing. VAR9 does not perform well in these periods. 
pwcorr D1.rgdp p117_D_rgdp p118_D_rgdp p119_D_rgdp p120_D_rgdp p121_D_rgdp p122_D_rgdp p123_D_rgdp p124_D_rgdp, sig obs

**THIRD PERIOD: qdate<tq(2013q4). ik moet onderstaande nummers aanpassen
* lets make a h=1 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p701_, step(1)
fcstats D1.rgdp p701_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2013q4), lags(1/5)
fcast compute p702_, step(1)
fcstats D1.rgdp p702_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p703_, step(1)
fcstats D1.rgdp p703_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/6)
fcast compute p704_, step(1)
fcstats D1.rgdp p704_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/4)
fcast compute p705_, step(1)
fcstats D1.rgdp p705_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p706_, step(1)
fcstats D1.rgdp p706_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/6)
fcast compute p707_, step(1)
fcstats D1.rgdp p707_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/6)
fcast compute p708_, step(1)
fcstats D1.rgdp p708_D_rgdp
graph twoway line p705_D_rgdp p706_D_rgdp p707_D_rgdp p708_D_rgdp D1.rgdp qdate if qdate>tq(2013Q2) & qdate<tq(2014Q2)
pwcorr D1.rgdp p701_D_rgdp p702_D_rgdp p703_D_rgdp p704_D_rgdp p705_D_rgdp p706_D_rgdp p707_D_rgdp p708_D_rgdp, sig obs
* lets make a h=2 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p709_, step(2)
fcstats D1.rgdp p709_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2013q4), lags(1/5)
fcast compute p710_, step(2)
fcstats D1.rgdp p710_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p711_, step(2)
fcstats D1.rgdp p711_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/6)
fcast compute p712_, step(2)
fcstats D1.rgdp p712_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/4)
fcast compute p713_, step(2)
fcstats D1.rgdp p713_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p714_, step(2)
fcstats D1.rgdp p714_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/6)
fcast compute p715_, step(2)
fcstats D1.rgdp p715_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/6)
fcast compute p716_, step(2)
fcstats D1.rgdp p716_D_rgdp
graph twoway line p713_D_rgdp p714_D_rgdp p715_D_rgdp p716_D_rgdp D1.rgdp qdate if qdate>tq(2013Q2) & qdate<tq(2014Q3)
pwcorr D1.rgdp p709_D_rgdp p710_D_rgdp p711_D_rgdp p712_D_rgdp p713_D_rgdp p714_D_rgdp p715_D_rgdp p716_D_rgdp, sig obs
* lets make a h=3 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p125_, step(3)
fcstats D1.rgdp p125_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2013q4), lags(1/5)
fcast compute p126_, step(3)
fcstats D1.rgdp p126_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p127_, step(3)
fcstats D1.rgdp p127_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/6)
fcast compute p128_, step(3)
fcstats D1.rgdp p128_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/4)
fcast compute p129_, step(3)
fcstats D1.rgdp p129_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p130_, step(3)
fcstats D1.rgdp p130_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/6)
fcast compute p131_, step(3)
fcstats D1.rgdp p131_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/6)
fcast compute p132_, step(3)
fcstats D1.rgdp p132_D_rgdp
graph twoway line p129_D_rgdp p130_D_rgdp p131_D_rgdp p132_D_rgdp D1.rgdp qdate if qdate>tq(2013Q2) & qdate<tq(2014Q4)
pwcorr D1.rgdp p125_D_rgdp p126_D_rgdp p127_D_rgdp p128_D_rgdp p129_D_rgdp p130_D_rgdp p131_D_rgdp p132_D_rgdp, sig obs

* lets make a h=4 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p133_, step(4)
fcstats D1.rgdp p133_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2013q4), lags(1/5)
fcast compute p134_, step(4)
fcstats D1.rgdp p134_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p135_, step(4)
fcstats D1.rgdp p135_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/6)
fcast compute p136_, step(4)
fcstats D1.rgdp p136_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/4)
fcast compute p137_, step(4)
fcstats D1.rgdp p137_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p138_, step(4)
fcstats D1.rgdp p138_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/6)
fcast compute p139_, step(4)
fcstats D1.rgdp p139_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/6)
fcast compute p140_, step(4)
fcstats D1.rgdp p140_D_rgdp
graph twoway line p137_D_rgdp p138_D_rgdp p139_D_rgdp p140_D_rgdp D1.rgdp qdate if qdate>tq(2013Q2) & qdate<tq(2015Q1)
pwcorr D1.rgdp p133_D_rgdp p134_D_rgdp p135_D_rgdp p136_D_rgdp p137_D_rgdp p138_D_rgdp p139_D_rgdp p140_D_rgdp, sig obs

* lets make a h=5 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p141_, step(5)
fcstats D1.rgdp p141_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2013q4), lags(1/5)
fcast compute p142_, step(5)
fcstats D1.rgdp p142_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p143_, step(5)
fcstats D1.rgdp p143_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/6)
fcast compute p144_, step(5)
fcstats D1.rgdp p144_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/4)
fcast compute p145_, step(5)
fcstats D1.rgdp p145_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p146_, step(5)
fcstats D1.rgdp p146_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/6)
fcast compute p147_, step(5)
fcstats D1.rgdp p147_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/6)
fcast compute p148_, step(5)
fcstats D1.rgdp p148_D_rgdp
graph twoway line p145_D_rgdp p146_D_rgdp p147_D_rgdp p148_D_rgdp D1.rgdp qdate if qdate>tq(2013Q2) & qdate<tq(2015Q2)
pwcorr D1.rgdp p141_D_rgdp p142_D_rgdp p143_D_rgdp p144_D_rgdp p145_D_rgdp p146_D_rgdp p147_D_rgdp p148_D_rgdp, sig obs

* lets make a h=6 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p149_, step(6)
fcstats D1.rgdp p149_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2013q4), lags(1/5)
fcast compute p150_, step(6)
fcstats D1.rgdp p150_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p151_, step(6)
fcstats D1.rgdp p151_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/6)
fcast compute p152_, step(6)
fcstats D1.rgdp p152_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/4)
fcast compute p153_, step(6)
fcstats D1.rgdp p153_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p154_, step(6)
fcstats D1.rgdp p154_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/6)
fcast compute p155_, step(6)
fcstats D1.rgdp p155_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/6)
fcast compute p156_, step(6)
fcstats D1.rgdp p156_D_rgdp
graph twoway line p153_D_rgdp p154_D_rgdp p155_D_rgdp p156_D_rgdp D1.rgdp qdate if qdate>tq(2013Q2) & qdate<tq(2015Q3)
pwcorr D1.rgdp p149_D_rgdp p150_D_rgdp p151_D_rgdp p152_D_rgdp p153_D_rgdp p154_D_rgdp p155_D_rgdp p156_D_rgdp, sig obs

* lets make a h=8 forecast for all the models
* VAR1
qui var D1.rgdp D1.rpc D1.rgc D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p157_, step(8)
fcstats D1.rgdp p157_D_rgdp
* VAR2
qui var D1.rgdp D1.rpc D1.ri D1.rx if qdate<tq(2013q4), lags(1/5)
fcast compute p158_, step(8)
fcstats D1.rgdp p158_D_rgdp
* VAR3
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.rx if qdate<tq(2013q4), lags(1/6)
fcast compute p159_, step(8)
fcstats D1.rgdp p159_D_rgdp
* VAR4
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/6)
fcast compute p160_, step(8)
fcstats D1.rgdp p160_D_rgdp
* VAR5
qui var D1.rgdp D1.rpc D1.rgc D1.ri if qdate<tq(2013q4), lags(1/4)
fcast compute p161_, step(8)
fcstats D1.rgdp p161_D_rgdp
* VAR7
qui var D1.rgdp D1.rpc D1.rgc D1.ca if qdate<tq(2013q4), lags(1/4)
fcast compute p162_, step(8)
fcstats D1.rgdp p162_D_rgdp
* VAR8
qui var D1.rgdp D1.rpc D1.rgc D1.ri D1.primario if qdate<tq(2013q4), lags(1/6)
fcast compute p163_, step(8)
fcstats D1.rgdp p163_D_rgdp
* VAR9
qui var D1.rgdp D1.rpc D1.rgc D1.ri primario if qdate<tq(2013q4), lags(1/6)
fcast compute p164_, step(8)
fcstats D1.rgdp p164_D_rgdp
graph twoway line p161_D_rgdp p162_D_rgdp p163_D_rgdp p164_D_rgdp D1.rgdp qdate if qdate>tq(2013Q2) & qdate<tq(2015Q4)
graph twoway line rgdp qdate if qdate>tq(2013Q2) & qdate<tq(2015Q4)
* I noticed that VAR9 seems to perform well in certain periods in which GDP is declining. And indeeed in this period GDP declines
pwcorr D1.rgdp p157_D_rgdp p158_D_rgdp p159_D_rgdp p160_D_rgdp p161_D_rgdp p162_D_rgdp p163_D_rgdp p164_D_rgdp if qdate>tq(2013Q2) & qdate<tq(2015Q4), sig
