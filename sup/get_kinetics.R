
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
colnames(kinetics_info) <- c("elb_var", "shldr_ir")
# bind data frame to velo csv master
data_warm <- read.csv("~/GitHub/diss/sup/velo_csvs/masters/data_warm.csv", stringsAsFactors = T)
data_warm <- data_warm[,-1]
please_work <- cbind.data.frame(data_warm, kinetics_info)


#### get max kinetics for each participant and cbind them to please_work ####

please_work %>% group_by(pID) %>%
  summarise(max_elb_var = max(elb_var, na.rm = T),
            max_shldr_ir = max(shldr_ir, na.rm = T),
            min_elb_var = min(elb_var, na.rm = T),
            min_shldr_ir = min(shldr_ir, na.rm = T)) -> max_kinetics

num_throws <- table(please_work$pID)

rep_velos <- data.frame()

for(i in 1:length(num_throws)){
  max_var <- matrix(rep(max_kinetics$max_elb_var[i],num_throws[i])) 
  max_ir <- matrix(rep(max_kinetics$max_shldr_ir[i],num_throws[i]))
  min_var <- matrix(rep(max_kinetics$min_elb_var[i], num_throws[i]))
  min_ir <- matrix(rep(max_kinetics$min_shldr_ir[i], num_throws[i]))
  data_new <- cbind(max_var, max_ir, min_var, min_ir)
  
  rep_velos <- rbind.data.frame(rep_velos,data_new)
}

colnames(rep_velos) <- c("elb_var_max", "shldr_ir_max", "elb_var_min", "shldr_ir_min")

please_work <- cbind.data.frame(please_work, rep_velos)



write.csv(please_work, "~/GitHub/diss/data/please_work.csv")



