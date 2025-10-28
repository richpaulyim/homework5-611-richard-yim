source("task2/task2_helpers.R") 
library(tidyverse) 
library(cluster) 

sim_dat <- numeric(11)
i <- 1
for(max_r in 10:0) {
  sim_matrix <- generate_shell_clusters(n_shells = 4, k_per_shell= 10, max_radius = max_r) 
  print(dim(sim_matrix$X))
  
  # spectral clustering gap statistics
  clusgapspectral <- clusGap(sim_matrix$X, FUNcluster = spectral_clustering, 
                         K.max = 5, B=10
  )
  sim_dat[i] <- maxSE(clusgapspectral$Tab[, "gap"], 
                      clusgapspectral$Tab[, "SE.sim"])
  labels <- spectral_clustering(sim_matrix$X, sim_dat[i])$cluster

  # update index
  i <- i + 1
}

tibble(
  optimal_k = sim_dat
) %>% write_csv("task2/task2_data.csv")
