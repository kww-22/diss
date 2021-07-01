library(tidyverse)
library(patchwork)
path <- getwd()

d <- read.csv("sup/velo_csvs/masters/data_warm.csv", stringsAsFactors = T)

ggplot(data = d, aes(x = throw, y = velo, color = pID)) +
  geom_path(size = 1, show.legend = F) +
  geom_point(size = 2, show.legend = F) +
  theme_bw() +
  theme(aspect.ratio = 1,
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 16))


p1 <- ggplot(data = please_work, aes(x = max_shldr_ir, y = velo, color = pID, label = paste0(pID,".",throw))) +
  geom_point(size = 1, show.legend = F) +
  # geom_label() +
  theme_bw() +
  theme(aspect.ratio = 1,
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 14)) +
  xlab("Peak Shoulder ER Torque (Nm)") +
  ylab("Velo (mph)")


p2 <- ggplot(data = please_work, aes(x = max_elb_var, y = velo, color = pID, label = paste0(pID,".",throw))) +
  geom_point(size = 1, show.legend = F) +
  # geom_label() +
  theme_bw() +
  theme(aspect.ratio = 1,
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 14)) +
  xlab("Peak Elbow Valgus Torque (Nm)") +
  ylab("")

patchwork <- p1 + p2

patchwork + plot_annotation(
  title = "how do joint loads change as throwing intensity increases?",
  caption = "Kyle Wasserberger (@kwwAU)"
)


test <- subset(please_work, pID == "p15")

plot(test$max_shldr_ir, test$velo)


write.csv(please_work, "please_work.csv")
