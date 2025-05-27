#Obtain data

library(tidyverse)
library(tidyquant)



Ra <- c("ZM", "WORK", "DOCU", "TEAM",  "CTXS", "RNG", "LOGM") %>%
  tq_get(get  = "stock.prices",
         from = "2015-01-01",
         to   = "2024-04-08") %>%
  group_by(symbol) %>%
  tq_transmute(select     = adjusted, 
               mutate_fun = periodReturn, 
               period     = "daily", 
               col_rename = "Ra")
Ra

Rb <- "XLC" %>%
  tq_get(get  = "stock.prices",
         from = "2015-01-01",
         to   = "2024-03-29") 
Rb

Rc <- c("ZM", "WORK", "DOCU", "TEAM",  "CTXS", "RNG", "LOGM") %>%
  tq_get(get  = "stock.prices",
         from = "2015-01-01",
         to   = "2024-03-29")