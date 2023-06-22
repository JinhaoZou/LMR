# Estimate using all mthods, generate one estimation using one bootstrap sample from one simulated dataset

#estimation for one estimation using one sample from the bootstrap
Est_bt <- function(dat, idx, n.MM.est = 5, ti = 12,...){
  dat.indx.bt <- idx
  dat.bt <- list(t = dat[dat.indx.bt, 1:5], Tt =  dat[dat.indx.bt, 6:10],
                 X1 = dat[dat.indx.bt, 11:15], Y1 = dat[dat.indx.bt, 16:20], Y2 = dat[dat.indx.bt, 21:25],
                 Z1 = dat[dat.indx.bt, 26:30], Z2 = dat[dat.indx.bt, 31:35])

  result <- unlist(Est_all(dat.bt, n.MM.est = n.MM.est, ti = ti))
  return(result)
}

# dat <- Gen_Data(1)
# dat.vec <- cbind(dat$t, dat$Tt, dat$X1, dat$Y1, dat$Y2, dat$Z1, dat$Z2)
# Est_bt(dat.vec, seq(960))
