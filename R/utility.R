#t is the time of measurement, unit as year
#age is age of patient being measured

#Effect of X1 on Y1
b11_t <- function(t, b11.0 = 3, b11.1 = 0){
  return(b11.0 + b11.1*t)
}

#Effect of Y1 on Y2
g11_t <- function(t, g11.0 = 1, g11.1 = 0){
  return(g11.0 + g11.1*t)
}


EstCI_ratio <- function(X.m, Y.m, X.sd, Y.sd){
  est <- X.m/Y.m
  sd <- sqrt((Y.m^2*X.sd^2 + X.m^2*Y.sd^2)/Y.m^4)
  #return(c(est, est+1.96*sd, est-1.96*sd, sd))
  return(c(est, sd))
}
