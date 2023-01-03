library(TSA)
library(ggplot2)
library(vcd)
library(MASS)
library(RGeode)
library(ggpubr)
library(RColorBrewer)

#normal stochastic rain with markof chain 

rain = round(runif(1, 0, 1))
rain_vector = c(rain)

p_r_given_r = .8
p_nr_given_nr = .9

simulations = 10000

for(i in 2:simulations){
  
  if (rain == 1){
    
    random_number = runif(1,0,1)
    
    if(random_number <= p_r_given_r){
      
      rain_vector[i] = 1
      rain = 1
      
    } else {
      
      rain_vector[i] = 0
      rain = 0     
      
    }
    
  } else {
    
    random_number = runif(1,0,1)
    
    
    if(random_number <= p_nr_given_nr){
      
      rain_vector[i] = 0
      rain = 0
      
    } else {
      
      rain_vector[i] = 1
      rain = 1     
      
    }
    
  }
  
}     

rain_counter = 0
rain_fall_vector = c()

for(i in 1:length(rain_vector)){
  if (rain_vector[i] == 1){
    rain_counter = rain_counter + 1
  } else {
    rain_fall_vector = c(rain_fall_vector, rain_counter)
    rain_counter = 0
  }
}

rain_fall_vector =  rain_fall_vector[rain_fall_vector  != 0]

drought_counter = 0
drought_vector = c()

for(i in 1:length(rain_vector)){
  if (rain_vector[i] == 0){
    drought_counter = drought_counter + 1
  } else {
    drought_vector = c(drought_vector, drought_counter)
    drought_counter = 0
  }
}

drought_vector =  drought_vector[drought_vector  != 0]

acf(rain_vector, main = "ACF of Rainfall as Markov Process")   
periodogram(rain_vector,log='no',plot=TRUE,ylab="Power", xlab="Frequency",lwd=2, main = "Preriodogram of Markov Process")
hist(rain_fall_vector, main = "Distribution of Rainfall Durations in Markov Process", xlab = "Duration", breaks = 30)
hist(drought_vector,  main = "Distribution of Drought Durations in Markov Process", xlab = "Duration", breaks = 30)
plot(rain_vector, xlim = c(0,250), pch = 19, main = "Time Series of Rainfall in Markov Process", ylab = "O = Drought, 1 = Rain", xlab = "Time Steps")

#replicating this process by drawing from 2 exp dist (one for rain and one for drought)

T = 1/.004117079 #average duration of drought
R = 1/1.829494 #average duration of rainfall event 
lambda_t = 1/T
lambda_r = 1/R

N = 50000 #time steps 

T_vector = c()
R_vector = c()

i = 1
sum = 0

while (sum < N) {
  T_vector[i] = round(rexp(1, rate = lambda_t)) #should this be gaussian? Check data 
  R_vector[i] = round(rexp(1, rate = lambda_r))
  sum = sum(T_vector, R_vector)
  i = i+1
}

combined_vector = as.vector(rbind(T_vector, R_vector))

rain_vector = c()
zeros_vector = c()
ones_vector = c()

for(i in 1:length(combined_vector)){
  if((i %% 2) == 1){
    zeros_vector = rep(0, combined_vector[i])
    rain_vector = c(rain_vector, zeros_vector)
    zeros_vector = c()
  } else {
    ones_vector = rep(1, combined_vector[i])
    rain_vector = c(rain_vector, ones_vector)
    ones_vector = c()
  }
}

rain_vector = head(rain_vector, N)
rain_vector = data.frame(behavior = as.character(rain_vector))
write.csv(rain_vector, "Simulated_behavior_real_diff")


acf(rain_vector, main = "ACF of Sequential Sampling of Exponential Distributions")
periodogram(rain_vector,log='no',plot=TRUE,ylab="Power", xlab="Frequency",lwd=2, main = "Preriodogram of Sequential Sampling")
hist(R_vector, main = "Distribution of Rainfall Durations of Sequential Sampling", xlab = "Duration", breaks = 30)
hist(T_vector,  main = "Distribution of Drought Durations of Sequential Sampling", xlab = "Duration", breaks = 30)
plot(rain_vector, xlim = c(0,250), pch = 19, main = "Time Series of Rainfall of Sequential Sampling", ylab = "O = Drought, 1 = Rain", xlab = "Time Steps")

#replicating this process by drawing from 2 exp dist (one for rain and one for drought) - uses 2 parameters for exp dist 

T = 1/.004117079 #average duration of drought
R = 1/1.829494 #average duration of rainfall event 
lambda_t = 1/T
lambda_r = 1/R

N = 50000 #time steps 

T_vector = c()
R_vector = c()

i = 1
sum = 0

while (sum < N) {
  T_vector[i] = round(rexp(1, rate = lambda_t)) #should this be gaussian? Check data 
  R_vector[i] = round(rexp(1, rate = lambda_r))
  sum = sum(T_vector, R_vector)
  i = i+1
}

combined_vector = as.vector(rbind(T_vector, R_vector))

rain_vector = c()
zeros_vector = c()
ones_vector = c()

for(i in 1:length(combined_vector)){
  if((i %% 2) == 1){
    zeros_vector = rep(0, combined_vector[i])
    rain_vector = c(rain_vector, zeros_vector)
    zeros_vector = c()
  } else {
    ones_vector = rep(1, combined_vector[i])
    rain_vector = c(rain_vector, ones_vector)
    ones_vector = c()
  }
}

rain_vector = head(rain_vector, N)
rain_vector = data.frame(behavior = as.character(rain_vector))
write.csv(rain_vector, "Simulated_behavior_real_diff")


acf(rain_vector, main = "ACF of Sequential Sampling of Exponential Distributions")
periodogram(rain_vector,log='no',plot=TRUE,ylab="Power", xlab="Frequency",lwd=2, main = "Preriodogram of Sequential Sampling")
hist(R_vector, main = "Distribution of Rainfall Durations of Sequential Sampling", xlab = "Duration", breaks = 30)
hist(T_vector,  main = "Distribution of Drought Durations of Sequential Sampling", xlab = "Duration", breaks = 30)
plot(rain_vector, xlim = c(0,250), pch = 19, main = "Time Series of Rainfall of Sequential Sampling", ylab = "O = Drought, 1 = Rain", xlab = "Time Steps")

#same as 2 sections above, but drawing from truncated exp distribution. restricting x axis gives more predicable outcomes 

N = 10000
T = 10
R = 5 
P = .9999 #predictablity, 0 = unpredictable, 1 = predictable 

lambda_r = 1/R
lambda_t = 1/T #range of lambda: 1/N <= lambda <= 1

sigma_max_t = N - (P*(N-(1/lambda_t)))
sigma_max_r = N - (P*(N-(1/lambda_r)))

sigma_min_t = 1 + P*((1/lambda_t) - 1)
sigma_min_r = 1 + P*((1/lambda_r) - 1)

T_vector = c()
R_vector = c()

i = 1
sum = 0

while (sum < N) {
  T_vector[i] = round(rexptr(n = 1, lambda = lambda_t, range = c(sigma_min_t, sigma_max_t))) 
  R_vector[i] = round(rexptr(n = 1, lambda = lambda_r, range = c(sigma_min_r, sigma_max_r))) 
  sum = sum(T_vector, R_vector)
  i = i+1
}

combined_vector = as.vector(rbind(T_vector, R_vector))

rain_vector = c()
zeros_vector = c()
ones_vector = c()

for(i in 1:length(combined_vector)){
  if((i %% 2) == 1){
    zeros_vector = rep(0, combined_vector[i])
    rain_vector = c(rain_vector, zeros_vector)
    zeros_vector = c()
  } else {
    ones_vector = rep(1, combined_vector[i])
    rain_vector = c(rain_vector, ones_vector)
    ones_vector = c()
  }
}

rain_vector = head(rain_vector, N)

#hist(T_vector)
#hist(R_vector)
#periodogram(rain_vector,log='no',plot=TRUE,ylab="Power", xlab="Frequency",lwd=2, ylim = c(0, 30))
#pacf(rain_vector, lag = length(rain_vector)-1)
thing = acf(rain_vector, lag = 50)
x = 

#plot(rain_vector, xlim = c(0,250), pch = 19)

#same as above, but iterating over P
N = 10000
T = 10
R = 5
number_of_ps = 4 
lambda_r = 1/R
lambda_t = 1/T #range of lambda: 1/N <= lambda <= 1
rain_matrix = matrix(data = 0, ncol = number_of_ps+1, nrow = N)

for(j in 0:number_of_ps+1){

P =  (j-1)*1/number_of_ps
print(P)

sigma_max_t = N - (P*(N-(1/lambda_t)))
sigma_max_r = N - (P*(N-(1/lambda_r)))

sigma_min_t = 1 + P*((1/lambda_t) - 1)
sigma_min_r = 1 + P*((1/lambda_r) - 1)

T_vector = c()
R_vector = c()

i = 1
sum = 0

while (sum < N) {
  T_vector[i] = round(rexptr(n = 1, lambda = lambda_t, range = c(sigma_min_t, sigma_max_t))) 
  R_vector[i] = round(rexptr(n = 1, lambda = lambda_r, range = c(sigma_min_r, sigma_max_r))) 
  sum = sum(T_vector, R_vector)
  i = i+1
}

combined_vector = as.vector(rbind(T_vector, R_vector))

rain_vector = c()
zeros_vector = c()
ones_vector = c()

for(i in 1:length(combined_vector)){
  if((i %% 2) == 1){
    zeros_vector = rep(0, combined_vector[i])
    rain_vector = c(rain_vector, zeros_vector)
    zeros_vector = c()
  } else {
    ones_vector = rep(1, combined_vector[i])
    rain_vector = c(rain_vector, ones_vector)
    ones_vector = c()
  }
}

rain_vector = head(rain_vector, N)

rain_matrix[, j] = rain_vector



if(P == 0){
  hist(combined_vector, xlab = "Rainfall or Drought Duration")
} 
if(P == 1){
  hist(combined_vector, xlab = "Rainfall or Drought Duration")
} 

}

rain_data = data.frame(rain_matrix)
rain_data$time = 1:N

zero = ggplot(rain_data, aes(x = time, y = X1)) + geom_point(size = 2) + theme_bw() + xlim(0, 250) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("") + ggtitle("P = 0") + theme(plot.title = element_text(face = "bold"))
two = ggplot(rain_data, aes(x = time, y = X2)) + geom_point(size = 2) + theme_bw() + xlim(0, 250) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")+ ggtitle("P = 0.25")+ theme(plot.title = element_text(face = "bold"))
four = ggplot(rain_data, aes(x = time, y = X3)) + geom_point(size = 2) + theme_bw() + xlim(0, 250) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")+ ggtitle("P = 0.5")+ theme(plot.title = element_text(face = "bold"))
six = ggplot(rain_data, aes(x = time, y = X4)) + geom_point(size = 2) + theme_bw() + xlim(0, 250) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")+ ggtitle("P = 0.75")+ theme(plot.title = element_text(face = "bold"))
eight = ggplot(rain_data, aes(x = time, y = X5)) + geom_point(size = 2) + theme_bw() + xlim(0, 250)+ theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("Time") + ylab("")+ ggtitle("P = 1")+ theme(plot.title = element_text(face = "bold"))


ggarrange(zero, two, four, six, eight, 
          ncol = 1, nrow = number_of_ps + 1)

#same graph as above, but for poster

zero = ggplot(rain_data, aes(x = time, y = X1)) + geom_point(size = 2) + theme_bw() + xlim(0, 100) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")+ theme(plot.title = element_text(face = "bold"))
two = ggplot(rain_data, aes(x = time, y = X2)) + geom_point(size = 2) + theme_bw() + xlim(0, 100) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")+ theme(plot.title = element_text(face = "bold"))
four = ggplot(rain_data, aes(x = time, y = X3)) + geom_point(size = 2) + theme_bw() + xlim(0, 100) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")+ theme(plot.title = element_text(face = "bold"))
six = ggplot(rain_data, aes(x = time, y = X4)) + geom_point(size = 2) + theme_bw() + xlim(0, 100) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")+ theme(plot.title = element_text(face = "bold"))
eight = ggplot(rain_data, aes(x = time, y = X5)) + geom_point(size = 2) + theme_bw() + xlim(0, 100)+ theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("Time") + ylab("")+ theme(plot.title = element_text(face = "bold"))


ggarrange(zero, two, four, six, eight, 
          ncol = 1, nrow = number_of_ps + 1)

#same as above, but with magnitude also controlled by P

N = 10000
T = 10
R = 5
average_magnitude = 10
upper_magnitude = 100
lower_magnitude = 0
number_of_ps = 4 
lambda_r = 1/R
lambda_t = 1/T #range of lambda: 1/N <= lambda <= 1
lambda_m = 1/average_magnitude
rain_matrix = matrix(data = 0, ncol = number_of_ps+1, nrow = N)
magnitude_matrix = matrix(data = 0, ncol = number_of_ps+1, nrow = N)

for(j in 0:number_of_ps+1){
  
  P =  (j-1)*1/number_of_ps
  print(P)
  
  sigma_max_t = N - (P*(N-(1/lambda_t)))
  sigma_max_r = N - (P*(N-(1/lambda_r)))
  sigma_max_m = upper_magnitude - (P*(upper_magnitude-(1/lambda_m)))
  
  sigma_min_t = 1 + P*((1/lambda_t) - 1)
  sigma_min_r = 1 + P*((1/lambda_r) - 1)
  sigma_min_m = lower_magnitude + P*((1/lambda_m) - lower_magnitude)
  
  T_vector = c()
  R_vector = c()
  
  i = 1
  sum = 0
  
  while (sum < N) {
    T_vector[i] = round(rexptr(n = 1, lambda = lambda_t, range = c(sigma_min_t, sigma_max_t))) 
    R_vector[i] = round(rexptr(n = 1, lambda = lambda_r, range = c(sigma_min_r, sigma_max_r))) 
    sum = sum(T_vector, R_vector)
    i = i+1
  }
  
  combined_vector = as.vector(rbind(T_vector, R_vector))
  
  rain_vector = c()
  zeros_vector = c()
  ones_vector = c()
  magnitude_vector = c()
  
  for(i in 1:length(combined_vector)){
    if((i %% 2) == 1){
      zeros_vector = rep(0, combined_vector[i])
      rain_vector = c(rain_vector, zeros_vector)
      zeros_vector = c()
    } else {
      ones_vector = rep(1, combined_vector[i])
      rain_vector = c(rain_vector, ones_vector)
      ones_vector = c()
    }
  }
  
  rain_vector = head(rain_vector, N)
  
  for(i in 1:length(rain_vector)){
    if(rain_vector[i] == 0){
      magnitude_vector[i] = 0
     } else {
      magnitude_vector[i] = rexptr(n = 1, lambda = lambda_m, range = c(sigma_min_m, sigma_max_m))
     }
  }
  
  rain_matrix[, j] = rain_vector
  magnitude_matrix[, j] = magnitude_vector
  
}

rain_data = data.frame(rain_matrix, magnitude_matrix)
rain_data$time = 1:N

myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")))
sc <- scale_colour_gradientn(colours = myPalette(100), limits=c(lower_magnitude, upper_magnitude), guide = "none")

zero = ggplot(rain_data, aes(x = time, y = X1, color = X1.1)) + geom_point(size = 2) + theme_bw() + xlim(0, 250) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("") + ggtitle("P = 0") + theme(plot.title = element_text(face = "bold")) + sc
two = ggplot(rain_data, aes(x = time, y = X2, color = X2.1)) + geom_point(size = 2) + theme_bw() + xlim(0, 250) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")+ ggtitle("P = 0.25")+ theme(plot.title = element_text(face = "bold"))+ sc 
four = ggplot(rain_data, aes(x = time, y = X3, color = X3.1)) + geom_point(size = 2) + theme_bw() + xlim(0, 250) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")+ ggtitle("P = 0.5")+ theme(plot.title = element_text(face = "bold")) + sc 
six = ggplot(rain_data, aes(x = time, y = X4, color = X4.1)) + geom_point(size = 2) + theme_bw() + xlim(0, 250) + theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")+ ggtitle("P = 0.75")+ theme(plot.title = element_text(face = "bold"))+ sc 
eight = ggplot(rain_data, aes(x = time, y = X5, color = X5.1)) + geom_point(size = 2) + theme_bw() + xlim(0, 250)+ theme(axis.ticks.y=element_blank(), axis.text.y = element_blank()) + xlab("Time") + ylab("")+ ggtitle("P = 1")+ theme(plot.title = element_text(face = "bold"))+ sc 


ggarrange(zero, two, four, six, eight, 
          ncol = 1, nrow = number_of_ps + 1)


#make sure different values of P don't result in more or less rain 

N = 25000
simulations = 1000

total_rain = c()
t_parameter = c()
r_parameter = c()
p_parameter = c()

for(j in 1:simulations){
  
  P = runif(1,0,1)
  T = runif(1,1,250)
  R = runif(1,1,250)
  lambda_r = 1/R
  lambda_t = 1/T 
  
  t_parameter[j] = T
  r_parameter[j] = R
  p_parameter[j] = P
  
  sigma_max_t = N - (P*(N-(1/lambda_t)))
  sigma_max_r = N - (P*(N-(1/lambda_r)))
  
  sigma_min_t = 1 + P*((1/lambda_t) - 1)
  sigma_min_r = 1 + P*((1/lambda_r) - 1)
  
  T_vector = c()
  R_vector = c()
  
  i = 1
  sum = 0
  
  while (sum < N) {
    T_vector[i] = round(rexptr(n = 1, lambda = lambda_t, range = c(sigma_min_t, sigma_max_t))) 
    R_vector[i] = round(rexptr(n = 1, lambda = lambda_r, range = c(sigma_min_r, sigma_max_r))) 
    sum = sum(T_vector, R_vector)
    i = i+1
  }
  
  combined_vector = as.vector(rbind(T_vector, R_vector))
  
  rain_vector = c()
  zeros_vector = c()
  ones_vector = c()
  
  for(i in 1:length(combined_vector)){
    if((i %% 2) == 1){
      zeros_vector = rep(0, combined_vector[i])
      rain_vector = c(rain_vector, zeros_vector)
      zeros_vector = c()
    } else {
      ones_vector = rep(1, combined_vector[i])
      rain_vector = c(rain_vector, ones_vector)
      ones_vector = c()
    }
  }
  
  rain_vector = head(rain_vector, N)
  
  total_rain[j] = sum(rain_vector)
  
}

data = data.frame(rain = total_rain, t = t_parameter, p =p_parameter, r = r_parameter)
model = glm(rain ~ t+p+r, data = data)
summary(model)

plot(data$p, data$rain, xlab = "P Value", ylab = "Total Rain in Simulation", main = "P has no Effect on Rainfall", pch = 19)

model = glm(total_rain ~ x_vector)
summary(model)

yweight <- predict(model, list(wt = x_vector),type="response")

lines(x_vector, yweight, col = "red", lwd = 2)

plot(x_vector, total_rain, xlab = "P Value", ylab = "Total Rain in Simulation", main = "P Has No Rainfall", ylim = c(0, N), pch = 19)
lines(x_vector, yweight, col = "red", lwd = 2)