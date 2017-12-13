
clear all       
set more off 
set matsize 1000

cd C:\Users\AKLEIN\Desktop\Econometrics\Data\VarForecasting

use peru_mix2008q1_best, clear
* tidy the data
gen qdate = quarterly(date, "YQ")
format qdate %tq

tsset qdate

** Best 5 Models **

* var 3
qui var D1.rgdp D1.pib, lags(1/4)
* var 20
qui var D1.rgdp D1.pib D1.primario, lags(1/4)
* var 51
qui var D1.rgdp D1.pib D1.cpi, lags(1/4)
* var 33: 
qui var D1.rgdp D1.pib D1.rpc, lags(1/4)
* var 1
qui var D1.rgdp D1.pib, lags(1/5)



* period1: 2013Q2

* h = 6 

* var 3
qui var D1.rgdp D1.pib if qdate<tq(2013Q2), lags(1/4)
fcast compute p0067_, step(6)
fcstats D1.rgdp p0067_D_rgdp
* var 20
qui var D1.rgdp D1.pib D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0068_, step(6)
fcstats D1.rgdp p0068_D_rgdp
* var 51
qui var D1.rgdp D1.pib D1.cpi if qdate<tq(2013Q2), lags(1/4)
fcast compute p0069_, step(6)
fcstats D1.rgdp p0069_D_rgdp
* var 33: 
qui var D1.rgdp D1.pib D1.rpc if qdate<tq(2013Q2), lags(1/4)
fcast compute p0070_, step(6)
fcstats D1.rgdp p0070_D_rgdp
* var 1
qui var D1.rgdp D1.pib if qdate<tq(2013Q2), lags(1/5)
fcast compute p000070_, step(6)
fcstats D1.rgdp p000070_D_rgdp

pwcorr D1.rgdp p0067_D_rgdp p0068_D_rgdp p0069_D_rgdp p0070_D_rgdp p000070_D_rgdp if qdate>tq(2012Q4) & qdate<tq(2015Q1)

*h=6
graph twoway line p0067_D_rgdp p0068_D_rgdp p0069_D_rgdp p0070_D_rgdp p000070_D_rgdp D1.rgdp qdate if qdate>tq(2012Q4) & qdate<tq(2015Q1)
egen avg_period1 = rowmean(p0067_D_rgdp p0068_D_rgdp p0069_D_rgdp p0070_D_rgdp p000070_D_rgdp)
graph twoway line avg_period1 D1.rgdp qdate if qdate>tq(2012Q4) & qdate<tq(2015Q1)

* period2: 2013Q4


* h = 6 
* var 3
qui var D1.rgdp D1.pib if qdate<tq(2013Q4), lags(1/4)
fcast compute p00670_, step(6)
fcstats D1.rgdp p00670_D_rgdp
* var 20
qui var D1.rgdp D1.pib D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00680_, step(6)
fcstats D1.rgdp p00680_D_rgdp
* var 51
qui var D1.rgdp D1.pib D1.cpi if qdate<tq(2013Q4), lags(1/4)
fcast compute p00690_, step(6)
fcstats D1.rgdp p00690_D_rgdp
* var 33: 
qui var D1.rgdp D1.pib D1.rpc if qdate<tq(2013Q4), lags(1/4)
fcast compute p00700_, step(6)
fcstats D1.rgdp p00700_D_rgdp
* var 1
qui var D1.rgdp D1.pib if qdate<tq(2013Q4), lags(1/5)
fcast compute p0000700_, step(6)
fcstats D1.rgdp p0000700_D_rgdp

pwcorr D1.rgdp p00670_D_rgdp p00680_D_rgdp p00690_D_rgdp p00700_D_rgdp p0000700_D_rgdp if qdate>tq(2013Q2) & qdate<tq(2015Q2)
*h=6
graph twoway line p00670_D_rgdp p00680_D_rgdp p00690_D_rgdp p00700_D_rgdp p0000700_D_rgdp D1.rgdp qdate if qdate>tq(2013Q2) & qdate<tq(2015Q2)
egen avg_period2 = rowmean(p00670_D_rgdp p00680_D_rgdp p00690_D_rgdp p00700_D_rgdp p0000700_D_rgdp)
graph twoway line avg_period2 D1.rgdp qdate if qdate>tq(2013Q1) & qdate<tq(2015Q3)
fcstats D1.rgdp avg_period2

* period 3: 2014Q4


* h = 6 
* var 3
qui var D1.rgdp D1.pib if qdate<tq(2014Q4), lags(1/4)
fcast compute p006700_, step(6)
fcstats D1.rgdp p00670_D_rgdp
* var 20
qui var D1.rgdp D1.pib D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p006800_, step(6)
fcstats D1.rgdp p006800_D_rgdp
* var 51
qui var D1.rgdp D1.pib D1.cpi if qdate<tq(2014Q4), lags(1/4)
fcast compute p006900_, step(6)
fcstats D1.rgdp p006900_D_rgdp
* var 33: 
qui var D1.rgdp D1.pib D1.rpc if qdate<tq(2014Q4), lags(1/4)
fcast compute p007000_, step(6)
fcstats D1.rgdp p007000_D_rgdp
* var 1
qui var D1.rgdp D1.pib if qdate<tq(2014Q4), lags(1/5)
fcast compute p00007000_, step(6)
fcstats D1.rgdp p00007000_D_rgdp

pwcorr D1.rgdp p006700_D_rgdp p006800_D_rgdp p00690_D_rgdp p007000_D_rgdp p00007000_D_rgdp if qdate>tq(2014Q2) & qdate<tq(2016Q2)

*h=6 *p0070000_D_rgdp p000070000_D_rgdp eruit gegooit
graph twoway line p006700_D_rgdp p006800_D_rgdp p006900_D_rgdp p007000_D_rgdp p00007000_D_rgdp D1.rgdp qdate if qdate>tq(2014Q2) & qdate<tq(2016Q2)
egen avg_period3 = rowmean(p006700_D_rgdp p006800_D_rgdp p006900_D_rgdp p007000_D_rgdp p00007000_D_rgdp)
graph twoway line avg_period3 D1.rgdp qdate if qdate>tq(2014Q2) & qdate<tq(2016Q2)
fcstats D1.rgdp avg_period3

* period 4: 2015Q4



* h = 6 
* var 3
qui var D1.rgdp D1.pib if qdate<tq(2015Q4), lags(1/4)
fcast compute p0067000_, step(6)
fcstats D1.rgdp p0067000_D_rgdp
* var 20
qui var D1.rgdp D1.pib D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p0068000_, step(6)
fcstats D1.rgdp p0068000_D_rgdp
* var 51
qui var D1.rgdp D1.pib D1.cpi if qdate<tq(2015Q4), lags(1/4)
fcast compute p0069000_, step(6)
fcstats D1.rgdp p0069000_D_rgdp
* var 33: 
qui var D1.rgdp D1.pib D1.rpc if qdate<tq(2015Q4), lags(1/4)
fcast compute p0070000_, step(6)
fcstats D1.rgdp p0070000_D_rgdp
* var 1
qui var D1.rgdp D1.pib if qdate<tq(2015Q4), lags(1/5)
fcast compute p000070000_, step(6)
fcstats D1.rgdp p000070000_D_rgdp

pwcorr D1.rgdp p0067000_D_rgdp p0068000_D_rgdp p0069000_D_rgdp p0070000_D_rgdp p000070000_D_rgdp if qdate>tq(2015Q2) & qdate<tq(2017Q1)

*h=6
graph twoway line p0067000_D_rgdp p0068000_D_rgdp p0069000_D_rgdp p0070000_D_rgdp p000070000_D_rgdp D1.rgdp qdate if qdate>tq(2015Q2) & qdate<tq(2017Q1)
egen avg_period4 = rowmean(p0067000_D_rgdp p0068000_D_rgdp p0069000_D_rgdp p0070000_D_rgdp p000070000_D_rgdp)
graph twoway line avg_period4 D1.rgdp qdate if qdate>tq(2015Q2) & qdate<tq(2017Q1)
fcstats D1.rgdp avg_period4


