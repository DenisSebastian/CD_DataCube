
# PCAK --------------------------------------------------------------------
# La función pca_k_means realiza un análisis de componentes principales (PCA) 
# seguido de un algoritmo de k-means para generar un mapa de cambios basado 
# en una imagen de diferencia. 


# Generación de Bloques ---------------------------------------------------

gene_block <- function(img, block_sz = 4, gene_block_vec = TRUE) {
  vectors <- list()
  
  if (gene_block_vec) {
    # generate xd(y, x)
    n_y <- floor(dim(img)[1] / block_sz)
    n_x <- floor(dim(img)[2] / block_sz)
    
    for (y in 1:n_y) {
      for (x in 1:n_x) {
        vert_start <- (y - 1) * block_sz + 1
        vert_end <- y * block_sz
        horiz_start <- (x - 1) * block_sz + 1
        horiz_end <- x * block_sz
        vec <- as.vector(img[vert_start:vert_end, horiz_start:horiz_end])
        vectors[[length(vectors) + 1]] <- vec
      }
    }
  } else {
    # generate xd(i, j)
    
    left_pad <- ceiling(block_sz / 2) - 1
    right_pad <- block_sz - ceiling(block_sz / 2)
    up_pad <- ceiling(block_sz / 2) - 1
    down_pad <- block_sz - ceiling(block_sz / 2)
    pad <- matrix(c(up_pad, down_pad, left_pad, right_pad), nrow = 2)
    pad_img <- zero_pad(img, pad)  # pad image because the margin of image also need block vector
    
    n_y <- dim(img)[1]
    n_x <- dim(img)[2]
    
    for (y in (up_pad + 1):(up_pad + n_y)) {
      for (x in (left_pad + 1):(left_pad + n_x)) {
        vert_start <- y - ceiling(block_sz / 2) + 1
        vert_end <- y + block_sz - ceiling(block_sz / 2)
        horiz_start <- x - ceiling(block_sz / 2) + 1
        horiz_end <- x + block_sz - ceiling(block_sz / 2)
        vec <- as.vector(pad_img[vert_start:vert_end, horiz_start:horiz_end])
        vectors[[length(vectors) + 1]] <- vec
      }
    }
  }
  
  return(do.call(rbind, vectors))
}





# Kmenas ------------------------------------------------------------------


k_means_cluster <- function(vectors, cluster_num) {
  # tic <- Sys.time()
  vec_dim <- dim(vectors)[1]
  vec_n <- dim(vectors)[2]
  
  vec_class <- rep(0, vec_n)
  
  # randomly select vectors as initial cluster center
  cluster_center <- matrix(0, nrow = vec_dim, ncol = cluster_num)
  for (i in 1:cluster_num) {
    init_id <- sample(1:vec_n, 1)
    cluster_center[, i] <- vectors[, init_id]
  }
  
  cluster_changed <- TRUE
  iter_count <- 0
  
  while (cluster_changed) {
    cluster_changed <- FALSE
    iter_count <- iter_count + 1
    
    # assign every vectors' class according to their distance with center
    for (i in 1:vec_n) {
      temp_dist <- sqrt(rowSums((vectors[, i, drop = FALSE] - cluster_center)^2))
      min_index <- which.min(temp_dist)
      
      if (vec_class[i] != min_index) {
        cluster_changed <- TRUE
        vec_class[i] <- min_index
      }
    }
    
    # calculate center co-ordinates based on assignment results
    for (i in 1:cluster_num) {
      cluster_center[, i] <- colMeans(vectors[, vec_class == i])
    }
  }
  
  toc <- Sys.time()
  iter_count_msg <- paste("K-means has been completed, the total iter count is", iter_count,
                          "and cost time is", difftime(toc, tic, units = "secs"), "s")
  cat(iter_count_msg, "\n")
  
  return(cluster_center)
}




# Generar Mapa de Cambios -------------------------------------------------

# La función gene_change_map en Python genera un mapa de cambios a partir 
# de una imagen de diferencia, vectores de características y centros de clúster 
# generados por el algoritmo de k-means.


gene_change_map <- function(image_diff, feature_vectors, cluster_center) {
  img_height <- dim(image_diff)[1]
  img_width <- dim(image_diff)[2]
  
  f_dis <- apply(feature_vectors, 2, function(vec) norm(vec - cluster_center[, 1]))
  s_dis <- apply(feature_vectors, 2, function(vec) norm(vec - cluster_center[, 2]))
  
  f_mask <- f_dis < s_dis
  f_mask <- matrix(f_mask, nrow = img_height, ncol = img_width)
  
  f_mean <- mean(image_diff[f_mask])
  s_mean <- mean(image_diff[!f_mask])
  
  if (f_mean > s_mean) {
    image_diff[f_mask] <- 255
    image_diff[!f_mask] <- 0
  } else {
    image_diff[f_mask] <- 0
    image_diff[!f_mask] <- 255
  }
  
  return(image_diff)
}



# PCA K-Means -------------------------------------------------------------

library(matrixStats)
library(stats)

pca_k_means <- function(img_diff, block_size = 4, eig_space_dim = 3) {
  # Generate block vector
  block_vectors <- t(gene_block(img_diff, block_sz = block_size, gene_block_vec = TRUE))
  n_vec <- ncol(block_vectors)
  
  avg_vec <- colMeans(block_vectors)  # The average vector of the set
  vec_diff <- sweep(block_vectors, 2, avg_vec, "-")
  cov_mat <- crossprod(vec_diff) / n_vec  # The covariance matrix
  
  eig_val <- eigen(cov_mat)$values  # Eigenvalues of the covariance matrix
  eig_vec <- eigen(cov_mat)$vectors  # Eigenvectors of the covariance matrix
  
  # Select S eigenvectors for generating vector space
  eig_space <- eig_vec[, 1:eig_space_dim]  # Shape: (H * H, S)
  
  # Generate block for every pixel
  block_img <- t(gene_block(img_diff, block_sz = block_size, gene_block_vec = FALSE))
  
  # The feature vector at spatial location (i, j)
  feature_vec <- crossprod(eig_space, (block_img - avg_vec))  # Shape: (S, height * width)
  
  # Generate two cluster centers using K-means
  cluster_center <- kmeans(feature_vec, centers = 2)$centers  # Shape: (S, 2)
  
  # Generate change map
  change_map <- gene_change_map(img_diff, feature_vec, cluster_center)
  
  return(change_map)
}

