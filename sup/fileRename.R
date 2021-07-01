library(tidyverse)
library(tools)
path <- getwd()

d_warm <- read.csv(str_glue(path,"/sup/velo_csvs/masters/data_warm.csv"))
d_warm <- d_warm[,-1]
# d_conds <- read.csv(str_glue(path,"/sup/velo_csvs/masters/data_conds.csv"))
# d_conds <- d_conds[,-1]


files_list <- list.files(str_glue(path, "/data/c3d"), pattern = "warmup")

# d <- read.delim(str_glue(path,"/data/txts/",files_list[37]), skip = 8)

check_file <- str_split(files_list[1],"_")
check_csv <- list(d_warm$pID[1],"warmup",as.character(d_warm$throw[1]))


newFileName <- data.frame() 

for(i in 1:nrow(d_warm)){
  nameNew <- str_glue(file_path_sans_ext(files_list[i]), as.character(d_warm$velo[i]*10), .sep = "_")
  nameNew <- str_glue(nameNew, ".c3d")
  newFileName <- rbind.data.frame(newFileName,nameNew)}

colnames(newFileName) <- "fName"


# rename files

# navigate to folder containing files to be renamed
setwd("~/GitHub/diss/data/c3d")

for(i in 1:nrow(newFileName)){
  file.rename(files_list[i],newFileName[i,])
}


#### error checks ####



# check 1: make sure all warmup files are 22 characters long
# name_check <- data.frame()
# for(i in 1:nrow(newFileName)){
#   name_check_i <- str_length(newFileName$fName[1]) != 22
#   name_check <- rbind.data.frame(name_check, name_check_i)
# }
# name_check <- name_check*1
# wrong_names <- sum(name_check)
# paste0("Files names of wrong length: ", as.character(wrong_names))
# 
# 
# # give indicies of file names containing certain pattern
# which(str_detect(newFileName$fName, pattern = "p00"))
 