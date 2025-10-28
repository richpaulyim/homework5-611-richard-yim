library(cluster)
library(tidyverse)

# generate hypercube clusters function
generate_hypercube_clusters <- function(n, k, side_length, noise_sd = 1.0) {
  return(
    matrix(
      rep(diag(n),k)*side_length, nrow=n*k, 
      byrow = TRUE)+rnorm(
        n = n**2*k,mean = 0,sd = noise_sd
        )
    )
}

# run simulation loops
sim_dat <- numeric(5*10)
i <- 1
for(dimensions in 6:2) {
  for(side_lengths in 10:1) {
    print(paste("Running",dimensions,side_lengths)) 
    # generate temp dataset
    sim_matrix <- generate_hypercube_clusters(
      n=dimensions, 
      k=100, 
      side_length = side_lengths
      )
    
    # kmeans 
    clusgapkmns <- clusGap(sim_matrix, FUNcluster = kmeans, 
                           K.max = 10,  nstart = 20,  iter.max=50
                           )
    sim_dat[i] <- maxSE(clusgapkmns$Tab[, "gap"], 
                             clusgapkmns$Tab[, "SE.sim"], 
                             method = "firstSEmax")
    
    # update index
    i <- i + 1
  }
}

tibble(
  dimensions = rep(6:2, each = 10),
  side_length = rep(10:1, times = 5),
  optimal_k = sim_dat
) %>% write_csv("task1/task1_data.csv")