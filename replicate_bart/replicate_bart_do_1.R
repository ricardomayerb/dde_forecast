# this replicates Bart's "test_brasil_quarterlyvariables_yoygrowth.do" 
library(haven)
library(timetk)
library(lubridate)
library(xts)
library(vars)
library(sweep)
library(tseries)
library(tidyr)
library(tibbletime)
library(dplyr)
library(tidyquant)
library(forecast)

# use brasilQ_yoy, clear
# * tidy the data
# gen qdate = quarterly(date, "YQ")
# format qdate %tq
# tsset qdate
brasilQ_yoy <- read_dta("data/brasilQ_yoy.dta")

brasil <- brasilQ_yoy 

brasil$date <- yq(brasilQ_yoy$date)

brasil_long <- brasil %>% gather(variable, value, -date)

brasil_nested <- brasil_long %>% group_by(variable) %>% 
  nest(.key = "data.tbl")

brasil_n_ts <- brasil_nested %>% 
  mutate(data.ts = map(.x   =  data.tbl,
                       .f   =  tk_ts,
                       start = 1997,
                       freq = 4
                       )
         )

fun_for <- function(x, h){forecast(auto.arima(x), h=h)}


meta_goo <- function(mod, h){
  function(y,h) {forecast(Arima(y, model = mod), h)}
}




brasil_auto_all <- brasil_n_ts %>% 
  mutate(auto_arimas = map(data.ts, auto.arima),
         a_forecast = map(auto_arimas, forecast, h = 8),
         a_acu = map(a_forecast, accuracy),
         e_cv = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 5)
  )


# e_cv = map(data.ts, tsCV, fun_for, h = 8)

# ffoo = function(x,h) {forecast(Arima(x, model = fa), h=h)}
# > tsCV(foo, ffoo, h=4)

goo_fa <- meta_goo(fa)

tsCV(foo, goo_fa, h = 5)

tsCV(foo, meta_goo(fa), h = 5)



# cv = map(data.ts, tsCV, a_forecast

brasil_arimas <- brasil_auto_all %>% 
  mutate(tidy = map(auto_arimas, sw_tidy)) %>% 
  unnest(tidy, .drop = TRUE)


brasil_acu <- brasil_auto_all %>% 
  mutate(tidy = map(a_acu, sw_tidy)) %>% 
  unnest(tidy, .drop = TRUE)  
  











brasil_tests <- brasil_n_ts %>% 
  mutate(diff_data.ts = map(data.ts, diff),
         adf = map(data.ts, adf.test),
         adf_d = map(diff_data.ts, adf.test))

test_on_lev <- brasil_tests %>% 
  mutate(tidy = map(adf, sw_tidy)) %>% 
  unnest(tidy, .drop = TRUE)


  

#after the yq conversion to a proper date variable, if you need a variable 
#in year quarter format, jut do as.yearqtr(brasilQ_yoy$date)
brasil_xts <- tk_xts(brasil)

brasil_ts <- tk_ts(brasil_xts,
                    start = c(year(min(index(brasil_xts))), 
                              quarter(min(index(brasil_xts)))),
                    frequency = 4)

has_timetk_idx(brasil_ts)

foo <- adf.test(brasil_ts[, "rgdp"])
goo <- adf.test(diff(brasil_ts[, "rgdp"]))

ts_names <- dimnames(brasil_ts)[[2]]


foo  <- brasil_ts[, "rgdp"]
fa <- auto.arima(foo)



far2 <- function(x, h){forecast(Arima(x, order=c(2,0,0)), h=h)}
far3 <- function(x, h){forecast(auto.arima(x), h=h)}


e <- tsCV(lynx, far2, h=5)
e

eee <- tsCV(foo, far3, h=8)
eee


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








