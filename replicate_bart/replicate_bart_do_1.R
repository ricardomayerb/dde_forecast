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

ntest <-  12
train_ends <- nrow(brasil) - ntest - 1
test_starts <- nrow(brasil) - ntest


brasil_n_ts <- brasil_nested %>% 
  mutate(data.ts = map(.x   =  data.tbl,
                       .f   =  tk_ts,
                       start = 1997,
                       freq = 4
                       ),
         train_data.ts = map(.x = data.ts,
                             .f = subset,
                             end = train_ends),
         test_data.ts = map(.x = data.ts,
                           .f = subset,
                           start = test_starts)
         )

# fun_for <- function(x, h){forecast(auto.arima(x), h=h)}


meta_goo <- function(mod, h){
  function(y,h) {forecast(Arima(y, model = mod), h)}
}


# brasil_auto_all <- brasil_n_ts %>%
#  mutate(auto_arimas = map(data.ts, auto.arima),
#         a_forecast = map(auto_arimas, forecast, h = 8),
#         a_acu = map(a_forecast, accuracy),
#         e_cv = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 5)
#         )

brasil_arima_fit <- brasil_n_ts %>%
  mutate(auto_arimas = map(data.ts, auto.arima)
  )

brasil_arima_eCV <- brasil_arima_fit %>% 
  mutate(
    e_cv_h_1 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 1),
    e_cv_h_2 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 2),
    e_cv_h_3 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 3),
    e_cv_h_4 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 4),
    e_cv_h_5 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 5),
    e_cv_h_6 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 6),
    e_cv_h_7 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 7),
    e_cv_h_8 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 8)
  )


brasil_arima_eCV_w40 <- brasil_arima_fit %>% 
  mutate(
    e_cv_h_1 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 1, window = 40),
    e_cv_h_2 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 2, window = 40),
    e_cv_h_3 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 3, window = 40),
    e_cv_h_4 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 4, window = 40),
    e_cv_h_5 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 5, window = 40),
    e_cv_h_6 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 6, window = 40),
    e_cv_h_7 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 7, window = 40),
    e_cv_h_8 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 8, window = 40)
  )

brasil_arimas_tidy <- brasil_arima_fit %>% 
  mutate(tidy = map(auto_arimas, sw_tidy)) %>% 
  unnest(tidy, .drop = TRUE)

brasil_arimas_glance <- brasil_arima_fit %>% 
  mutate(glance = map(auto_arimas, sw_glance)) %>% 
  unnest(glance, .drop = TRUE) 

brasil_arimas_augment <- brasil_arima_fit %>%
  mutate(augment = map(auto_arimas, sw_augment, timetk_idx = TRUE, rename_index = "date")) %>%
  unnest(augment, .drop = TRUE)

brasil_arimas_fcast <- brasil_arima_fit %>% 
  mutate(fcast.arima = map(auto_arimas, forecast, h = 8))

brasil_arimas_fcast_tidy <- brasil_arimas_fcast %>% 
  mutate(swept = map(fcast.arima, sw_sweep, fitted = FALSE,
                     timetk_idx = TRUE)) %>% 
  unnest(swept)

brasil_arimas_fcast_tidy  %>%
  ggplot(aes(x = index, y = value, color = key, group = variable)) +
  geom_ribbon(aes(ymin = lo.95, ymax = hi.95), 
              fill = "#D5DBFF", color = NA, size = 0) +
  geom_ribbon(aes(ymin = lo.80, ymax = hi.80, fill = key), 
              fill = "#596DD5", color = NA, size = 0, alpha = 0.8) +
  geom_line() +
  labs(title = "YoY changes, brazilian data",
       subtitle = "auto.arima (stepwise) forecasts",
       x = "", y = "Units") +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  scale_color_tq() +
  scale_fill_tq() +
  facet_wrap(~ variable, scales = "free_y", ncol = 3) +
  theme_tq() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  






brasil_arima_fit_allcomb <- brasil_n_ts %>%
  mutate(auto_arimas = map(data.ts, auto.arima, 
                           stepwise = FALSE,
                           approximation = FALSE)
  )

brasil_arimas_glance_allcomb <- brasil_arima_fit_allcomb %>% 
  mutate(glance = map(auto_arimas, sw_glance)) %>% 
  unnest(glance, .drop = TRUE) 

compare_stwpwise_allcomb <-  brasil_arimas_glance %>% 
  left_join(brasil_arimas_glance_allcomb, by = "variable", 
            suffix = c("_stpw", "_allcomb"))  %>% 
  mutate(equals = map2(model.desc_stpw, model.desc_allcomb,identical)) %>% 
  select(variable, equals, model.desc_stpw, model.desc_allcomb,
         MASE_stpw, MASE_allcomb)

brasil_arimas_fcast_allcomb <- brasil_arima_fit_allcomb %>% 
  mutate(fcast.arima = map(auto_arimas, forecast, h = 8))

brasil_arimas_fcast_tidy_allcomb <- brasil_arimas_fcast_allcomb %>% 
  mutate(swept = map(fcast.arima, sw_sweep, fitted = FALSE,
                     timetk_idx = TRUE)) %>% 
  unnest(swept)


brasil_arimas_fcast_tidy_allcomb  %>%
  ggplot(aes(x = index, y = value, color = key, group = variable)) +
  geom_ribbon(aes(ymin = lo.95, ymax = hi.95), 
              fill = "#D5DBFF", color = NA, size = 0) +
  geom_ribbon(aes(ymin = lo.80, ymax = hi.80, fill = key), 
              fill = "#596DD5", color = NA, size = 0, alpha = 0.8) +
  geom_line() +
  labs(title = "YoY changes, brazilian data",
       subtitle = "auto.arima (not stepwise) forecasts",
       x = "", y = "Units") +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  scale_color_tq() +
  scale_fill_tq() +
  facet_wrap(~ variable, scales = "free_y", ncol = 3) +
  theme_tq() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



brasil_ets_fit <- brasil_n_ts %>%
  mutate(ets.fit = map(data.ts, ets)
  )

brasil_ets_fcast <- brasil_ets_fit %>% 
  mutate(fcast.ets = map(ets.fit, forecast, h = 8))

brasil_ets_fcast_tidy <- brasil_ets_fcast %>% 
  mutate(swept = map(fcast.ets, sw_sweep, fitted = FALSE,
                     timetk_idx = TRUE)) %>% 
  unnest(swept)


brasil_bats_fit <- brasil_n_ts %>%
  mutate(bats.fit = map(data.ts, bats)
  )

brasil_bats_fcast <- brasil_bats_fit %>% 
  mutate(fcast.bats = map(bats.fit, forecast, h = 8))

brasil_bats_fcast_tidy <- brasil_bats_fcast %>% 
  mutate(swept = map(fcast.bats, sw_sweep, fitted = FALSE,
                     timetk_idx = TRUE)) %>% 
  unnest(swept)

brasil_bats_glance <- brasil_bats_fit %>%
  mutate(glance = map(bats.fit, sw_glance)) %>% 
  unnest(glance, .drop = TRUE) 

brasil_ets_fcast_tidy  %>%
  ggplot(aes(x = index, y = value, color = key, group = variable)) +
  geom_ribbon(aes(ymin = lo.95, ymax = hi.95), 
              fill = "#D5DBFF", color = NA, size = 0) +
  geom_ribbon(aes(ymin = lo.80, ymax = hi.80, fill = key), 
              fill = "#596DD5", color = NA, size = 0, alpha = 0.8) +
  geom_line() +
  labs(title = "YoY changes, brazilian data",
       subtitle = "ETS forecasts",
       x = "", y = "Units") +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  scale_color_tq() +
  scale_fill_tq() +
  facet_wrap(~ variable, scales = "free_y", ncol = 3) +
  theme_tq() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


brasil_bats_fcast_tidy  %>%
  ggplot(aes(x = index, y = value, color = key, group = variable)) +
  geom_ribbon(aes(ymin = lo.95, ymax = hi.95), 
              fill = "#D5DBFF", color = NA, size = 0) +
  geom_ribbon(aes(ymin = lo.80, ymax = hi.80, fill = key), 
              fill = "#596DD5", color = NA, size = 0, alpha = 0.8) +
  geom_line() +
  labs(title = "YoY changes, brazilian data",
       subtitle = "BATS forecasts",
       x = "", y = "Units") +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  scale_color_tq() +
  scale_fill_tq() +
  facet_wrap(~ variable, scales = "free_y", ncol = 3) +
  theme_tq() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))




#after the yq conversion to a proper date variable, if you need a variable 
#in year quarter format, jut do as.yearqtr(brasilQ_yoy$date)
brasil_xts <- tk_xts(brasil)


brasil_tests <- brasil_n_ts %>% 
  mutate(diff_data.ts = map(data.ts, diff),
         adf = map(data.ts, adf.test),
         adf_d = map(diff_data.ts, adf.test))

test_on_lev <- brasil_tests %>% 
  mutate(tidy = map(adf, sw_tidy)) %>% 
  unnest(tidy, .drop = TRUE)brasil_ts <- tk_ts(brasil_xts,
                    start = c(year(min(index(brasil_xts))), 
                              quarter(min(index(brasil_xts)))),
                    frequency = 4)


foo  <- brasil_ts[, "rgdp"]
fa <- auto.arima(foo)



goo_fa <- meta_goo(fa)
tsCV(foo, goo_fa, h = 5)
tsCV(foo, meta_goo(fa), h = 5)



far3 <- function(x, h){forecast(auto.arima(x), h=h)}

eee <- tsCV(foo, far3, h=8)
eee

has_timetk_idx(brasil_ts)

foo <- adf.test(brasil_ts[, "rgdp"])
goo <- adf.test(diff(brasil_ts[, "rgdp"]))

ts_names <- dimnames(brasil_ts)[[2]]



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








