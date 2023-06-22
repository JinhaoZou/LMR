# This function is to generate one simulation from
# type is the function of calculate the CI method including: c("norm","basic", "stud", "perc", "bca") or simply "all"

Sim_all <- function(n.sim.start, n.sim.end,
                    n.bt = 5, type = "perc", ti = 1, n.MM.est = 5,
                    g11.0 = 1, g11.1 = 0,
                    m_Z1 = 1, v_Z1 = 1, m_Z2 = 1, v_Z2 = 1,
                    m_bt01i = 1, v_bt01i = 1, m_g01i = 1, v_g01i = 1, #fix and random effect of time t
                    m_bt12i = 1, v_bt12i = 1, m_g12i = 1, v_g12i = 1, #fix and random effect of observed confounders
                    m_bt13i = 1, v_bt13i = 1, m_g13i = 1, v_g13i = 1 #fix and random effect of unobserved confounders
                    ,...){

  temp <- sapply(seq(n.sim.start, n.sim.end), function(x) Sim_one(x, n.bt = n.bt, type = type, ti = ti, n.MM.est = n.MM.est,
                                                                  g11.0 = g11.0, g11.1 = g11.1,
                                                                  m_Z1 = m_Z1, v_Z1 = v_Z1, m_Z2 = m_Z2, v_Z2 = v_Z2,
                                                                  m_bt01i = m_bt01i, v_bt01i = v_bt01i, m_g01i = m_g01i, v_g01i = v_g01i,
                                                                  m_bt12i = m_bt12i, v_bt12i = v_bt12i, m_g12i = m_g12i, v_g12i = v_g12i,
                                                                  m_bt13i = m_bt13i, v_bt13i = v_bt13i, m_g13i = m_g13i, v_g13i = v_g13i))
  # result.all <- matrix(rowMeans(temp), 3)
  # n.MR <- 5
  # n.MM <- (ncol(result.all) - n.MR)/4
  # result <- list(Est.MM.12 = result.all[,1:n.MM], Est.MM.13 = result.all[,(n.MM+1):(2*n.MM)],
  #                Est.MM.14 = result.all[,(2*n.MM + 1):(3*n.MM)], Est.MM.15 = result.all[,(3*n.MM + 1):(4*n.MM)],
  #                Est.MR = result.all[,(4*n.MM+1):ncol(result.all)])
  #
  # return(result)
  return(temp)
}

#a <- Sim_all(1, 2, n.bt = 100, ti = 1, g11.0 = 0, g11.1 = 0.05)
