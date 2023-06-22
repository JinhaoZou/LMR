# This is to estimate the causal effect using MR method on cross-sectional data sets

# Input: the dataset with all simulated variables
# Output: estimations for the five point estimations
Est_twMR <- function(dat){
  Er12 <- matrix(NA, 2, 5)
  ceff <- matrix(NA, 2, 5)
  for(i in seq(ncol(dat$Tt))){
    #i <- 1
    fit1 <- summary(lm(Y1[,i] ~ X1[,i] + Z1[, i], data = dat, na.action = na.omit))$coefficients
    ceff[1,i] <- fit1[2,1]
    fit2 <- summary(lm(Y2[,i] ~ X1[,i] + Z1[, i], data = dat, na.action = na.omit))$coefficients
    ceff[2,i] <- fit2[2,1]
    Er12[,i] <- EstCI_ratio(fit2[2,1], fit1[2,1], fit2[2,2], fit1[2,2])
  }

  #Result for estimate causal effects at each point
  result1 <- rbind(unique(as.vector(dat$Tt)), Er12)
  rownames(result1) <- c("t", "est", "sd")

  # #Result for estimate time varying causal effects
  # fit <- summary(lm(result1[2, ] ~  result1[1,]))
  # result2 <- rbind(c(0,0),t(fit$coefficients[,1:2]))
  # colnames(result2) <- c("intercept", "slope")
  #
  # result <- cbind(result2, result1)
  # return(round(result, 4))

  #######Return only the estimations and for five scenarios
  return(result1[2,])

}

# dat <- Gen_Data(1)
# Est_twMR(Gen_Data(3))
