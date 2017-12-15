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
library(readxl)

# use brasilQ_yoy, clear
# * tidy the data
# gen qdate = quarterly(date, "YQ")
# format qdate %tq
# tsset qdate
# brasilQ_yoy <- read_dta("data/brasilQ_yoy.dta")


country_q <- read_excel("data/Brasil.xlsx", sheet = "quarterly")
country_m <- read_excel("data/Brasil.xlsx", sheet = "monthly")

country <- country_q %>% select(-c(year, quarter, trim, hlookup)) %>% 
  filter(!is.na(rgdp))


country$date <- ymd(country_q$date)

start_year <- min(year(country$date))

country_long <- country %>% gather(variable, value, -date)

country_nested <- country_long %>% group_by(variable) %>% 
  nest(.key = "data.tbl")

ntest <-  16
train_ends <- nrow(country) - ntest - 1
test_starts <- nrow(country) - ntest


country_n_ts <- country_nested %>% 
  mutate(data.ts = map(.x   =  data.tbl,
                       .f   =  tk_ts,
                       start = start_year,
                       freq = 4
                       ),
         train_data.ts = map(.x = data.ts,
                             .f = subset,
                             end = train_ends),
         test_data.ts = map(.x = data.ts,
                           .f = subset,
                           start = test_starts)
         )

country_n_ts$data.ts[[1]]


# fun_for <- function(x, h){forecast(auto.arima(x), h=h)}


meta_goo <- function(mod, h){
  function(y,h) {forecast(Arima(y, model = mod), h)}
}


# country_auto_all <- country_n_ts %>%
#  mutate(auto_arimas = map(data.ts, auto.arima),
#         a_forecast = map(auto_arimas, forecast, h = 8),
#         a_acu = map(a_forecast, accuracy),
#         e_cv = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 5)
#         )

country_arima_fit <- country_n_ts %>%
  mutate(auto_arimas = map(data.ts, auto.arima)
  )

country_arima_eCV <- country_arima_fit %>% 
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


country_arima_eCV_w40 <- country_arima_fit %>% 
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


mbm <- microbenchmark(
  "country_arima_eCV" = country_arima_fit %>% 
    mutate(
     e_cv_h_1 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 1),
     e_cv_h_2 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 2),
     e_cv_h_3 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 3),
     e_cv_h_4 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 4),
     e_cv_h_5 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 5),
     e_cv_h_6 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 6),
     e_cv_h_7 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 7),
     e_cv_h_8 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 8)
                         ),
  "country_arima_eCV_w40" = country_arima_fit %>% 
    mutate(
      e_cv_h_1 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 1, window = 40),
      e_cv_h_2 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 2, window = 40),
      e_cv_h_3 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 3, window = 40),
      e_cv_h_4 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 4, window = 40),
      e_cv_h_5 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 5, window = 40),
      e_cv_h_6 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 6, window = 40),
      e_cv_h_7 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 7, window = 40),
      e_cv_h_8 = map2(data.ts, map(auto_arimas, meta_goo), tsCV, h = 8, window = 40)
    ),
  times = 10
)

country_arimas_tidy <- country_arima_fit %>% 
  mutate(tidy = map(auto_arimas, sw_tidy)) %>% 
  unnest(tidy, .drop = TRUE)

country_arimas_glance <- country_arima_fit %>% 
  mutate(glance = map(auto_arimas, sw_glance)) %>% 
  unnest(glance, .drop = TRUE) 

country_arimas_augment <- country_arima_fit %>%
  mutate(augment = map(auto_arimas, sw_augment, timetk_idx = TRUE, rename_index = "date")) %>%
  unnest(augment, .drop = TRUE)

country_arimas_fcast <- country_arima_fit %>% 
  mutate(fcast.arima = map(auto_arimas, forecast, h = 8))

country_arimas_fcast_tidy <- country_arimas_fcast %>% 
  mutate(swept = map(fcast.arima, sw_sweep, fitted = FALSE,
                     timetk_idx = TRUE)) %>% 
  unnest(swept)

country_arimas_fcast_tidy  %>%
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
  






country_arima_fit_allcomb <- country_n_ts %>%
  mutate(auto_arimas = map(data.ts, auto.arima, 
                           stepwise = FALSE,
                           approximation = FALSE)
  )

country_arimas_glance_allcomb <- country_arima_fit_allcomb %>% 
  mutate(glance = map(auto_arimas, sw_glance)) %>% 
  unnest(glance, .drop = TRUE) 

compare_stwpwise_allcomb <-  country_arimas_glance %>% 
  left_join(country_arimas_glance_allcomb, by = "variable", 
            suffix = c("_stpw", "_allcomb"))  %>% 
  mutate(equals = map2(model.desc_stpw, model.desc_allcomb,identical)) %>% 
  select(variable, equals, model.desc_stpw, model.desc_allcomb,
         MASE_stpw, MASE_allcomb)

country_arimas_fcast_allcomb <- country_arima_fit_allcomb %>% 
  mutate(fcast.arima = map(auto_arimas, forecast, h = 8))

country_arimas_fcast_tidy_allcomb <- country_arimas_fcast_allcomb %>% 
  mutate(swept = map(fcast.arima, sw_sweep, fitted = FALSE,
                     timetk_idx = TRUE)) %>% 
  unnest(swept)


country_arimas_fcast_tidy_allcomb  %>%
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



country_ets_fit <- country_n_ts %>%
  mutate(ets.fit = map(data.ts, ets)
  )

country_ets_fcast <- country_ets_fit %>% 
  mutate(fcast.ets = map(ets.fit, forecast, h = 8))

country_ets_fcast_tidy <- country_ets_fcast %>% 
  mutate(swept = map(fcast.ets, sw_sweep, fitted = FALSE,
                     timetk_idx = TRUE)) %>% 
  unnest(swept)


country_bats_fit <- country_n_ts %>%
  mutate(bats.fit = map(data.ts, bats)
  )

country_bats_fcast <- country_bats_fit %>% 
  mutate(fcast.bats = map(bats.fit, forecast, h = 8))

country_bats_fcast_tidy <- country_bats_fcast %>% 
  mutate(swept = map(fcast.bats, sw_sweep, fitted = FALSE,
                     timetk_idx = TRUE)) %>% 
  unnest(swept)

country_bats_glance <- country_bats_fit %>%
  mutate(glance = map(bats.fit, sw_glance)) %>% 
  unnest(glance, .drop = TRUE) 

country_ets_fcast_tidy  %>%
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


country_bats_fcast_tidy  %>%
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
#in year quarter format, jut do as.yearqtr(countryQ_yoy$date)
country_xts <- tk_xts(country)


country_tests <- country_n_ts %>% 
  mutate(diff_data.ts = map(data.ts, diff),
         adf = map(data.ts, adf.test),
         adf_d = map(diff_data.ts, adf.test))

test_on_lev <- country_tests %>% 
  mutate(tidy = map(adf, sw_tidy)) %>% 
  unnest(tidy, .drop = TRUE)

country_ts <- tk_ts(country_xts,
                    start = c(year(min(index(country_xts))), 
                              quarter(min(index(country_xts)))),
                    frequency = 4)


foo  <- country_ts[, "rgdp"]
fa <- auto.arima(foo)



goo_fa <- meta_goo(fa)
tsCV(foo, goo_fa, h = 5)
tsCV(foo, meta_goo(fa), h = 5)



far3 <- function(x, h){forecast(auto.arima(x), h=h)}

eee <- tsCV(foo, far3, h=8)
eee

has_timetk_idx(country_ts)

foo <- adf.test(country_ts[, "rgdp"])
goo <- adf.test(diff(country_ts[, "rgdp"]))

ts_names <- dimnames(country_ts)[[2]]



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








