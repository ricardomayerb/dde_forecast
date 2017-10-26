# source('V:/USR/RMAYER/cw/new_normal/functions/add_rtools_path.R')
# source('V:/USR/RMAYER/cw/new_normal/functions/add_miktex_path.R')

library(seasonal)
library(forecast)
library(readxl)
library(tidyr)
library(dplyr)
library(timekit)
library(lubridate)
library(ggplot2)
library(stringr)
library(tseries)
library(xts)
# 
# mex_q <- read_excel(".xlsx", sheet = "quarterly")
# mex_m <- read_excel("Brasil.xlsx", sheet = "monthly")

mex_q  <- read_excel("data_pablo/Mexico.xlsx", sheet = "quarterly")


# domestic variables
dom_names <- c("dom_Brasil", "retail", "vta_bs_k", "tcr", "ibc", "ip", 
               "ip_mining", "ip_manufacturing", "ip_capital_goods",
               "ip_intermediate_goods", "ip_consumer_goods", "ip_dura",
               "ip_nodura", "conf_cons", "conf_emp", "tot", "exp",
               "exp_primary", "imp", "imp_consumer", "imp_intermediate",
               "imp_capital", "tax", "cred", "conf_ibre")

ext_names <- c("ip_us", "ip_ue", "act_chn")

depvar_name <-  "rgdp"

bra_q_xts <- tk_xts(bra_q, date_var = date)

bra_m_xts <- tk_xts(bra_m, date_var = date)

bra_m_xts_to_q <- apply.quarterly(bra_m_xts, mean)

bra_xts <- merge.xts(bra_q_xts, bra_m_xts_to_q)

df_start_date <- min(index(bra_xts))
df_end_date <- max(index(bra_xts))

regvar_name <-  "ibc"

depvar <-  tk_ts(bra_xts[, depvar_name],
              start = c(year(df_start_date), quarter(df_start_date)),
              frequency = 4)

regvar <-  tk_ts(bra_xts[, regvar_name],
            start = c(year(df_start_date), quarter(df_start_date)),
            frequency = 4)

depvar_nona <-  na.remove(depvar)

log_depvar <- log(depvar)
log_depvar_nona <- log(na.remove(depvar))

log_regvar <- log(regvar)
log_regvar_nona <- log(na.remove(regvar))

fit_model_log_depvar <- auto.arima(log_depvar)

fit_model_log_depvar_nona <- auto.arima(log_depvar_nona)
fit_pablo <- Arima(log_depvar_nona, order = c(0,1,1), seasonal = c(0,1,1) )
fit_dmetra <- Arima(log_depvar_nona, order = c(0,1,0), seasonal = c(0,1,1) )
fit_chamullo <- Arima(log_depvar_nona, order = c(1,1,1), seasonal = c(2,0,1) )

fit_pablo_withna <- Arima(log_depvar, order = c(0,1,1), seasonal = c(0,1,1) )


fit_model_log_depvar_nona %>% checkresiduals()
fit_pablo %>% checkresiduals()
fit_dmetra %>% checkresiduals()
fit_chamullo  %>% checkresiduals()
fit_chamullo_2  %>% checkresiduals()

f2018 <- fit_model_log_depvar_nona %>% forecast(h=6)
mean_fcx <- f2018$mean
series_and_fc_xts  <- c(as.xts(f2018$x), as.xts(mean_fcx))
series_and_fc_xts_level <- exp(series_and_fc_xts)
log_diff_4 <- diff(series_and_fc_xts, lag=4)
log_and_diff <- merge.xts(series_and_fc_xts, log_diff_4)
level_diff_4 <- diff(series_and_fc_xts_level, lag=4)
level_gr_4 <- level_diff_4/series_and_fc_xts_level
level_and_gr <-  merge.xts(series_and_fc_xts_level, level_gr_4)
level_and_gr_and_logdiff <- merge.xts(level_and_gr, log_diff_4)


f2018_pablo <- fit_pablo %>% forecast(h=6)
mean_fcx_pablo <- f2018_pablo$mean
series_and_fc_xts_pablo  <- c(as.xts(f2018_pablo$x), as.xts(mean_fcx_pablo))
series_and_fc_xts_level_pablo <- exp(series_and_fc_xts_pablo)
log_diff_4_pablo <- diff(series_and_fc_xts_pablo, lag=4)
log_and_diff_pablo <- merge.xts(series_and_fc_xts_pablo, log_diff_4)
level_diff_4_pablo <- diff(series_and_fc_xts_level_pablo, lag=4)
level_gr_4_pablo <- level_diff_4_pablo/series_and_fc_xts_level_pablo
level_and_gr_pablo <-  merge.xts(series_and_fc_xts_level_pablo, level_gr_4_pablo)
level_and_gr_and_logdiff_pablo <- merge.xts(level_and_gr_pablo, log_diff_4_pablo)


f2018_pablo_w <- fit_pablo_withna %>% forecast(h=6)
mean_fcx_pablo_w <- f2018_pablo_w$mean
series_and_fc_xts_pablo_w  <- c(as.xts(f2018_pablo_w$x), as.xts(mean_fcx_pablo_w))
series_and_fc_xts_level_pablo_w <- exp(series_and_fc_xts_pablo_w)
log_diff_4_pablo_w <- diff(series_and_fc_xts_pablo_w, lag=4)
log_and_diff_pablo_w <- merge.xts(series_and_fc_xts_pablo_w, log_diff_4)
level_diff_4_pablo_w <- diff(series_and_fc_xts_level_pablo_w, lag=4)
level_gr_4_pablo_w <- level_diff_4_pablo_w/series_and_fc_xts_level_pablo_w
level_and_gr_pablo_w <-  merge.xts(series_and_fc_xts_level_pablo_w, level_gr_4_pablo_w)
level_and_gr_and_logdiff_pablo_w <- merge.xts(level_and_gr_pablo_w, log_diff_4_pablo_w)





f2018_dmetra <- fit_dmetra %>% forecast(h=6)
mean_fcx_dmetra <- f2018_dmetra$mean
series_and_fc_xts_dmetra  <- c(as.xts(f2018_dmetra$x), as.xts(mean_fcx_dmetra))
series_and_fc_xts_level_dmetra <- exp(series_and_fc_xts_dmetra)
log_diff_4_dmetra <- diff(series_and_fc_xts_dmetra, lag=4)
log_and_diff_dmetra <- merge.xts(series_and_fc_xts_dmetra, log_diff_4)
level_diff_4_dmetra <- diff(series_and_fc_xts_level_dmetra, lag=4)
level_gr_4_dmetra <- level_diff_4_dmetra/series_and_fc_xts_level_dmetra
level_and_gr_dmetra <-  merge.xts(series_and_fc_xts_level_dmetra, level_gr_4_dmetra)
level_and_gr_and_logdiff_dmetra <- merge.xts(level_and_gr_dmetra, log_diff_4_dmetra)

f2018_chamullo <- fit_chamullo %>% forecast(h=6)
mean_fcx_chamullo <- f2018_chamullo$mean
series_and_fc_xts_chamullo  <- c(as.xts(f2018_chamullo$x), as.xts(mean_fcx_chamullo))
series_and_fc_xts_level_chamullo <- exp(series_and_fc_xts_chamullo)
log_diff_4_chamullo <- diff(series_and_fc_xts_chamullo, lag=4)
log_and_diff_chamullo <- merge.xts(series_and_fc_xts_chamullo, log_diff_4)
level_diff_4_chamullo <- diff(series_and_fc_xts_level_chamullo, lag=4)
level_gr_4_chamullo <- level_diff_4_chamullo/series_and_fc_xts_level_chamullo
level_and_gr_chamullo <-  merge.xts(series_and_fc_xts_level_chamullo, level_gr_4_chamullo)
level_and_gr_and_logdiff_chamullo <- merge.xts(level_and_gr_chamullo, log_diff_4_chamullo)


four_models_gr <- 100 * merge(log_diff_4, log_diff_4_pablo,  log_diff_4_dmetra, log_diff_4_chamullo )
names(four_models_gr) <- c("auto.arima", "011-011", "dmetra", "chamullo")

plot(four_models_gr["2011-06/2018", ])

autoplot(log_depvar_nona) +
  forecast::autolayer(f2018 , series = "(1,1,1) (2,0,0)") + 
  forecast::autolayer(f2018_pablo, PI=FALSE, series = "(0,1,1) (0,1,1)") + 
  forecast::autolayer(f2018_dmetra, PI=FALSE, series = "(0,1,0) (0,1,1)") + 
  forecast::autolayer(f2018_chamullo, PI=FALSE, series = "(1,1,1) (2,0,1)") 
  


autoplot(log_depvar_nona) +
  forecast::autolayer(f2018, PI=FALSE , series = "(1,1,1) (2,0,0)") + 
  forecast::autolayer(f2018_pablo, PI=FALSE, series = "(0,1,1) (0,1,1)") + 
  forecast::autolayer(f2018_dmetra, PI=FALSE, series = "(0,1,0) (0,1,1)") + 
  forecast::autolayer(f2018_chamullo, PI=FALSE, series = "(1,1,1) (2,0,1)") + 
  xlim(c(2010, 2019)) + ylim(c(12.5, 12.67))



#find rgdp specification

log_rgdp_arima_slow_nona <- auto.arima(depvar_nona, lambda = 0, approximation = FALSE, stepwise = FALSE)
log_rgdp_arima_adj_slow_nona <- auto.arima(depvar_nona, lambda = 0, biasadj = TRUE, approximation = FALSE, stepwise = FALSE)

f2018_a <- log_rgdp_arima_adj_slow_nona%>% forecast(h=6)
mean_fcx_a <- f2018_a$mean
series_and_fc_xts_a  <- c(as.xts(f2018_a$x), as.xts(mean_fcx_a))
level_diff_4_a <- diff(series_and_fc_xts_a, lag=4)
level_gr_4_a <- level_diff_4_a/series_and_fc_xts_a
level_and_gr_a <-  merge.xts(series_and_fc_xts_a, level_gr_4_a)

regvar_sd <- diff(regvar, lag = 4)
regvar_sd_lag1 <- lag.xts(regvar_sd, k=1)
regvar_sd_lag2 <- lag.xts(regvar_sd, k=2)

xmat_0 <- regvar_sd
xmat_0_1 <- cbind(regvar_sd, regvar_sd_lag1)
xmat_0_1_2 <- cbind(regvar_sd, regvar_sd_lag1, regvar_sd_lag1)


