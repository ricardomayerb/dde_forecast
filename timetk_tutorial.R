library(timetk)     # Toolkit for working with time series in R
library(tidyquant)  # Loads tidyverse, financial pkgs, used to get data

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

# Starting point
beer_sales_tbl

beer_sales_tbl %>%
  tk_index() %>%
  tk_get_timeseries_summary() %>%
  glimpse()

# Augment (adds data frame columns)
beer_sales_tbl_aug <- beer_sales_tbl %>%
  tk_augment_timeseries_signature()

beer_sales_tbl_aug

# linear regression model used, but can use any model
fit_lm <- lm(price ~ ., data = dplyr::select(beer_sales_tbl_aug, -c(date, diff)))

summary(fit_lm)

# Retrieves the timestamp information
beer_sales_idx <- beer_sales_tbl %>%
  tk_index()

tail(beer_sales_idx)
# Make future index
future_idx <- beer_sales_idx %>%
  tk_make_future_timeseries(n_future = 12)

future_idx

new_data_tbl <- future_idx %>%
  tk_get_timeseries_signature()

new_data_tbl

pred <- predict(fit_lm, newdata = dplyr::select(new_data_tbl, -c(index, diff)))

predictions_tbl <- tibble(
  date  = future_idx,
  value = pred
)

predictions_tbl

actuals_tbl <- tq_get("S4248SM144NCEN", get = "economic.data", from = "2017-01-01", to = "2017-12-31")

# Plot Beer Sales Forecast
beer_sales_tbl %>%
  ggplot(aes(x = date, y = price)) +
  # Training data
  geom_line(color = palette_light()[[1]]) +
  geom_point(color = palette_light()[[1]]) +
  # Predictions
  geom_line(aes(y = value), color = palette_light()[[2]], data = predictions_tbl) +
  geom_point(aes(y = value), color = palette_light()[[2]], data = predictions_tbl) +
  # Actuals
  geom_line(color = palette_light()[[1]], data = actuals_tbl) +
  geom_point(color = palette_light()[[1]], data = actuals_tbl) +
  # Aesthetics
  theme_tq() +
  labs(title = "Beer Sales Forecast: Time Series Machine Learning",
       subtitle = "Using basic multivariate linear regression can yield accurate results")

# Investigate test error
error_tbl <- left_join(actuals_tbl, predictions_tbl) %>%
  rename(actual = price, pred = value) %>%
  mutate(
    error     = actual - pred,
    error_pct = error / actual
  ) 
error_tbl

# Calculating test error metrics
test_residuals <- error_tbl$error
test_error_pct <- error_tbl$error_pct * 100 # Percentage error

me   <- mean(test_residuals, na.rm=TRUE)
rmse <- mean(test_residuals^2, na.rm=TRUE)^0.5
mae  <- mean(abs(test_residuals), na.rm=TRUE)
mape <- mean(abs(test_error_pct), na.rm=TRUE)
mpe  <- mean(test_error_pct, na.rm=TRUE)

tibble(me, rmse, mae, mape, mpe) %>% glimpse()
sqrt(rmse)

# Coerce to xts
beer_sales_xts <- tk_xts(beer_sales_tbl) 

# Show the first six rows of the xts object
beer_sales_xts %>%
  head()

tk_tbl(beer_sales_xts, rename_index = "date")

# Coerce to ts
beer_sales_ts <- tk_ts(beer_sales_tbl, start = 2010, freq = 12)

# Show the calendar-printout
beer_sales_ts

tk_tbl(beer_sales_ts, rename_index = "date")

# Check for timetk index. 
has_timetk_idx(beer_sales_ts)

# If timetk_idx is present, can get original dates back 
tk_tbl(beer_sales_ts, timetk_idx = TRUE, rename_index = "date")
