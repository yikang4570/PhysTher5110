library(jpeg)
library(pracma)

# Set the working directory
working_directory <- "C:/Users/kelop/OneDrive/Documents"
setwd(working_directory)

pca_comparison <- function(image_path) {
  # Load the image
  quokka <- readJPEG(image_path)
  
  # Display the original image
  image(quokka, axes = FALSE)
  title("Original Image")
  
  # Convert to grayscale
  quokka_bw <- rgb2gray(quokka)
  
  # Display the grayscale image
  image(quokka_bw, col = gray.colors(256), axes = FALSE)
  title("Grayscale Image")
  
  # Get image dimensions
  M <- nrow(quokka_bw)
  N <- ncol(quokka_bw)
  
  # Subtract mean for each dimension
  data_zero_mean <- quokka_bw - colMeans(quokka_bw)
  
  # Calculate the covariance matrix
  covariance <- (1 / (N - 1)) * (data_zero_mean %*% t(data_zero_mean))
  
  # Find eigenvectors and eigenvalues
  eig_result <- eigen(covariance)
  Vpca <- Re(eig_result$values)  # Take the real part of eigenvalues
  PCpca <- eig_result$vectors
  
  # Sort variances in decreasing order
  rindices <- order(Vpca, decreasing = TRUE)
  Vpca <- Vpca[rindices]
  PCpca <- PCpca[, rindices]
  
  # Project the original dataset
  signals <- t(PCpca) %*% data_zero_mean
  
  # Recreate the original signal
  org_pca1 <- PCpca[, 1] %*% signals[1, ] + colMeans(quokka_bw)
  
  # Normalize pixel values for display
  org_pca_display <- abs(org_pca1) / max(abs(org_pca1))
  
  # Display the reconstructed image using the first PC alone
  image(org_pca_display, col = gray.colors(256), axes = FALSE)
  title("Reconstructed Image using First PC")
  
  # Perform PCA using singular value decomposition (SVD)
  Y <- t(data_zero_mean) / sqrt(N - 1)
  
  # Run SVD
  svd_result <- svd(Y)
  S <- svd_result$d
  PCsvd <- svd_result$u
  
  # Calculate variances
  Vsvd <- S^2
  
  # Project the original dataset
  signals_svd <- t(PCsvd) %*% data_zero_mean
  
  # Recreate the original signal
  org_svd <- PCsvd %*% signals_svd + colMeans(quokka_bw)
  
  # Normalize pixel values for display
  org_svd_display <- abs(org_svd) / max(abs(org_svd))
  
  # Display the reconstructed image using the first 10 PCs from SVD
  image(org_svd_display, col = gray.colors(256), axes = FALSE)
  title("Reconstructed Image using First 10 PCs from SVD")
  
  # Reconstruct the image using the first 10 PCs from PCA
  org_pca_10 <- PCpca[, 1:10] %*% signals[1:10, ] + colMeans(quokka_bw)
  
  # Normalize pixel values for display
  org_pca_10_display <- abs(org_pca_10) / max(abs(org_pca_10))
  
  # Display the reconstructed image using the first 10 PCs from PCA
  image(org_pca_10_display, col = gray.colors(256), axes = FALSE)
  title("Reconstructed Image using First 10 PCs from PCA")
  
  # Use R's built-in PCA function
  pca_builtin <- prcomp(t(data_zero_mean) / sqrt(N - 1))
  PCpca_builtin <- pca_builtin$rotation
  
  # Project the original dataset using R's PCA result
  signals_builtin <- t(PCpca_builtin) %*% data_zero_mean
  
  # Recreate the original signal using R's PCA result
  org_pca_builtin <- PCpca_builtin[, 1:10] %*% signals_builtin[1:10, ] + colMeans(quokka_bw)
  
  # Normalize pixel values for display
  org_pca_builtin_display <- abs(org_pca_builtin) / max(abs(org_pca_builtin))
  
  # Display the reconstructed image using R's PCA
  image(org_pca_builtin_display, col = gray.colors(256), axes = FALSE)
  title("Reconstructed Image using R's PCA")
  
  return(list(PCpca = PCpca, Vpca = Vpca, PCsvd = PCsvd, Vsvd = Vsvd))
}

# Example usage
result <- pca_comparison("quokka.jpg")