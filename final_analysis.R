rm(list = ls())

library(ggplot2)
library(ppcor)
library(glmmTMB)
library(DHARMa)
library(rcompanion)
library(EnvStats)
library(HoRM)
library(rms)
library(fitdistrplus)
library(rsq)
library(performance)
library(dplyr)
library(actuar)
library(gamlss)
library(ggpubr)

std <- function(x) sd(x)/sqrt(length(x))

setwd("~/rapa_nui_evolution")

data = read.table("finalSims.csv", header = T, sep = ",", skip = 6, quote = "\"", fill = TRUE )
data$ratio =  data$mean.cooperator.list/(data$mean.cooperator.list+data$mean.noncooperator.list)

ratio_subsample = sample(data$ratio, 4000, replace = TRUE)
shapiro.test(ratio_subsample)

data1 = subset(data, gap.width > 4 & patch.width < 3 & average.rain > 20 & average.drought > 20)

lm_model = lm(data1$ratio~data1$P)
summary(lm_model)

data2 = data.frame(P = c(0, .2, .4, .6, .8, 1), Ratio = c(mean(data1$ratio[data1$P==0]), mean(data1$ratio[data1$P==.2]), mean(data1$ratio[data1$P==.4]), mean(data1$ratio[data1$P==.6]), mean(data1$ratio[data1$P==.8]), mean(data1$ratio[data1$P==1])), sd = c(std(data1$ratio[data1$P==0]), std(data1$ratio[data1$P==.2]), std(data1$ratio[data1$P==.4]), std(data1$ratio[data1$P==.6]), std(data1$ratio[data1$P==.8]), std(data1$ratio[data1$P==1])))

ggplot(data2, aes(x = data2$P, y = data2$Ratio))  + 
  geom_line(size = 2) + 
  geom_point(size = 3.5) +
  geom_errorbar(aes(ymin=Ratio-sd, ymax=Ratio+sd), size = 1.2, width=.025, position=position_dodge(0.05)) + 
  scale_x_continuous(breaks = round(seq(min(data2$P), max(data2$P), by = 0.2),1)) + 
  xlab("Periodicity") + ylab("Ratio of Cooperators to Total Population") + 
  ylim(.42, .7) + 
  theme_classic() +theme(axis.text=element_text(size=11), axis.title=element_text(size=12,face="bold"))

data3 = data.frame(P = c(0, .2, .4, .6, .8, 1), Ratio = c(mean(data$ratio[data$P==0]), mean(data$ratio[data$P==.2]), mean(data$ratio[data$P==.4]), mean(data$ratio[data$P==.6]), mean(data$ratio[data1$P==.8]), mean(data$ratio[data$P==1])), sd = c(std(data$ratio[data$P==0]), std(data1$ratio[data$P==.2]), std(data$ratio[data1$P==.4]), std(data$ratio[data$P==.6]), std(data$ratio[data$P==.8]), std(data$ratio[data$P==1])))

ggplot(data3, aes(x = data3$P, y = data3$Ratio))  + 
  geom_line(size = 2) + 
  geom_point(size = 3.5) +
  geom_errorbar(aes(ymin=Ratio-sd, ymax=Ratio+sd), size = 1.2, width=.025, position=position_dodge(0.05)) + 
  scale_x_continuous(breaks = round(seq(min(data3$P), max(data3$P), by = 0.2),1)) + 
  xlab("Periodicity") + ylab("Ratio of Cooperators to Total Population") + 
  ylim(.2, .3) + 
  theme_classic() +theme(axis.text=element_text(size=11), axis.title=element_text(size=12,face="bold"))

model1 = glm(data$ratio ~ data$P + data$gap.width + data$patch.width + data$average.drought + data$average.rain, family = Gamma(link = "log"))

model2 = glm(data$ratio ~ data$P * data$gap.width + data$patch.width + data$average.drought + data$average.rain, family = Gamma(link = "log"))
model3 = glm(data$ratio ~ data$P + data$gap.width * data$patch.width + data$average.drought + data$average.rain, family = Gamma(link = "log"))
model4 = glm(data$ratio ~ data$P + data$gap.width + data$patch.width * data$average.drought + data$average.rain, family = Gamma(link = "log"))
model5 = glm(data$ratio ~ data$P + data$gap.width + data$patch.width + data$average.drought * data$average.rain, family = Gamma(link = "log"))

model6 = glm(data$ratio ~ data$P + data$gap.width + data$patch.width * data$average.drought * data$average.rain, family = Gamma(link = "log"))
model7 = glm(data$ratio ~ data$P + data$gap.width * data$patch.width * data$average.drought + data$average.rain, family = Gamma(link = "log"))
model8 = glm(data$ratio ~ data$P * data$gap.width * data$patch.width + data$average.drought + data$average.rain, family = Gamma(link = "log"))
model9 = glm(data$ratio ~ data$P * data$gap.width + data$patch.width * data$average.drought + data$average.rain, family = Gamma(link = "log"))
model10 = glm(data$ratio ~ data$P * data$gap.width + data$patch.width + data$average.drought * data$average.rain, family = Gamma(link = "log"))
model11 = glm(data$ratio ~ data$P + data$gap.width * data$patch.width + data$average.drought * data$average.rain, family = Gamma(link = "log"))
model11 = glm(data$ratio ~ data$P * data$gap.width + data$patch.width + data$average.drought * data$average.rain, family = Gamma(link = "log"))

model12 = glm(data$ratio ~ data$P * data$gap.width * data$patch.width * data$average.drought + data$average.rain, family = Gamma(link = "log"))
model13 = glm(data$ratio ~ data$P + data$gap.width * data$patch.width * data$average.drought * data$average.rain, family = Gamma(link = "log"))
model14 = glm(data$ratio ~ data$P * data$gap.width + data$patch.width * data$average.drought * data$average.rain, family = Gamma(link = "log"))
model15 = glm(data$ratio ~ data$P * data$gap.width * data$patch.width + data$average.drought * data$average.rain, family = Gamma(link = "log"))

model16 = glm(data$ratio ~ data$P * data$gap.width * data$patch.width * (data$average.drought) * (data$average.rain), family = Gamma(link = "log"))

summary(model16)
plot(model16)

AIC(model1, model2, model3, model4, model5, model6, model7, model8, model9, model10, model11, model12, model13, model14, model15, model16)
BIC(model1, model2, model3, model4, model5, model6, model7, model8, model9, model10, model11, model12, model13, model14, model15, model16)

with(summary(model16), 1 - deviance/null.deviance) #rsquared

check_gamma_model16 <- simulateResiduals(fittedModel = model16, n = 500)
plot(check_gamma_model16)

y.data = data.frame(ratio = data$ratio, P = data$P, gap.width = data$gap.width, patch.width = data$patch.width, average.drought = data$average.drought, average.rain = data$average.rain)
pcor(y.data)

transformed_data = boxcox(data$ratio, optimize = TRUE)
data$transformed_ratio = transformed_data$data

for(i in 1:nrow(data)){
  if(data$ratio[i] == 0){
    data$ratio[i] = .001
  } else if(data$ratio[i] == 1){
    data$ratio[i] = .999
  }
  
}

beta_model = glmmTMB(ratio ~ P + gap.width + patch.width + average.drought + average.rain, data = data, beta_family())
gamma_model <- glm(ratio ~ P + gap.width + patch.width + average.drought + average.rain, data = data, family = Gamma(link = "log"))
normal_model <- glm(ratio ~ P + gap.width + patch.width + average.drought + average.rain, data = data, family = gaussian())
binomial_model = glm(ratio ~ P + gap.width + patch.width + average.drought + average.rain, data = data, family = "binomial")

anova(gamma_model)
g = GOF.tests(beta_model)
g$chisqpvalue
g$adtest
g$kstest
g$cvmtest
g$bic

anova(normal_model)
GOF.tests(normal_model)

anova(binomial_model)
GOF.tests(binomial_model)

check_gamma_model <- simulateResiduals(fittedModel = gamma_model, n = 500)
plot(check_gamma_model)
check_normal_model <- simulateResiduals(fittedModel = normal_model, n = 500)
plot(check_normal_model)
check_beta_model_model <- simulateResiduals(fittedModel = beta_model, n = 500)
plot(check_beta_model_model)
check_binomial_model_model <- simulateResiduals(fittedModel = binomial_model, n = 500)
plot(check_binomial_model_model)

testZeroInflation(check_beta_model_model)

rsq(gamma_model, type='lr') #lr, n, kl, v
rsq(normal_model, type = 'kl')
rsq(binomial_model, type='kl')

r2(beta_model)

data_subset = sample_n(data, 5000) #500 works
beta_model = glmmTMB(ratio ~ P + gap.width + patch.width + average.drought + average.rain, data = data_subset, beta_family())
check_beta_model_model <- simulateResiduals(fittedModel = beta_model, n = 500)
plot(check_beta_model_model)
r2(beta_model)

beta_model = glmmTMB(ratio ~ P * gap.width * patch.width * average.drought * average.rain, data = data_subset, beta_family())
check_beta_model_model <- simulateResiduals(fittedModel = beta_model, n = 500)
plot(check_beta_model_model)
r2(beta_model)
summary(beta_model)
glmmTMB:::Anova.glmmTMB(beta_model)

#erlang distribution, gamma, bimodal 
#do tests of beta dist with rand sample of5000

transformTukey(data$ratio)
boxcox_transformed = boxcox(data$ratio, optimize = TRUE)
shapiro.test(boxcox_transformed$data)
asinTransform = function(p) { asin(sqrt(p)) }
shapiro.test(asinTransform(data$ratio))

### Where are the agents?

data4 = data.frame(agenttype = c(replicate(nrow(data), "Cooperators"), replicate(nrow(data), "Non-Cooperators")), sum_of_timesteps = c(data$mean.tile.count.cooperator.black, data$mean.tile.count.noncooperator.black))

data5 = data.frame(agenttype = c(replicate(nrow(data1), "Cooperators"), replicate(nrow(data1), "Non-Cooperators")), sum_of_timesteps = c(data1$mean.tile.count.cooperator.black, data1$mean.tile.count.noncooperator.black))

ggplot(data4, aes(x = agenttype, y = sum_of_timesteps, fill = agenttype)) + geom_boxplot(notch = TRUE) + theme_bw() + xlab("Type of Agent") + ylab("Average Number of Timesteps on Resourceless Patch Per Capita") + scale_fill_manual(values=c("#0B60E3", "#E30B2C"))

ggplot(data5, aes(x = agenttype, y = sum_of_timesteps, fill = agenttype)) + geom_boxplot() + theme_bw() + xlab("Type of Agent") + ylab("Average Number of Timesteps on Resourceless Patch Per Capita")


### just cooperator number
hist(data$mean.cooperator.list)

fitted_dist_gamma <- fitdist(data$mean.cooperator.list, "gamma")
fitted_dist_exp <- fitdist(data$mean.cooperator.list, "exp")
fitted_dist_weibull <- fitdist(data$mean.cooperator.list, "weibull")
fitted_dist_lognorm <- fitdist(data$mean.cooperator.list, "lnorm")
fitted_dist_loglogistic <- fitdist(data$mean.cooperator.list, "llogis", start = list(shape = 1, scale = 500))
fitted_dist_pareto <- fitdist(data$mean.cooperator.list, "pareto", start = list(shape = 1, scale = 500))
fitted_dist_burr <- fitdist(data$mean.cooperator.list, "burr", start = list(shape1 = 0.3, shape2 = 1, rate = 1))

g = gofstat(list(fitted_dist_gamma, fitted_dist_exp, fitted_dist_weibull, fitted_dist_lognorm, fitted_dist_loglogistic, fitted_dist_pareto, fitted_dist_burr))
g$chisqpvalue
g$adtest
g$kstest
g$cvmtest
g$bic

plot(fitted_dist_gamma)
plot(fitted_dist_exp)
plot(fitted_dist_lognorm)

model1 = gamlss(mean.cooperator.list ~ P + gap.width + patch.width + average.drought + average.rain, data = data, family=LOGNO)
summary(model1)
Rsq(model1)
model2 = gamlss(mean.cooperator.list ~ P * gap.width * patch.width * average.drought * average.rain, data = data, family=LOGNO)
summary(model2)
Rsq(model2)
BIC(model1, model2)

###

model1 = gamlss(ratio ~ P + gap.width + patch.width + average.drought + average.rain, data = data, family=BE)
summary(model1)
Rsq(model1)
plot(model1)
model2 = gamlss(ratio~ P * gap.width * patch.width * average.drought * average.rain, data = data, family=BE)
summary(model2)
Rsq(model2)
plot(model2)
model3 = gamlss(ratio~ gap.width * patch.width * average.drought * average.rain, data = data, family=BE)
summary(model3)
Rsq(model3)
plot(model3)

BIC(model1, model2, model3)

###

fitted_dist_gamma <- fitdist(data$ratio, "gamma")
fitted_dist_exp <- fitdist(data$ratio, "exp")
fitted_dist_weibull <- fitdist(data$ratio, "weibull")
fitted_dist_lognorm <- fitdist(data$ratio, "lnorm")
fitted_dist_loglogistic <- fitdist(data$ratio, "llogis", start = list(shape = 1, scale = 500))
fitted_dist_pareto <- fitdist(data$ratio, "pareto", start = list(shape = 1, scale = 500))
fitted_dist_burr <- fitdist(data$ratio, "burr", start = list(shape1 = 0.3, shape2 = 1, rate = 1))
fitted_dist_beta <- fitdist(data$ratio, "beta")

g = gofstat(list(fitted_dist_gamma, fitted_dist_exp, fitted_dist_weibull, fitted_dist_lognorm, fitted_dist_loglogistic, fitted_dist_pareto, fitted_dist_burr, fitted_dist_beta))
g$chisqpvalue
g$adtest
g$kstest
g$cvmtest
g$bic

### Final model

sample_data = sample_n(data, 500)
final_model = glm(ratio ~ P * gap.width * patch.width * average.drought * average.rain, data = sample_data, family = Gamma(link = "log"))
with(summary(final_model), 1 - deviance/null.deviance) #rsquared

check_gamma_final_model <- simulateResiduals(fittedModel = final_model, n = 500)
plot(check_gamma_final_model)
ks_pval = c()
dis_pval = c()
out_pval = c()
rsquared = c()

for(i in 1:1000){
  sample_data = sample_n(data, 500)
  final_model = glm(ratio ~ P * gap.width * patch.width * average.drought * average.rain, data = sample_data, family = Gamma(link = "log"))
  check_gamma_final_model <- simulateResiduals(fittedModel = final_model, n = 500)
  kstest = testUniformity(check_gamma_final_model, plot = F)
  distest = testDispersion(check_gamma_final_model, plot = F)
  outtest = testOutliers(check_gamma_final_model, plot = F)
  ks_pval[i] = kstest$p.value 
  dis_pval[i] = distest$p.value 
  out_pval[i] = outtest$p.value 
  rsquared[i] = with(summary(final_model), 1 - deviance/null.deviance) #rsquared
}

n = 1000
abc.ci(ks_pval, statistic, index=1, strata=rep(1, n), conf=0.95, 
       eps=0.001/n)

confidence_interval <- function(vector, interval) {
  # Standard deviation of sample
  vec_sd <- sd(vector)
  # Sample size
  n <- length(vector)
  # Mean of sample
  vec_mean <- mean(vector)
  # Error according to t distribution
  error <- qt((interval + 1)/2, df = n - 1) * vec_sd / sqrt(n)
  # Confidence interval as a vector
  result <- c("lower" = vec_mean - error, "upper" = vec_mean + error)
  return(result)
}

ks_interval = eexp(ks_pval, ci = TRUE, conf.level = 0.95)
ks_interval = ks_interval$interval
ks_interval = ks_interval$limits
dis_interval = eexp(dis_pval, ci = TRUE, conf.level = 0.95)
dis_interval = dis_interval$interval
dis_interval = dis_interval$limits

out_interval = confidence_interval(out_pval, 0.95)
rsquared_interval = confidence_interval(rsquared, 0.95)

ks = c(1/ks_interval[2], 1/((ks_interval[1]+ks_interval[2])/2), 1/ks_interval[1]) 
dis = c(1/dis_interval[2], 1/((dis_interval[1]+dis_interval[2])/2), 1/dis_interval[1]) 

### lifespans of cooperators vs noncooperators

data$CooperatorBlackTileProp = data$mean.cooperator.blacktile.list/(data$mean.cooperator.blacktile.list+data$mean.cooperator.greentile.list)
data$NonCooperatorBlackTileProp = data$mean.noncooperator.blacktile.list/(data$mean.noncooperator.blacktile.list+data$mean.noncooperator.greentile.list)

dataLifespan = data.frame(Lifespan = c(data$mean.cooperator.lifespan.list, data$mean.noncooperator.lifespan.list), Type = c(rep( "Cooperator", nrow(data)), rep( "Non-Cooperator", nrow(data))), s = data$gap.width, w = data$patch.width, lambda_r = data$average.rain, lambda_d = data$average.drought, P = data$P, BlackRatio = c(data$CooperatorBlackTileProp, data$NonCooperatorBlackTileProp), PatchHop = c(data$mean.patchHop.cooperators, data$mean.patchHop.noncooperators))

ParameterSpace = c()
for(i in 1:nrow(dataLifespan)){
  if(dataLifespan$s[i] > 4 & dataLifespan$w[i] < 3 & dataLifespan$lambda_r[i] > 20 & dataLifespan$lambda_d[i] > 20){
    ParameterSpace[i] = "Cooperation Promoting"
  } else {
    ParameterSpace[i] = "Cooperation Inhibiting"
  }
}

dataLifespan$ParameterSpace = ParameterSpace

p1 = ggplot(dataLifespan, aes(x = ParameterSpace, y = Lifespan, fill = Type)) + geom_violin() + theme_bw() + xlab("") +labs(fill = "Agent Type") + theme(legend.position = c(0.858, 0.765), legend.background = element_rect(fill="white", size=.5, linetype="solid", colour ="black")) + ylab("Average Lifespan in Timesteps") + ggtitle("A")

dataTemp = sample_n(dataLifespan, 5000)
shapiro.test(dataTemp$Lifespan)

scheirerRayHare(Lifespan ~ Type + ParameterSpace, data=dataLifespan)

plot(data$mean.cooperator.list, data$mean.cooperator.lifespan.list)
plot(data$mean.noncooperator.list, data$mean.noncooperator.lifespan.list)

cor.test(data$mean.cooperator.list, data$mean.cooperator.lifespan.list, method="spearman")
cor.test(data$mean.noncooperator.list, data$mean.noncooperator.lifespan.list, method="spearman")

### Where do workers die? 

p2 = ggplot(dataLifespan, aes(x = ParameterSpace, y = BlackRatio, fill = Type)) + geom_violin() + theme_bw() + xlab("Parameter Space") + ylab("Prop. Time Between Patches") +labs(fill = "Agent Type") + theme(legend.position = "none") + ggtitle("B")#+ stat_summary(fun.y=mean, geom="point", size=2)

ggarrange(p1, p2, nrow = 2, ncol = 1)

scheirerRayHare(BlackRatio ~ Type + ParameterSpace, data=dataLifespan)

ggplot(dataLifespan, aes(x = Type, y = PatchHop, fill = ParameterSpace)) + geom_violin() + theme_bw() + xlab("") + ylab("Prop. Time Between Patches") + stat_summary(fun.y=median, geom="point", size=2) +labs(fill = "Parameter Space") + theme(legend.position = c(0.835, 0.2), legend.background = element_rect(fill="white", size=.5, linetype="solid", colour ="black"))

