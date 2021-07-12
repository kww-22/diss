
library(lme4)
library(lmerTest)
library(performance)
library(texreg)

# import data
please_work <- read.csv("~/GitHub/diss/data/please_work.csv", stringsAsFactors = T)

m0 <- lmer(velo ~ 1 + (1|pID), data = please_work, 
           REML = T, control = lmerControl(optimizer = "Nelder_Mead"))
mICC <- icc(m0)[[1]]
m1 <- lmer(velo ~ elb_var + (1|pID), data = please_work,
           REML = T, control = lmerControl(optimizer = "Nelder_Mead"))
m2 <- lmer(velo ~ elb_var + I(elb_var^2) + (1|pID), data = please_work,
           REML = T, control = lmerControl(optimizer = "Nelder_Mead"))
m3 <- lmer(velo ~ elb_var + I(elb_var^2) + (1 + elb_var|pID), data = please_work,
           REML = T, control = lmerControl(optimizer = "Nelder_Mead"))
# m4 <- lmer(velo ~ elb_var + log(elb_var) + (1 + elb_var|pID), data = please_work,
#            REML = T, control = lmerControl(optimizer = "Nelder_Mead"))

screenreg(list(m1,m2, m3), digits = 4, single.row = T,
          custom.model.names = c("Rand Int","Poly","Poly + RS"))
summary(m3)

# find range of overall effects of elb_var

b1_min <- fixef(m3)[[2]]+min(ranef(m3)[[1]][2])
b1_max <- fixef(m3)[[2]]+max(ranef(m3)[[1]][2])


m5 <- lmer(velo ~ elb_var + elb_var:velo_max + I(elb_var^2) + (elb_var|pID), data = please_work,
           REML = T, control = lmerControl(optimizer = "Nelder_Mead"))

screenreg(list(m3, m5), digits = 4, single.row = T)

rands <- ranef(m3)[[1]][[2]]
test <- aggregate(please_work[,c("mass","velo_max")], by = list(pID = please_work$pID), FUN = "mean")

cor(rands, test$mass)
cor(rands, test$velo_max)
