# ----------------------------------------------------
# Importing velos from data collection googlesheets
# 
# Kyle Wasserberger
#
# Last Updated: 2021-04-06
# ----------------------------------------------------

library(googlesheets)
library(tidyverse)

url <- 'https://docs.google.com/spreadsheets/d/1PRBYjZcG9b8jB1vttNicup2MhdabkgZY-tJQMLTPxKc/edit?ouid=103808532767151422499&usp=sheets_home&ths=true'
sheet <- 'p00'
path <- getwd()

data <-  read_sheet(ss = url, sheet = sheet)
  data_warmup <- data %>%
    select(c('Throw', 'Vel_warm')) %>%
    drop_na()
  data_warmup$pID <- sheet

  data_conds <- data %>%
    select(c('Effort', 'Cond1', 'Cond2', 'Vel_cons')) %>%
    drop_na()
  data_conds$pID <- sheet
  data_conds$Effort <- factor(data_conds$Effort, levels = c('50', '75', '100'))
  data_conds$Cond1 <- factor(data_conds$Cond1, levels = c('step', 'crow'))
  data_conds$Cond2 <- factor(data_conds$Cond2, levels = c('rpe','velo'))

write_csv(data_warmup,str_glue(path,'/sup/velo_csvs/',sheet,'_','velos_warmup'))
write_csv(data_conds, str_glue(path,'/sup/velo_csvs/',sheet, '_', 'velos_conds'))
