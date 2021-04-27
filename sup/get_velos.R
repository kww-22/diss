# ----------------------------------------------------
# get_velos.R
#
# Purpose: to Import velos from data collection googlesheets
# and separate them by participant
# 
# retrieves velos from googlesheet, cleans data frame
# and saves them to the 'velo_csvs' subfolder
# 
# author: Kyle Wasserberger
#
# Last Updated: 2021-04-19
# ----------------------------------------------------

library(googlesheets4)
library(tidyverse)

get_velos <- function(){
  
  # reads sheet names as one character variable
  sheet <- readline('sheet name(s) (separated by commas): ')
  
  # split sheets into separate character variables
  sheet <- str_split(sheet,',')
  sheet <- str_trim(sheet[[1]])
  
  # edit url if you need to access different googlesheet
  url <- 'https://docs.google.com/spreadsheets/d/1PRBYjZcG9b8jB1vttNicup2MhdabkgZY-tJQMLTPxKc/'
  
  # get individual sheet info and subset out demos and template sheets
  sheet_info <- gs4_get(url)
  sheet_names <- sheet_info[["sheets"]][["name"]]
  # all participant data sheets are "pXX" so they have a sheet name of length 3
  p_sheets <- sheet_names[str_length(sheet_names) == 3]
  
  select.list(p_sheets, multiple = TRUE, graphics = TRUE, preselect = p_sheets)
  
  # get directory path for csv saving
  path <- getwd()
  
  # get demo info for level 2 vars
  # filtering by pNums listed above
  demos <- read_sheet(ss = url, sheet = 'Demos') %>%
    filter(pNum %in% sheet)
  
  # loops through saving each csvs for each sheet with custom titles based on sheet name
  for(i in 1:length(sheet)){
  data <- read_sheet(ss = url, sheet = sheet[i])
  data_warmup <- data[-1,] %>%
    select(c('Throw', 'Vel_warm'))
  data_warmup <- data_warmup[1:demos$NumThrows[i],]
  data_warmup <- rename(data_warmup, 
               velo = Vel_warm,
               throw = Throw)
  data_warmup$velo <- as.numeric(data_warmup$velo)
  data_warmup <- mutate(data_warmup, pID = sheet[i],
                 velo_max = max(velo, na.rm = TRUE),
                 velo_min = min(velo, na.rm = TRUE),
                 height = demos$Height[i],
                 mass = demos$Weight[i],
                 age = demos$Age[i],
                 hand = factor(demos$Hand[i]))
  data_warmup <- data_warmup[,c('pID','age', 'mass', 'height', 'hand', 'velo_max', 'velo_min', 'throw', 'velo')]

  
  data_conds <- data %>%
    select(c('Effort', 'Cond1', 'Cond2', 'Vel_cons')) %>%
    drop_na() %>%
      mutate(pID = factor(sheet[i]),
             Effort = factor(Effort, levels = c('50', '75', '100')),
             Cond1 = factor(Cond1, levels = c('step', 'crow')),
             Cond2 = factor(Cond2, levels = c('rpe','velo')))
  
  # get condition df in same order as c3d files
  data_conds <- data_conds %>%
    rename(cond_stp = Cond1,
           cond_int = Cond2,
           velo = Vel_cons,
           effort = Effort) %>%
  arrange(pID,cond_int,effort,desc(cond_stp))
    
  
  data_conds <- data_conds[,c('pID','cond_int','effort','cond_stp','velo')]
  
  file_name_warmup <- str_glue(path, '/sup/velo_csvs/', sheet[i],'_','velos_warmup')
  file_name_conds <- str_glue(path,'/sup/velo_csvs/',sheet[i], '_', 'velos_conds')
  
  write_csv(data_warmup, file_name_warmup)
  write_csv(data_conds, file_name_conds)
  
  # checks to make sure csv files exist in save directory
  if(file.exists(file_name_conds) == TRUE & file.exists(file_name_warmup) == TRUE){
    print(str_glue('velos extracted for ', sheet[i]))
    }else{
    stop('something went wrong, bro')
      }
  }
}

get_velos()

