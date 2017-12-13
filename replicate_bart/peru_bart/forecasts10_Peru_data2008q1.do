
clear all       
set more off 
set matsize 1000

cd C:\Users\AKLEIN\Desktop\Econometrics\Data\VarForecasting

use peru_mix2008q1_best, clear
* tidy the data
gen qdate = quarterly(date, "YQ")
format qdate %tq

tsset qdate

** SET 10 **
* var 64
qui var D1.rgdp D1.pib D1.cpi D1.primario, lags(1/5)
* var 65
qui var D1.rgdp D1.pib D1.cpi D1.primario, lags(1/4)
* var 66
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario, lags(1/5)
* var 67
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario, lags(1/4)
* var 66a
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario, lags(1/2)
* var 67a
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario, lags(1/3)
* var 68
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc, lags(1/5)


* period1: 2013Q2
* h =1 
* VAR 54:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0035_, step(1)
fcstats D1.rgdp p0035_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0036_, step(1)
fcstats D1.rgdp p0036_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0037_, step(1)
fcstats D1.rgdp p0037_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0038_, step(1)
fcstats D1.rgdp p0038_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/2)
fcast compute p0039_, step(1)
fcstats D1.rgdp p0039_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/3)
fcast compute p0040_, step(1)
fcstats D1.rgdp p0040_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q2), lags(1/5)
fcast compute p00040_, step(1)
fcstats D1.rgdp p00040_D_rgdp

* h = 2 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0041_, step(2)
fcstats D1.rgdp p0041_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0042_, step(2)
fcstats D1.rgdp p0042_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0043_, step(2)
fcstats D1.rgdp p0043_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0044_, step(2)
fcstats D1.rgdp p0044_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/2)
fcast compute p0045_, step(2)
fcstats D1.rgdp p0045_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/3)
fcast compute p0046_, step(2)
fcstats D1.rgdp p0046_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q2), lags(1/5)
fcast compute p000046_, step(2)
fcstats D1.rgdp p000046_D_rgdp

* h = 3 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0047_, step(3)
fcstats D1.rgdp p0047_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0048_, step(3)
fcstats D1.rgdp p0048_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0049_, step(3)
fcstats D1.rgdp p0049_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0050_, step(3)
fcstats D1.rgdp p0050_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/2)
fcast compute p0051_, step(3)
fcstats D1.rgdp p0051_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/3)
fcast compute p0052_, step(3)
fcstats D1.rgdp p0052_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q2), lags(1/5)
fcast compute p000052_, step(3)
fcstats D1.rgdp p000052_D_rgdp

* h = 4 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0053_, step(4)
fcstats D1.rgdp p0053_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0054_, step(4)
fcstats D1.rgdp p0054_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0055_, step(4)
fcstats D1.rgdp p0055_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0056_, step(4)
fcstats D1.rgdp p0056_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/2)
fcast compute p057_, step(4)
fcstats D1.rgdp p057_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/3)
fcast compute p058_, step(4)
fcstats D1.rgdp p058_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q2), lags(1/5)
fcast compute p000058_, step(4)
fcstats D1.rgdp p000058_D_rgdp

* h = 5 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0059_, step(5)
fcstats D1.rgdp p0059_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0060_, step(5)
fcstats D1.rgdp p0060_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0061_, step(5)
fcstats D1.rgdp p0061_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0062_, step(5)
fcstats D1.rgdp p0062_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/2)
fcast compute p0063_, step(5)
fcstats D1.rgdp p0063_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/3)
fcast compute p0064_, step(5)
fcstats D1.rgdp p0064_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q2), lags(1/5)
fcast compute p000064_, step(5)
fcstats D1.rgdp p000064_D_rgdp

* h = 6 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0065_, step(6)
fcstats D1.rgdp p0065_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0066_, step(6)
fcstats D1.rgdp p0066_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/5)
fcast compute p0067_, step(6)
fcstats D1.rgdp p0067_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/4)
fcast compute p0068_, step(6)
fcstats D1.rgdp p0068_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/2)
fcast compute p0069_, step(6)
fcstats D1.rgdp p0069_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/3)
fcast compute p0070_, step(6)
fcstats D1.rgdp p0070_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q2), lags(1/5)
fcast compute p000070_, step(6)
fcstats D1.rgdp p000070_D_rgdp

pwcorr D1.rgdp p0065_D_rgdp p0066_D_rgdp p0067_D_rgdp p0068_D_rgdp p0069_D_rgdp p0070_D_rgdp p000070_D_rgdp if qdate>tq(2012Q4) & qdate<tq(2015Q1)

*h=6
graph twoway line p0065_D_rgdp p0066_D_rgdp p0067_D_rgdp p0068_D_rgdp p0069_D_rgdp p0070_D_rgdp p000070_D_rgdp D1.rgdp qdate if qdate>tq(2012Q4) & qdate<tq(2015Q1)
egen avg_period1 = rowmean(p0065_D_rgdp p0066_D_rgdp p0067_D_rgdp p0068_D_rgdp p0069_D_rgdp p0070_D_rgdp p000070_D_rgdp)
graph twoway line avg_period1 D1.rgdp qdate if qdate>tq(2012Q4) & qdate<tq(2015Q1)

* period2: 2013Q4

* h =1 
* VAR 54:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00350_, step(1)
fcstats D1.rgdp p00350_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00360_, step(1)
fcstats D1.rgdp p00360_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00370_, step(1)
fcstats D1.rgdp p00370_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00380_, step(1)
fcstats D1.rgdp p00380_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/2)
fcast compute p00390_, step(1)
fcstats D1.rgdp p00390_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q2), lags(1/3)
fcast compute p00400_, step(1)
fcstats D1.rgdp p00400_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q4), lags(1/5)
fcast compute p000400_, step(1)
fcstats D1.rgdp p000400_D_rgdp

* h = 2 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00410_, step(2)
fcstats D1.rgdp p00410_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00420_, step(2)
fcstats D1.rgdp p00420_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00430_, step(2)
fcstats D1.rgdp p00430_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00440_, step(2)
fcstats D1.rgdp p00440_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/2)
fcast compute p00450_, step(2)
fcstats D1.rgdp p00450_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/3)
fcast compute p00460_, step(2)
fcstats D1.rgdp p00460_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q4), lags(1/5)
fcast compute p0000460_, step(2)
fcstats D1.rgdp p0000460_D_rgdp

* h = 3 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00470_, step(3)
fcstats D1.rgdp p00470_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00480_, step(3)
fcstats D1.rgdp p00480_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00490_, step(3)
fcstats D1.rgdp p00490_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00500_, step(3)
fcstats D1.rgdp p00500_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/2)
fcast compute p00510_, step(3)
fcstats D1.rgdp p00510_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/3)
fcast compute p00520_, step(3)
fcstats D1.rgdp p00520_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q4), lags(1/5)
fcast compute p0000520_, step(3)
fcstats D1.rgdp p0000520_D_rgdp

* h = 4 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00530_, step(4)
fcstats D1.rgdp p00530_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00540_, step(4)
fcstats D1.rgdp p00540_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00550_, step(4)
fcstats D1.rgdp p00550_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00560_, step(4)
fcstats D1.rgdp p00560_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/2)
fcast compute p0570_, step(4)
fcstats D1.rgdp p0570_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/3)
fcast compute p0580_, step(4)
fcstats D1.rgdp p0580_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q4), lags(1/5)
fcast compute p0000580_, step(4)
fcstats D1.rgdp p0000580_D_rgdp

* h = 5 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00590_, step(5)
fcstats D1.rgdp p00590_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00600_, step(5)
fcstats D1.rgdp p00600_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00610_, step(5)
fcstats D1.rgdp p00610_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00620_, step(5)
fcstats D1.rgdp p00620_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/2)
fcast compute p00630_, step(5)
fcstats D1.rgdp p00630_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/3)
fcast compute p00640_, step(5)
fcstats D1.rgdp p00640_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q4), lags(1/5)
fcast compute p0000640_, step(5)
fcstats D1.rgdp p0000640_D_rgdp

* h = 6 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00650_, step(6)
fcstats D1.rgdp p00650_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00660_, step(6)
fcstats D1.rgdp p00660_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/5)
fcast compute p00670_, step(6)
fcstats D1.rgdp p00670_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/4)
fcast compute p00680_, step(6)
fcstats D1.rgdp p00680_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/2)
fcast compute p00690_, step(6)
fcstats D1.rgdp p00690_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2013Q4), lags(1/3)
fcast compute p00700_, step(6)
fcstats D1.rgdp p00700_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2013Q4), lags(1/5)
fcast compute p0000700_, step(6)
fcstats D1.rgdp p0000700_D_rgdp

pwcorr D1.rgdp p00650_D_rgdp p00660_D_rgdp p00670_D_rgdp p00680_D_rgdp p00690_D_rgdp p00700_D_rgdp p0000700_D_rgdp if qdate>tq(2013Q2) & qdate<tq(2015Q2)
*h=6
graph twoway line p00650_D_rgdp p00660_D_rgdp p00680_D_rgdp p00690_D_rgdp p0000700_D_rgdp D1.rgdp qdate if qdate>tq(2013Q2) & qdate<tq(2015Q2)
egen avg_period3 = rowmean(p00650_D_rgdp p00660_D_rgdp p00670_D_rgdp p00680_D_rgdp p00690_D_rgdp p00700_D_rgdp p0000700_D_rgdp)
graph twoway line avg_period3 D1.rgdp qdate if qdate>tq(2013Q1) & qdate<tq(2015Q3)
fcstats D1.rgdp avg_period3


* period 3: 2014Q4

* h =1 


* h =1 
* VAR 86:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p003500_, step(1)
fcstats D1.rgdp p003500_D_rgdp
* var 87: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p003600_, step(1)
fcstats D1.rgdp p003600_D_rgdp
* var 88: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p003700_, step(1)
fcstats D1.rgdp p003700_D_rgdp
* var 89:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p003800_, step(1)
fcstats D1.rgdp p003800_D_rgdp
* var 90: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/2)
fcast compute p003900_, step(1)
fcstats D1.rgdp p003900_D_rgdp
* var 91
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/3)
fcast compute p004000_, step(1)
fcstats D1.rgdp p004000_D_rgdp
* var 92
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2014Q4), lags(1/5)
fcast compute p0004000_, step(1)
fcstats D1.rgdp p0004000_D_rgdp

* h = 2 
* VAR 86:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p004100_, step(2)
fcstats D1.rgdp p004100_D_rgdp
* var 87: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p004200_, step(2)
fcstats D1.rgdp p004200_D_rgdp
* var 88: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p004300_, step(2)
fcstats D1.rgdp p004300_D_rgdp
* var 89:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p004400_, step(2)
fcstats D1.rgdp p004400_D_rgdp
* var 90: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/2)
fcast compute p004500_, step(2)
fcstats D1.rgdp p004500_D_rgdp
* var 91
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/3)
fcast compute p004600_, step(2)
fcstats D1.rgdp p004600_D_rgdp
* var 92
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2014Q4), lags(1/5)
fcast compute p00004600_, step(2)
fcstats D1.rgdp p00004600_D_rgdp

* h = 3 
* VAR 86:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p004700_, step(3)
fcstats D1.rgdp p004700_D_rgdp
* var 87: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p004800_, step(3)
fcstats D1.rgdp p004800_D_rgdp
* var 88: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p004900_, step(3)
fcstats D1.rgdp p004900_D_rgdp
* var 89:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p005000_, step(3)
fcstats D1.rgdp p005000_D_rgdp
* var 90: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/2)
fcast compute p005100_, step(3)
fcstats D1.rgdp p005100_D_rgdp
* var 91
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/3)
fcast compute p005200_, step(3)
fcstats D1.rgdp p005200_D_rgdp
* var 92
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2014Q4), lags(1/5)
fcast compute p00005200_, step(3)
fcstats D1.rgdp p00005200_D_rgdp

* h = 4 
* VAR 86:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p005300_, step(4)
fcstats D1.rgdp p005300_D_rgdp
* var 87: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p005400_, step(4)
fcstats D1.rgdp p005400_D_rgdp
* var 88: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p005500_, step(4)
fcstats D1.rgdp p005500_D_rgdp
* var 89:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p005600_, step(4)
fcstats D1.rgdp p005600_D_rgdp
* var 90: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/2)
fcast compute p05700_, step(4)
fcstats D1.rgdp p05700_D_rgdp
* var 91
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/3)
fcast compute p05800_, step(4)
fcstats D1.rgdp p05800_D_rgdp
* var 92
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2014Q4), lags(1/5)
fcast compute p00005800_, step(4)
fcstats D1.rgdp p00005800_D_rgdp

* h = 5 
* VAR 86:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p005900_, step(5)
fcstats D1.rgdp p005900_D_rgdp
* var 87: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p006000_, step(5)
fcstats D1.rgdp p006000_D_rgdp
* var 88: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p006100_, step(5)
fcstats D1.rgdp p006100_D_rgdp
* var 89:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p006200_, step(5)
fcstats D1.rgdp p006200_D_rgdp
* var 90: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/2)
fcast compute p006300_, step(5)
fcstats D1.rgdp p006300_D_rgdp
* var 91
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/3)
fcast compute p006400_, step(5)
fcstats D1.rgdp p006400_D_rgdp
* var 92
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2014Q4), lags(1/5)
fcast compute p00006400_, step(5)
fcstats D1.rgdp p00006400_D_rgdp

* h = 6 
* VAR 86:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p0065000_, step(6)
fcstats D1.rgdp p0065000_D_rgdp
* var 87: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p0066000_, step(6)
fcstats D1.rgdp p0066000_D_rgdp
* var 88: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/5)
fcast compute p0067000_, step(6)
fcstats D1.rgdp p0067000_D_rgdp
* var 89:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/4)
fcast compute p0068000_, step(6)
fcstats D1.rgdp p0068000_D_rgdp
* var 90: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/2)
fcast compute p0069000_, step(6)
fcstats D1.rgdp p0069000_D_rgdp
* var 91
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2014Q4), lags(1/3)
fcast compute p0070000_, step(6)
fcstats D1.rgdp p0070000_D_rgdp
* var 92
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2014Q4), lags(1/5)
fcast compute p000070000_, step(6)
fcstats D1.rgdp p000070000_D_rgdp

pwcorr D1.rgdp p0065000_D_rgdp p0066000_D_rgdp p0067000_D_rgdp p0068000_D_rgdp p0069000_D_rgdp p0070000_D_rgdp p000070000_D_rgdp if qdate>tq(2014Q2) & qdate<tq(2016Q2)

graph twoway line p0065000_D_rgdp p0066000_D_rgdp p0067000_D_rgdp p0068000_D_rgdp p0070000_D_rgdp p000070000_D_rgdp D1.rgdp qdate if qdate>tq(2014Q2) & qdate<tq(2016Q2)
egen avg_period4 = rowmean(p0065000_D_rgdp p0066000_D_rgdp p0067000_D_rgdp p0068000_D_rgdp p0069000_D_rgdp p0070000_D_rgdp p000070000_D_rgdp)
graph twoway line avg_period4 D1.rgdp qdate if qdate>tq(2014Q2) & qdate<tq(2016Q2)
fcstats D1.rgdp avg_period4

* period 4: 2015Q4

* h =1 
* VAR 54:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p0035000_, step(1)
fcstats D1.rgdp p0035000_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p0036000_, step(1)
fcstats D1.rgdp p0036000_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p0037000_, step(1)
fcstats D1.rgdp p0037000_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p0038000_, step(1)
fcstats D1.rgdp p0038000_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/2)
fcast compute p0039000_, step(1)
fcstats D1.rgdp p0039000_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/3)
fcast compute p00400000_, step(1)
fcstats D1.rgdp p00400000_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2015Q4), lags(1/5)
fcast compute p00040000_, step(1)
fcstats D1.rgdp p00040000_D_rgdp


* h = 2 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p0041000_, step(2)
fcstats D1.rgdp p0041000_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p0042000_, step(2)
fcstats D1.rgdp p0042000_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p0043000_, step(2)
fcstats D1.rgdp p0043000_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p0044000_, step(2)
fcstats D1.rgdp p0044000_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/2)
fcast compute p0045000_, step(2)
fcstats D1.rgdp p0045000_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/3)
fcast compute p0046000_, step(2)
fcstats D1.rgdp p0046000_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2015Q4), lags(1/5)
fcast compute p000046000_, step(2)
fcstats D1.rgdp p000046000_D_rgdp

* h = 3 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p0047000_, step(3)
fcstats D1.rgdp p0047000_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p0048000_, step(3)
fcstats D1.rgdp p0048000_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p0049000_, step(3)
fcstats D1.rgdp p0049000_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p0050000_, step(3)
fcstats D1.rgdp p0050000_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/2)
fcast compute p0051000_, step(3)
fcstats D1.rgdp p0051000_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/3)
fcast compute p0052000_, step(3)
fcstats D1.rgdp p0052000_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2015Q4), lags(1/5)
fcast compute p000052000_, step(3)
fcstats D1.rgdp p000052000_D_rgdp

* h = 4 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p0053000_, step(4)
fcstats D1.rgdp p0053000_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p0054000_, step(4)
fcstats D1.rgdp p0054000_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p0055000_, step(4)
fcstats D1.rgdp p0055000_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p0056000_, step(4)
fcstats D1.rgdp p0056000_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/2)
fcast compute p057000_, step(4)
fcstats D1.rgdp p057000_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/3)
fcast compute p058000_, step(4)
fcstats D1.rgdp p058000_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2015Q4), lags(1/5)
fcast compute p000058000_, step(4)
fcstats D1.rgdp p000058000_D_rgdp

* h = 5 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p0059000_, step(5)
fcstats D1.rgdp p0059000_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p0060000_, step(5)
fcstats D1.rgdp p0060000_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p0061000_, step(5)
fcstats D1.rgdp p0061000_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p0062000_, step(5)
fcstats D1.rgdp p0062000_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/2)
fcast compute p0063000_, step(5)
fcstats D1.rgdp p0063000_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/3)
fcast compute p0064000_, step(5)
fcstats D1.rgdp p0064000_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2015Q4), lags(1/5)
fcast compute p000064000_, step(5)
fcstats D1.rgdp p000064000_D_rgdp

* h = 6 
* VAR 38:
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p00650000_, step(6)
fcstats D1.rgdp p00650000_D_rgdp
* var 55: lag test say 5 best. Model stable, serial correlation not a big problem
qui var D1.rgdp D1.pib D1.cpi D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p00660000_, step(6)
fcstats D1.rgdp p00660000_D_rgdp
* var 56: : lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags and 5 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/5)
fcast compute p00670000_, step(6)
fcstats D1.rgdp p00670000_D_rgdp
* var 57:
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/4)
fcast compute p00680000_, step(6)
fcstats D1.rgdp p00680000_D_rgdp
* var 58: lag test say 12 is best but that seems a bit much and gives an error. Model is stable at 4 lags, 5 and 6 lags, serial correlation not problem
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/2)
fcast compute p00690000_, step(6)
fcstats D1.rgdp p00690000_D_rgdp
* var 59
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.primario if qdate<tq(2015Q4), lags(1/3)
fcast compute p007000000_, step(6)
fcstats D1.rgdp p007000000_D_rgdp
* var 60
qui var D1.rgdp D1.pib D1.cpi D1.manuf D1.rpc if qdate<tq(2015Q4), lags(1/5)
fcast compute p0000700000_, step(6)
fcstats D1.rgdp p0000700000_D_rgdp

pwcorr D1.rgdp p00650000_D_rgdp p00660000_D_rgdp p00670000_D_rgdp p00680000_D_rgdp p00690000_D_rgdp p007000000_D_rgdp p0000700000_D_rgdp if qdate>tq(2015Q2) & qdate<tq(2017Q1)

*h=6
graph twoway line p00670000_D_rgdp p00680000_D_rgdp p00690000_D_rgdp p007000000_D_rgdp p0000700000_D_rgdp D1.rgdp qdate if qdate>tq(2015Q2) & qdate<tq(2017Q1)
egen avg_period5 = rowmean(p00650000_D_rgdp p00660000_D_rgdp p00670000_D_rgdp p00680000_D_rgdp p00690000_D_rgdp p007000000_D_rgdp p0000700000_D_rgdp)
graph twoway line avg_period5 D1.rgdp qdate if qdate>tq(2015Q2) & qdate<tq(2017Q1)
fcstats D1.rgdp avg_period5

* var 20
qui var D1.rgdp D1.pib D1.primario, lags(1/4)
fcast compute pVAR20_, step(6)
fcast graph pVAR20_D_rgdp, observed
