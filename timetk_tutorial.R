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
