# This file is to generate the simulation data according to the parameters
# This is to remove the random effect of time t and add the random effect of confounders
# -> change m_bt01i = 0 and v_bt01i = 1 -> m_bt12i = 1 and v_bt12i = 1

Gen_Data <- function(seed = 1234, nt = 40, n_t = 24, n_r = 24, n_T = 5, #timeline for collecting data
                     m_Z1 = 1, v_Z1 = 1, m_Z2 = 1, v_Z2 = 1, # structure of counfounders
                     b11.0 = 3, b11.1 = 0, g11.0 = 1, g11.1 = 0, #time varying effects of G on X and X on Y
                     b01 = 1, b02 = 1, v_b01i = 1, v_b02i = 1, #fix and random intercept
                     m_bt01i = 1, v_bt01i = 1, m_g01i = 1, v_g01i = 1, #fix and random effect of time t
                     m_bt12i = 1, v_bt12i = 1, m_g12i = 1, v_g12i = 1, #fix and random effect of observed confounders
                     m_bt13i = 1, v_bt13i = 1, m_g13i = 1, v_g13i = 1, #fix and random effect of unobserved confounders
                     ti = 1,...){

  # Parameters
  # seed = 1234
  # nt = 40
  # n_t = 24
  # n_r = 24
  # n_T = 5
  # b11.0 = 3
  # b11.1 = 3
  # g11.0 = 1
  # g11.1 = 0
  # b12 = 0.1
  # r12 = 0.1
  # m_bt12i = 0
  # m_g01i = 0
  # v_b01i = 1
  # v_bt12i = 1
  # v_b02i = 1
  # v_g01i = 1
  #

  set.seed(seed)

  #Aussme data are collected in the n_t months then rest n_r months
  #number of observations/individuals observed in each month is nt
  #number of months in each measument section is n_t
  #number of sections for collecting data is n_T/follow-up years
  #The total enrolled people will be:
  n = nt*n_t

  ########################## Get the measurement time ################################
  # n_T: follow-up years, n_t number of meaurement, t is the measurement time
  addf <- function(x){return(x*(n_t+n_r) + seq(n_t))}
  t <- as.vector(sapply(seq(n_T), FUN = function(x) addf(x-1)))
  t_vec <- rep(t, each = nt)
  t_vec <- t_vec #does not transfer the unit of months as years
  t_mt <- matrix(t_vec, n, n_T)


  T_vec_one <- (seq(n_T) - 1)*(n_t + n_r) + 1/2*n_t
  T_vec <- rep(T_vec_one, each = n)
  T_vec <- T_vec #does not transfer the unit of months as years
  T_mt <- matrix(T_vec, n, n_T)

  ########################## Get the Age information of All individuals#############################
  ########################## For current version, we do not include the age in the data generting process ####
  # # Age range of all enrolled individuals at the baseline
  # Age_min <- 18
  # Age_max <- 60
  #
  # #Age with gamma distribution
  # Num <- rgamma(5000, 1, scale = 30)
  # #Age with uniform distribution
  # #Num <- round(runif(5000, 18, 60))
  # Age_pop <- floor(Num[which(Num <= Age_max & Num >= Age_min)])
  # Age <-  sample(Age_pop, n, replace = T)
  #
  # #Age with uniform distribution
  # #Age <- sample(seq(Age_min,Age_max), n, replace = T)
  #
  # #Age of every follow-up years
  # Age_vec <- rep(Age, n_T) + t_vec
  # Age_mt <- matrix(Age_vec, n, n_T)
  #
  # #baseline Age
  # Ageb_vec <- rep(Age, n_T)
  # Ageb_mt <- matrix(Ageb_vec, n, n_T)


  ############ Get the X1, genetics information for every one and B1 information for every time########
  p1 <- 0.3
  X1 <- rbinom(n, 2, p1)
  #X1 <- rnorm(n, 1, 1)
  X1_vec <- rep(X1,n_T)
  X1_mt <- matrix(X1_vec,n,n_T)

  #Adjust bt12 and g12, observed confounders
  Z1 <- rnorm(n, m_Z1, v_Z1)
  #Z1 <- rep(0,n)
  Z1_vec <- rep(Z1,n_T)
  Z1_mt <- matrix(Z1_vec,n,n_T)

  #unobserved confounfers
  Z2 <- rnorm(n, m_Z2, v_Z2)
  #Z2 <- rep(0,n)
  Z2_vec <- rep(Z2,n_T)
  Z2_mt <- matrix(Z2_vec,n,n_T)

  ########### Get the parameter ##############
  #b01 <- rep(1, n*n_T)
  b01i <- rep(rnorm(n, b01, v_b01i),n_T)
  bt01i <- rep(rnorm(n, m_bt01i, v_bt01i), n_T)
  bt12i <- rep(rnorm(n, m_bt12i, v_bt12i), n_T) #effect of observed confounder Z1 on Y1
  bt13i <- rep(rnorm(n, m_bt13i, v_bt13i), n_T) #effect of unobserved confounder Z2 on Y1 with same parameter as Z1
  e1 <- rnorm(n*n_T)


  #b02 <- rep(1, n*n_T)
  b02i <- rep(rnorm(n, b02, v_b02i),n_T)
  g01i <- rep(rnorm(n, m_g01i, v_g01i), n_T)
  g12i <- rep(rnorm(n, m_g12i, v_g12i), n_T) # effect of observed confounder Z1 on Y2
  g13i <- rep(rnorm(n, m_g13i, v_g13i), n_T) # effect of observed confounder Z2 on Y2 with same parameter as Z1
  e2 <- rnorm(n*n_T)
  #e2 <- rep(0, n*n_t)


  ####Change with time t#########
  bt11 <- sapply(t_vec, FUN = function(t) b11_t(t, b11.0 = b11.0, b11.1 = b11.1))
  g11 <- sapply(t_vec, FUN = function(t) g11_t(t, g11.0 = g11.0, g11.1 = g11.1))


  Y1_mt <- matrix((b01 + b01i + bt01i*t_vec + bt11*X1_vec + bt12i*Z1 + bt13i*Z2 + e1),n,n_T)
  Y2_mt <- matrix((b02 + b02i + g01i*t_vec + g11*as.vector(Y1_mt) + g12i*Z1 + g13i*Z2 + e2),n,n_T)


  Dat.L <- list(t = t_mt/12*ti, Tt = T_mt/12*ti, X1 = X1_mt, Y1 = Y1_mt, Y2 = Y2_mt, Z1 = Z1_mt, Z2 = Z2_mt)
  return(Dat.L)
}


#Example
#Gen_Data()
