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
# Last Updated: 2021-04-27
# ----------------------------------------------------

# library(googlesheets4)
# library(tidyverse)

get_velos <- function(){
  require(googlesheets4)
  require(tidyverse)
  # edit url if you need to access different googlesheet
  url <- 'https://docs.google.com/spreadsheets/d/1PRBYjZcG9b8jB1vttNicup2MhdabkgZY-tJQMLTPxKc/'
  
  # get individual sheet info and subset out demos and template sheets
  sheet_info <- gs4_get(url)
  sheet_names <- sheet_info[["sheets"]][["name"]]
  # all participant data sheets are "pXX" so they have a sheet name of length 3
  p_sheets <- sheet_names[str_length(sheet_names) == 3]
  
  sheets_final <- rev(select.list(p_sheets, multiple = TRUE, graphics = TRUE, preselect = p_sheets))
  
  if(is_empty(sheets_final)){
    stop('no sheets selected')
  }
  # get directory path for csv saving
  path <- getwd()
  
  # get demo info for level 2 vars
  # filtering by pNums listed above
  demos <- read_sheet(ss = url, sheet = 'Demos') %>%
    filter(pNum %in% sheets_final)
  
  # loops through saving each csvs for each sheet with custom titles based on sheet name
  for(i in 1:length(sheets_final)){
    # read everything on sheet i
    data <- read_sheet(ss = url, sheet = sheets_final[i])
    # select warmup throws, rename, and clean data
    data_warmup <- data[-1,] %>%
    select(c('Throw', 'Vel_warm'))
    data_warmup <- data_warmup[1:demos$NumThrows[i],]
    data_warmup <- rename(data_warmup, 
                 velo = Vel_warm,
                 throw = Throw)
    data_warmup$velo <- as.numeric(data_warmup$velo)
    data_warmup <- mutate(data_warmup, pID = sheets_final[i],
                   velo_max = max(velo, na.rm = TRUE),
                   velo_min = min(velo, na.rm = TRUE),
                   height = demos$Height[i],
                   mass = demos$Weight[i],
                   age = demos$Age[i],
                   hand = factor(demos$Hand[i]))
    data_warmup <- data_warmup[,c('pID','age', 'mass', 'height', 'hand', 'velo_max', 'velo_min', 'throw', 'velo')]

    # select condition throws, rename, and clean data
    data_conds <- data %>%
      select(c('Effort', 'Cond1', 'Cond2', 'Vel_cons')) %>%
      drop_na() %>%
        mutate(pID = factor(sheets_final[i]),
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
    
    # create file names for csvs
    file_name_warmup <- str_glue(path, '/sup/velo_csvs/', sheets_final[i],'_','velos_warmup.csv')
    file_name_conds <- str_glue(path,'/sup/velo_csvs/',sheets_final[i], '_', 'velos_conds.csv')
  
    write_csv(data_warmup, file_name_warmup)
    write_csv(data_conds, file_name_conds)
  
    # checks to make sure csv files exist in save directory
    if(file.exists(file_name_conds) == TRUE & file.exists(file_name_warmup) == TRUE){
      print(str_glue('velos extracted for ', sheets_final[i]))
      }else{
      stop('something went wrong, bro')
      }
  }
  
  # get directory path and file info
  path <- str_glue(getwd(),'sup/velo_csvs',.sep = '/')
  files <- list.files(path = path, pattern = '_')
  
  # create numeric vectors so for loops can separate warmup and condition velo files
  file_num_conds <- seq(1,length(files),2)
  file_num_warm <- seq(2,length(files),2)
  
  # initialize blank data frames
  data_conds <- data.frame()
  data_warm <- data.frame()
  
  
  # iterate over data frames using row bind
  for(i in 1:I(length(files)/2)){
    
    
    data_new <- read.csv(str_glue(path,files[file_num_conds[i]], .sep = '/'))
    data_conds <- rbind.data.frame(data_conds, data_new)
    data_new <- read.csv(str_glue(path,files[file_num_warm[i]], .sep = '/'))
    data_warm <- rbind.data.frame(data_warm, data_new)
  }
  
  data_conds <- write.csv(data_conds, str_glue(path, 'masters', 'data_conds.csv', .sep = '/'))
  data_warm <- write.csv(data_warm, str_glue(path, 'masters', 'data_warm.csv', .sep = '/'))
}

get_velos()