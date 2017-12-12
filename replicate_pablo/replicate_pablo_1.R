library(timetk)
library(tidyquant)
library(xts)
library(forecast)
library(sweep)
library(readxl)

bra_q <- read_excel("Brasil.xlsx", sheet = "quarterly")
bra_m <- read_excel("Brasil.xlsx", sheet = "monthly")


# domestic variables
dom_names <- c("dom_Brasil", "retail", "vta_bs_k", "tcr", "ibc", "ip", 
               "ip_mining", "ip_manufacturing", "ip_capital_goods",
               "ip_intermediate_goods", "ip_consumer_goods", "ip_dura",
               "ip_nodura", "conf_cons", "conf_emp", "tot", "exp",
               "exp_primary", "imp", "imp_consumer", "imp_intermediate",
               "imp_capital", "tax", "cred", "conf_ibre")

ext_names <- c("ip_us", "ip_ue", "act_chn")

depvar_name <-  "rgdp"


