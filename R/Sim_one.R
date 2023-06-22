# This function is to Simulate one data set and use the bootstrap for confidence interval estimations
Sim_one <- function(seed, n.bt = 1000, type = "perc", ti = 1, n.MM.est = 5,
                    g11.0 = 1, g11.1 = 0,
                    m_Z1 = 1, v_Z1 = 1, m_Z2 = 1, v_Z2 = 1,
                    m_bt01i = 1, v_bt01i = 1, m_g01i = 1, v_g01i = 1, #fix and random effect of time t
                    m_bt12i = 1, v_bt12i = 1, m_g12i = 1, v_g12i = 1, #fix and random effect of observed confounders
                    m_bt13i = 1, v_bt13i = 1, m_g13i = 1, v_g13i = 1, #fix and random effect of unobserved confounders
                    ...){

  # seed = 1
  # n.bt = 5
  # type = "perc"
  # ti = 1
  # n.MM.est = 5
  # g11.0 = 1
  # g11.1 = 0
  # m_bt01i = 0
  # m_g01i = 0
  # v_bt01i = 1
  # v_g01i = 1

  #n.bt is number of bootstrap for estimations
  #If we use the bca method for calculating the CI, the n.bt should >= the number of individuals
  print(seed) #the seed of generating a dataset
  dat <- Gen_Data(seed, ti = ti,
                  g11.0 = g11.0, g11.1 = g11.1,
                  m_Z1 = m_Z1, v_Z1 = v_Z1, m_Z2 = m_Z2, v_Z2 = v_Z2,
                  m_bt01i = m_bt01i, v_bt01i = v_bt01i, m_g01i = m_g01i, v_g01i = v_g01i,
                  m_bt12i = m_bt12i, v_bt12i = v_bt12i, m_g12i = m_g12i, v_g12i = v_g12i,
                  m_bt13i = m_bt13i, v_bt13i = v_bt13i, m_g13i = m_g13i, v_g13i = v_g13i)

  dat.vec <- cbind(dat$t, dat$Tt, dat$X1, dat$Y1, dat$Y2, dat$Z1, dat$Z2)

  #est <- sapply(seq(n.bt), function(x) Est.bt(dat, x))
  #est.noNA <- est[, colSums(is.na(est)) == 0]
  #print(dim(est.noNA)) #the estimation for
  #result <- apply(est.noNA, 1, function(x) c(mean(x),  quantile(x, c(0.025, 0.975))))

  est.bt <- boot(data = dat.vec, statistic =  Est_bt, R = n.bt, ti = ti, n.MM.est = n.MM.est) #bootstrap for estimations
  if(type == "bca"){
    est.bt.ci <- sapply(seq(length(est.bt$t0)), function(i) boot.ci(est.bt, type = "bca", index = i)$bca) #Get the CI with bca method
  }else{
    est.bt.ci <- sapply(seq(length(est.bt$t0)), function(i) boot.ci(est.bt, type = "perc", index = i)$percent) #Get the CI
  }

  #est.bt.t.NoNA <- est.bt$t[rowSums(is.na(est.bt$t)) == 0, ] #remove the missing estimations
  est.bt.all <- rbind(colMeans(est.bt$t, na.rm = T), est.bt.ci[-1:-3,]) #combine the estimation mean and CI
  #est.bt.all will be matrix 3*(4*(n.MM.est+2) + 5), 3 is the mean and 95% CI, 4*(n.MM.est+2)+5 means the estimations from different time points
  return(as.vector(est.bt.all))
}

# Sim_one(1, n.bt=5)
# It is normal to see the output with warning if you put n.bt as very small values
