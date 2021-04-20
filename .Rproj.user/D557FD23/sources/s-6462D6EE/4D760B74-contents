# ----------------------------------------------------
# velo_long_maker.R
#
# Purpose: to concatenate participant velo csvs into
# one long-format mater csv
#
# author: Kyle Wasserberger
#
# Last Updated: 2021-04-15
# ----------------------------------------------------

library(tidyverse)

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