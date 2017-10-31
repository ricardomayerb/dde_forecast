library(tidyquant)

FANG_symbols <- c("FB", "AMZN", "NFLX", "GOOG")

FANG_data_d <- FANG_symbols %>% 
  tq_get(get = "stock.prices", from = "2014-01-01",
         to = "2016-12-31")

FANG_data_d

FANG_data_d %>% 
  ggplot(aes(x = date, y = adjusted, color = symbol)) +
  geom_line() + 
  facet_wrap(~ symbol, ncol = 2, scales = "free_y") + 
  theme_tq() + 
  scale_color_tq() + 
  labs(title = "Visualize Financial Data")



# Create a vector of FRED symbols
FRED_symbols <- c('ETOTALUSQ176N',    # All housing units
                  'EVACANTUSQ176N',   # Vacant
                  'EYRVACUSQ176N',    # Year-round vacant
                  'ERENTUSQ176N'      # Vacant for rent
)

FRED_data_m <- FRED_symbols %>% 
  tq_get(get = "economic.data", from  = "2001-04-01")

FRED_data_m

FRED_data_m %>%
  ggplot(aes(x = date, y = price, color = symbol)) + 
  geom_line() +
  facet_wrap(~ symbol, ncol = 2, scales = "free_y") +
  theme_tq() +
  scale_color_tq() +
  labs(title = "Visualize Economic Data")

# Change periodicity from daily to monthly using to.period from xts
FANG_data_m <- FANG_data_d %>%
  group_by(symbol) %>%
  tq_transmute(
    select      = adjusted,
    mutate_fun  = to.period,
    period      = "months"
  )

FANG_data_m

# Daily data
FANG_data_d %>%
  ggplot(aes(date, adjusted, color = symbol)) +
  geom_point() +
  geom_line() +
  facet_wrap(~ symbol, ncol = 2, scales = "free_y") +
  scale_color_tq() +
  theme_tq() +
  labs(title = "Before transformation: Too Much Data")

# Monthly data
FANG_data_m %>%
  ggplot(aes(date, adjusted, color = symbol)) +
  geom_point() +
  geom_line() +
  facet_wrap(~ symbol, ncol = 2, scales = "free_y") +
  scale_color_tq() +
  theme_tq() +
  labs(title = "After transformation: Easier to Understand")

# Lags - Get first 5 lags

# Pro Tip: Make the new column names first, then add to the `col_rename` arg
column_names <- paste0("lag", 1:5)

# First five lags are output for each group of symbols
FANG_data_d %>%
  select(symbol, date, adjusted) %>%
  group_by(symbol) %>%
  tq_mutate(
    select     = adjusted,
    mutate_fun = lag.xts,
    k          = 1:5,
    col_rename = column_names
  )

# Rolling quantile
FANG_data_d %>%
  select(symbol, date, adjusted) %>%
  group_by(symbol) %>%
  tq_mutate(
    select     = adjusted,
    mutate_fun = rollapply,
    width      = 10,
    by.column  = FALSE,
    FUN        = quantile,
    probs      = c(0, 0.025, 0.25, 0.5, 0.75, 0.975, 1),
    na.rm      = TRUE
  )

# Available functions
# mutate_fun =
tq_transmute_fun_options()
