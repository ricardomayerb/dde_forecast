library(forecast)
library(tidyquant)
library(timetk)
library(sweep)

alcohol_sales_tbl <- tq_get("S4248SM144NCEN", 
                            get  = "economic.data", 
                            from = "2007-01-01",
                            to   = "2016-12-31")
alcohol_sales_tbl

alcohol_sales_tbl %>%
  ggplot(aes(x = date, y = price)) +
  geom_line(size = 1, color = palette_light()[[1]]) +
  geom_smooth(method = "loess") +
  labs(title = "US Alcohol Sales: Monthly", x = "", y = "Millions") +
  scale_y_continuous(labels = scales::dollar) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  theme_tq()
