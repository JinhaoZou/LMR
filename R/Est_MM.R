# This is a function to estimate the dataset using MM method

#Input: dataset with all variables
#Output: the point estimation for the five middle point of the estimation at five points and the estimated intercept and slope
Est_MM <- function(dat, Time = (seq(5)*4-3)*12,...){

  #dat <- Gen_Data(1, g11.1 = 1)
  n <- dim(dat$t)[1]
  n_t <- dim(dat$t)[2]

  my_df <- data.frame(ID = rep(seq(n), each = n_t), t = as.vector(t(dat$t)),
                      X1 = as.vector(t(dat$X1)), Y1 = as.vector(t(dat$Y1)), Y2 = as.vector(t(dat$Y2)),
                      Z1 = as.vector(t(dat$Z1)), t2 = as.vector(t(dat$t))^2, Z1t = as.vector(t(dat$Z1))*as.vector(t(dat$t)) )


  fit.Y1 <- as.data.frame(t(summary(lme(fixed = Y1 ~ 1 + t + X1 + Z1, random = ~ 1|ID + t|ID,  data = my_df, control = lmeControl(opt = "optim") ))$tTable))
  beta11.est <- fit.Y1$X1[1]
  beta11.sd <- fit.Y1$X1[2]

  #Change with time
  fit.Y2 <- as.data.frame(t(summary(lme(fixed = Y2 ~ 1 + t + t2 + X1 + X1:t + Z1 + Z1:t, random = ~ 1|ID + t|ID + t2|ID ,  data =my_df, control = lmeControl(opt = "optim")))$tTable))
  ab11.est <- fit.Y2$X1[1]
  ab11.sd <- fit.Y2$X1[2]

  #Change with time
  bb11.est <- fit.Y2$`t:X1`[1]
  bb11.sd <-  fit.Y2$`t:X1`[2]

  Est_r11.0 <- c(0, EstCI_ratio(ab11.est, beta11.est, ab11.sd, beta11.sd))
  Est_r11.1 <- c(0, EstCI_ratio(bb11.est, beta11.est, bb11.sd, beta11.sd))

  #Output the estimated intercept and slope
  result1 <- cbind(Est_r11.0, Est_r11.1)
  rownames(result1) <- c("Notime","est","sd")

  #output five estimations from 5 time points c(1, 5, 9, 13, 17)
  result2 <- rbind(Time, (Est_r11.0[2] + Est_r11.1[2]*Time), sqrt(Est_r11.0[3]^2 + Est_r11.1[3]^2*Time^2))

  return(c(result1[2,], result2[2,]))
}

# example
# dat <- Gen_Data(1)
# Est_MM(dat)
