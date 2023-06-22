# Estimate using this function to generate result using both MR and MM method

# Using one data set to do the estimation
Est_all <- function(dat, n.MM.est = 5, n.MR = 5, ti = 1,...){

  dat.12 <- list(t = as.matrix(dat$t[,1:2]), Tt = dat$Tt[,1:2], X1 = dat$X1[,1:2], Y1 = dat$Y1[,1:2], Y2 = dat$Y2[,1:2], Z1 = dat$Z1[,1:2])

  dat.13 <- list(t = as.matrix(dat$t[,1:3]), Tt = dat$Tt[,1:3], X1 = dat$X1[,1:3], Y1 = dat$Y1[,1:3], Y2 = dat$Y2[,1:3], Z1 = dat$Z1[,1:3])

  dat.14 <- list(t = as.matrix(dat$t[,1:4]), Tt = dat$Tt[,1:4], X1 = dat$X1[,1:4], Y1 = dat$Y1[,1:4], Y2 = dat$Y2[,1:4], Z1 = dat$Z1[,1:4])

  #Interested time points
  time.all <- sapply(seq(4), function(i) seq(4*i, (4*i+2), length.out = n.MM.est))
  # there will be n.MM.est rows
  time.all <- time.all*ti

  #Estimations
  if(is.na(tryCatch({
    result <- list(Est.MM.12 = Est_MM(dat.12, Time = time.all[,1]),
                   Est.MM.13 = Est_MM(dat.13, Time = time.all[,2]),
                   Est.MM.14 = Est_MM(dat.14, Time = time.all[,3]),
                   Est.MM = Est_MM(dat, Time = time.all[,4]),
                   Est.twMR = Est_twMR(dat))
  }, error = function(cond){return(NA)}))[1])
  {
    #the number of NA for each estimators depends on the output from each variables
    n.MM <- 2 + n.MM.est
    result <- list(Est.MM.12 = rep(NA, n.MM), Est.MM.13 = rep(NA, n.MM), Est.MM.14 = rep(NA, n.MM), Est.MM = rep(NA, n.MM), Est.twMR =  rep(NA, n.MR))
  }
  return(result)
}

#Est_all(Gen_Data(3), n.MM.est = 5)
