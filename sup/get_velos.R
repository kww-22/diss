# ----------------------------------------------------
# Importing velos from data collection googlesheets
# 
# retrieves velos from googlesheet cleans the data frame
# and saves them to the 'velo_csvs' subfolder
# 
# Kyle Wasserberger
#
# Last Updated: 2021-04-13
# ----------------------------------------------------

library(googlesheets4)
library(tidyverse)

get_velos <- function(){

  sheet <- readline('sheet name(s) (separated by commas): ')
  
  sheet <- str_split(sheet,',')
  sheet <- str_trim(sheet[[1]])

  url <- 'https://docs.google.com/spreadsheets/d/1PRBYjZcG9b8jB1vttNicup2MhdabkgZY-tJQMLTPxKc/'
  path <- getwd()

  for(i in 1:length(sheet)){
  data <-  read_sheet(ss = url, sheet = sheet[i])
  data_warmup <- data %>%
    select(c('Throw', 'Vel_warm')) %>%
    drop_na()
  data_warmup$pID <- sheet[i]
  
  data_conds <- data %>%
    select(c('Effort', 'Cond1', 'Cond2', 'Vel_cons')) %>%
    drop_na()
  data_conds$pID <- sheet[i]
  data_conds$Effort <- factor(data_conds$Effort, levels = c('50', '75', '100'))
  data_conds$Cond1 <- factor(data_conds$Cond1, levels = c('step', 'crow'))
  data_conds$Cond2 <- factor(data_conds$Cond2, levels = c('rpe','velo'))
  
  file_name_warmup <- str_glue(path, '/velo_csvs/', sheet[i],'_','velos_warmup')
  file_name_conds <- str_glue(path,'/velo_csvs/',sheet[i], '_', 'velos_conds')
  
  write_csv(data_warmup, file_name_warmup)
  write_csv(data_conds, file_name_conds)
  
  if(file.exists(file_name_conds) == TRUE & file.exists(file_name_warmup) == TRUE){
    print(str_glue('velos extracted for ', sheet[i]))
    }else{
    print('something went wrong, bro')
      }
  }
}

get_velos()

