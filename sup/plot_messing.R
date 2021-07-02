library(tidyverse)
library(patchwork)
path <- getwd()

please_work <- read.csv("~/GitHub/diss/data/please_work.csv", stringsAsFactors = T)

p1 <- ggplot(data = subset(please_work, pID %in% please_work$pID[runif(3,1,nrow(please_work))]), aes(x = shldr_ir, y = velo, shape = pID, color = pID, label = paste0(pID,".",throw))) +
  geom_point(size = 3, show.legend = F) +
  # geom_label() +
  theme_bw() +
  theme(aspect.ratio = 1,
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 14)) +
  xlab("Peak Shoulder ER Torque (Nm)") +
  ylab("Velo (mph)") +
  xlim(c(10,95))


p2 <- ggplot(data = subset(please_work, pID %in% please_work$pID[runif(3,1,nrow(please_work))]), aes(x = elb_var, y = velo, shape = pID, color = pID, label = paste0(pID,".",throw))) +
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

