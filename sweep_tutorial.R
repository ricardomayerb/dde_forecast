# Load libraries
library(sweep)      # Broom-style tidiers for the forecast package
library(forecast)   # Forecasting models and predictions package
library(tidyquant)  # Loads tidyverse, financial pkgs, used to get data
library(timetk)     # Functions working with time series

# Beer, Wine, Distilled Alcoholic Beverages, in Millions USD
beer_sales_tbl <- tq_get("S4248SM144NCEN", get = "economic.data", from = "2010-01-01", to = "2016-12-31")

beer_sales_tbl

# Plot Beer Sales
beer_sales_tbl %>%
  ggplot(aes(date, price)) +
  geom_line(col = palette_light()[1]) +
  geom_point(col = palette_light()[1]) +
  geom_ma(ma_fun = SMA, n = 12, size = 1) +
  theme_tq() +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(title = "Beer Sales: 2007 through 2016")

# Convert from tbl to ts
beer_sales_ts <- tk_ts(beer_sales_tbl, start = 2010, freq = 12)

beer_sales_ts

# Check that ts-object has a timetk index
has_timetk_idx(beer_sales_ts)

# Model using auto.arima
fit_arima <- auto.arima(beer_sales_ts)

fit_arima

# sw_tidy - Get model coefficients
sw_tidy(fit_arima)

# sw_glance - Get model description and training set accuracy measures
sw_glance(fit_arima) %>%
  glimpse()

# sw_augment - get model residuals
sw_augment(fit_arima, timetk_idx = TRUE)

# Plotting residuals
sw_augment(fit_arima, timetk_idx = TRUE) %>%
  ggplot(aes(x = index, y = .resid)) +
  geom_point() + 
  geom_hline(yintercept = 0, color = "red") + 
  labs(title = "Residual diagnostic") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  theme_tq()

# Forecast next 12 months
fcast_arima <- forecast(fit_arima, h = 12)

class(fcast_arima)

# Check if object has timetk index 
has_timetk_idx(fcast_arima)

# sw_sweep - tidies forecast output
fcast_tbl <- sw_sweep(fcast_arima, timetk_idx = TRUE)

fcast_tbl

actuals_tbl <- tq_get("S4248SM144NCEN", get = "economic.data", from = "2017-01-01", to = "2017-12-31")

fcast_tbl %>%
  ggplot(aes(x = index, y = price, color = key)) +
  # 95% CI
  geom_ribbon(aes(ymin = lo.95, ymax = hi.95), 
              fill = "#D5DBFF", color = NA, size = 0) +
  # 80% CI
  geom_ribbon(aes(ymin = lo.80, ymax = hi.80, fill = key), 
              fill = "#596DD5", color = NA, size = 0, alpha = 0.8) +
  # Prediction
  geom_line() +
  geom_point() +
  # Actuals
  geom_line(aes(x = date, y = price), color = palette_light()[[1]], data = actuals_tbl) +
  geom_point(aes(x = date, y = price), color = palette_light()[[1]], data = actuals_tbl) +
  # Aesthetics
  labs(title = "Beer Sales Forecast: ARIMA", x = "", y = "Thousands of Tons",
       subtitle = "sw_sweep tidies the auto.arima() forecast output") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  scale_color_tq() +
  scale_fill_tq() +
  theme_tq()

# Investigate test error 
error_tbl <- left_join(actuals_tbl, fcast_tbl, by = c("date" = "index")) %>%
  rename(actual = price.x, pred = price.y) %>%
  select(date, actual, pred) %>%
  mutate(
    error     = actual - pred,
    error_pct = error / actual
  ) 
error_tbl

# Calculate test error metrics
test_residuals <- error_tbl$error
test_error_pct <- error_tbl$error_pct * 100 # Percentage error

me   <- mean(test_residuals, na.rm=TRUE)
rmse <- mean(test_residuals^2, na.rm=TRUE)^0.5
mae  <- mean(abs(test_residuals), na.rm=TRUE)
mape <- mean(abs(test_error_pct), na.rm=TRUE)
mpe  <- mean(test_error_pct, na.rm=TRUE)

tibble(me, rmse, mae, mape, mpe) %>% glimpse()
