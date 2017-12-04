# this replicates Bart's "test_brasil_quarterlyvariables_yoygrowth.do" 
library(haven)
library(timetk)
library(lubridate)
library(xts)
library(vars)

# use brasilQ_yoy, clear
# * tidy the data
# gen qdate = quarterly(date, "YQ")
# format qdate %tq
# tsset qdate
brasilQ_yoy <- read_dta("brasilQ_yoy.dta")
brasil <- brasilQ_yoy 

brasil$date <- yq(brasilQ_yoy$date)
#after the yq conversion to a proper date variable, if you need a variable 
#in year quarter format, jut do as.yearqtr(brasilQ_yoy$date)
brasil_xts <- tk_xts(brasil, date_var = date)
brasil_ts <- tk_ts(brasil_xts,
                    start = c(year(min(index(brasil_xts))), 
                              quarter(min(index(brasil_xts)))),
                    frequency = 4)


# * stationarity tests
# dfuller rgdp, lags(4)
# dfuller rpc, lags(4)
# dfuller rgc, lags(4)
# dfuller ri, lags(4)
# dfuller fbcf, lags(4)
# dfuller exist, lags(4)
# dfuller rx, lags(4)
# dfuller rm, lags(4)
# dfuller primario, lags(4)
# dfuller manuf, lags(4)
# dfuller serv, lags(4)
# ** stationarity is still an isse so i take first differences
# dfuller D1.rgdp, lags(4)
# dfuller D1.rpc, lags(4)
# dfuller D1.rgc, lags(4)
# dfuller D1.ri, lags(4)
# dfuller D1.fbcf, lags(4)
# dfuller D1.exist, lags(4)
# dfuller D1.rx, lags(4)
# dfuller D1.rm, lags(4)
# dfuller D1.primario, lags(4)
# dfuller D1.manuf, lags(4)
# dfuller D1.serv, lags(4)
# ** stationarity issues are solved








