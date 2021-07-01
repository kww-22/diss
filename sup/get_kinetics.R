
# =====================
# get_kinetics.R
# purpose: runs through MotionMonitor txt outputs and cbinds generated dataframe to
#          original master csv from get_velos.R
# author: Kyle Wasserberger
# last updated: 2021-07-01
# =====================

#### initialize data frome and set directory ####
kinetics_info <- data.frame()
setwd("C:/Users/kylew/Documents/GitHub/diss/data/txts")
file_list <- list.files(pattern = "warmup")

#### loop through txt files ####
for(i in 1:length(file_list)){
  txt_data <- read_delim(file_list[i], skip = 10, delim = "\t")
  
  if(str_detect(file_list[i],pattern = "BAD")){
    row_data <- c(NA,NA)} else{
  
  if(max(txt_data$RwristLinVelo) > max(txt_data$LwristLinVelo)){
    ind_max <- which.max(txt_data$RwristLinVelo)
  } else{
    ind_max <- which.max(txt_data$LwristLinVelo)
  }
  txt_new <- txt_data[1:ind_max,]
  max_elb_var <- max(txt_new$elbVar)
  max_shldr_IR <- max(txt_new$shldrIR)
  row_data <- c(max_elb_var, max_shldr_IR)}
  kinetics_info <- rbind.data.frame(kinetics_info, row_data)
}

# customize data frame column names
colnames(kinetics_info) <- c("max_elb_var", "max_shldr_ir")
# bind data frame to velo csv master
data_warm <- read.csv("~/GitHub/diss/sup/velo_csvs/masters/data_warm.csv", stringsAsFactors = T)
please_work <- cbind.data.frame(data_warm, kinetics_info)
write.csv(please_work, "please_work.csv")





