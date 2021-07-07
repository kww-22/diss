
please_work <- read.csv("~/GitHub/diss/data/please_work.csv", stringsAsFactors = T)

m0 <- lmer(velo ~ 1 + (1|pID), data = please_work, 
           REML = T, control = lmerControl(optimizer = "Nelder_Mead"))
m1 <- lmer(velo ~ elb_var + (1|pID), data = please_work,
           REML = T, control = lmerControl(optimizer = "Nelder_Mead"))
m2 <- lmer(velo ~ elb_var + I(elb_var^2/100) + (1|pID), data = please_work,
           REML = T, control = lmerControl(optimizer = "Nelder_Mead"))
m3 <- lmer(velo ~ elb_var + I(elb_var^2/100) + (1+elb_var|pID), data = please_work,
           REML = T, control = lmerControl(optimizer = "Nelder_Mead"))
m4 <- lmer(velo ~ elb_var + log(elb_var) + (elb_var|pID), data = please_work,
           REML = T, control = lmerControl(optimizer = "Nelder_Mead"))


screenreg(list(m1,m2, m3,m4), digits = 4, single.row = T,
          custom.model.names = c("Rand Int","Poly","Poly + RS","Log"))

# find range of overall effects of elb_var

b1_min <- fixef(m3)[[2]]+min(ranef(m3)[[1]][2])
b1_max <- fixef(m3)[[2]]+max(ranef(m3)[[1]][2])
