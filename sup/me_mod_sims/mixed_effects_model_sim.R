# ####
# mixed_effects_model_sim.R
# purpose: simulate mixed models
# taken from: https://m-clark.github.io/docs/mixedModels/mixedModels.html
# ####

# mixed effects model with random intercepts and slopes
# setup
set.seed(1234)
nclus = 100                                 # number of groups
clus = factor(rep(1:nclus, each=10))        # cluster variable
n = length(clus)                            # total n

# parameters
sigma = 1                                   # residual sd
psi = matrix(c(1,.5,.5,1),
             nrow =  2,
             ncol = 2)                      # re covar
gamma_ = MASS::mvrnorm(nclus, mu=c(0,0), Sigma=psi, empirical=TRUE)     # random effects
e = rnorm(n, mean=0, sd=sigma)              # residual error
intercept = 3           
# fixed effects (grand mean intercept)
b1 = .75                                    # fixed effects (grand mean slope)

# data
x = rnorm(n)                                # covariate
y = intercept+gamma_[clus,1] + (b1+gamma_[clus,2])*x  + e               # see model 1
d = data.frame(x, y, clus=clus)
head(d)

# matrix form
# X = cbind(1, x)
# B = c(intercept, b1)
# G = gamma_[clus,]
# Z = X
# y2 = X%*%B  + rowSums(Z*G) + e              # **shortcut**
# 
# Z = matrix(0, nrow=nrow(X), ncol=ncol(X)*nclus)                        
# 
# for (i in 1:nclus){
#   fc = i*2-1
#   cols =  fc:(fc+1)
#   idx = (1:n)[clus==i]
#   Z[idx,cols] = X[idx,]
# }
# 
# G = c(t(gamma_))
# y3 = X%*%B  + Z%*%G + e                     # as in model 3c
# head(data.frame(y, y2, y3))


mod <- lme4::lmer(y ~ x + (x|clus), data = d)
summary(mod)
