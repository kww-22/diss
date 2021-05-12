library(lme4)
library(tidyverse)
mod <- lmer(Reaction ~ Days + (Days|Subject), data = sleepstudy)

summary(mod)

ggplot(data = sleepstudy[1:60,], aes(x = Days, y = Reaction, color = Subject)) +
  geom_path(size = 1) +
  geom_point(size = 2) +
  theme_bw() +
  theme(aspect.ratio = 1)
