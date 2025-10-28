
generate_shell_clusters <- function(n_shells, k_per_shell, max_radius, noise_sd = 0.1) {
  
  # Calculate radii for each shell (evenly spaced from small inner radius to max_radius)
  min_radius <- max_radius / (2*n_shells)
  radii <- seq(min_radius, max_radius, length.out = n_shells)
  
  X <- matrix(nrow = 0, ncol = 3)
  labels <- c()
  
  for (shell_idx in 1:n_shells) {
    radius <- radii[shell_idx]
    extra <- radius^2
    kk_per_shell <- ceiling(extra*k_per_shell)
    if(radius==0){
      kk_per_shell <- k_per_shell
    }
    
    # Generate k_per_shell points uniformly on a sphere using spherical coordinates
    # Use random sampling that's uniform on the sphere surface
    phi <- runif(kk_per_shell, 0, 2 * pi)  
    cos_theta <- runif(kk_per_shell, -1, 1)  
    theta <- acos(cos_theta)
    
    # Add Gaussian noise to the radius
    noisy_radius <- radius + rnorm(kk_per_shell, mean = 0, sd = noise_sd)
    
    # Convert spherical to Cartesian coordinates
    x <- noisy_radius * sin(theta) * cos(phi)
    y <- noisy_radius * sin(theta) * sin(phi)
    z <- noisy_radius * cos(theta)
    
    shell_points <- cbind(x, y, z)
    X <- rbind(X, shell_points)
    labels <- c(labels, rep(shell_idx, kk_per_shell))
  }
  
  colnames(X) <- c("X", "Y", "Z")
  
  return(list(X = X, labels = labels))
}

library(tidyverse)

spectral_clustering <- function(x, k, d_threshold=1) {
  
  # Ensure x is a matrix
  x <- as.matrix(x)
  n <- nrow(x)
  
  # Compute pairwise Euclidean distances
  dist_matrix <- as.matrix(dist(x, method = "euclidean"))
  
  # Create adjacency matrix: A_ij = 1 if distance < d_threshold, else 0
  A <- (dist_matrix < d_threshold) * 1
  diag(A) <- 0  # No self-loops
  
  # Compute Degree Matrix D and symmetric normalized Laplacian
  D <- diag(rowSums(A))
  D_inv_sqrt <- diag(1 / sqrt(diag(D) + 1e-15))  # Avoid division by zero
  
  # Symmetric normalized Laplacian: L_sym = I - D^(-1/2) * A * D^(-1/2)
  L_sym <- diag(n) - D_inv_sqrt %*% A %*% D_inv_sqrt
  
  # Eigen-decomposition
  eigen_result <- eigen(L_sym, symmetric = TRUE)
  
  # Sort eigenvalues in ascending order and get corresponding eigenvectors
  sorted_indices <- order(eigen_result$values)
  eigenvectors <- eigen_result$vectors[, sorted_indices[1:k], drop = FALSE]
  
  # Normalize rows of eigenvector matrix
  row_norms <- sqrt(rowSums(eigenvectors^2))
  eigenvectors_normalized <- eigenvectors / (row_norms + 1e-15)  # Avoid division by zero
  
  # Cluster the normalized eigenvectors using K-means
  kmeans_result <- kmeans(eigenvectors_normalized, centers = k, nstart = 25)
  
  # Return cluster assignments
  return(kmeans_result)
}
