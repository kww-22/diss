library(tidyverse)
library(patchwork)
path <- getwd()

please_work <- read.csv("~/GitHub/diss/data/please_work.csv", stringsAsFactors = T)

pIDs <- tibble(unique(please_work$pID))

p1 <- ggplot(data = subset(please_work, pID %in% pIDs[[1]][runif(5,1,nrow(pIDs))]), aes(x = shldr_ir, y = velo, shape = pID, color = pID, label = paste0(pID,".",throw))) +
  geom_point(size = 3, show.legend = F) +
  # geom_label() +
  theme_bw() +
  theme(aspect.ratio = 1,
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 14)) +
  xlab("Peak Shoulder ER Torque (Nm)") +
  ylab("Velo (mph)") +
  xlim(c(10,95))


p2 <- ggplot(data = subset(please_work, pID %in% pIDs[[1]][runif(5,1,nrow(pIDs))]), aes(x = elb_var, y = velo, shape = pID, color = pID, label = paste0(pID,".",throw))) +
  geom_point(size = 3, show.legend =T) +
  # geom_label() +
  theme_bw() +
  theme(aspect.ratio = 1,
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 14)) +
  xlab("Peak Elbow Valgus Torque (Nm)") +
  ylab("") +
  xlim(c(10,95))

patchwork <- p1 + p2

patchwork + plot_annotation(
  title = "how do joint loads change as throwing intensity increases?",
  caption = "Kyle Wasserberger (@kwwAU)"
)

p1 <- plot(please_work$elb_var, please_work$velo)
lin.curve <- curve(cbind(1,x,x^2) %*% fixef(m3), add = T)
lin.data <- tibble(x = lin.curve[["x"]],
                   y = lin.curve[["y"]])



ggplot(data = subset(please_work, pID %in% pIDs[[1]][runif(35,1,nrow(pIDs))]), 
                     aes(x = elb_var, y = velo, color = pID)) +
  geom_point(size = 3, show.legend = F) +
  # geom_label() +
  theme_bw() +
  theme(aspect.ratio = 1,
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 14)) +
  geom_smooth(method = "lm", formula = y ~ x + log(x), se = F, size = 1.5) + 
  # plot fixed effect line
  geom_line(data = lin.data, aes(x = x, y = y), color = "black", size = 2) +
  labs(x = "Elbow Torque (Nm)",
       y = "Ball Speed (mph)",
       caption = "Kyle Wasserberger (@kww_AU)") 
  

ggplot(data = please_work[which(please_work$pID == "p34"),],
       aes(x = elb_var, y = velo, color = pID)) +
  geom_point(size = 3, show.legend = F) +
  # geom_label() +
  theme_bw() +
  theme(aspect.ratio = 1,
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 14)) +
  geom_smooth(method = "lm", formula = y ~ poly(x,2), se = F, size = 1.5) + 
  # plot fixed effect line
  geom_line(data = lin.data, aes(x = x, y = y), color = "black", size = 2) +
  labs(x = "Shoulder Rotation Torque (Nm)",
       y = "Ball Speed (mph)",
       caption = "Kyle Wasserberger (@kww_AU)") 
