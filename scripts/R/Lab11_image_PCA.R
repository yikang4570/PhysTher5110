# Load required libraries
library(jpeg)
library(pracma)
library(imager)
library(grid)

# Read the image
quokka <- readJPEG("quokka.jpg")

# Convert the image to grayscale using imager::grayscale
quokkaBW <- imager::grayscale(quokka)

# Flatten the image matrix into a vector
quokkaVector <- as.vector(quokkaBW)

# Perform PCA
pcaResult <- prcomp(t(quokkaVector), center = TRUE, scale = FALSE)

# Function to reconstruct the image using a specified number of principal components
reconstructImage <- function(pcaResult, numComponents) {
  # Extract the first 'numComponents' principal components
  components <- pcaResult$rotation[, 1:numComponents]
  
  # Project the original data onto the selected components
  projectedData <- t(components) %*% quokkaVector
  
  # Reconstruct the image using the selected components
  reconstructedImageVector <- components %*% projectedData
  reconstructedImageMatrix <- matrix(reconstructedImageVector, nrow = nrow(quokkaBW), ncol = ncol(quokkaBW), byrow = TRUE)
  
  # Return the reconstructed image matrix
  return(reconstructedImageMatrix)
}

# Function to plot the reconstructed image
plotReconstructedImage <- function(reconstructedImage, numComponents) {
  grid.newpage()
  grid.raster(reconstructedImage, interpolate = FALSE, width = 1)
  grid.text(label = paste("Components:", numComponents), x = 0.5, y = 0.95)
}

# Allow the user to interactively reconstruct the image using different numbers of components
numComponents <- NULL

while (TRUE) {
  # Get user input for the number of principal components
  numComponents <- as.integer(readline("Enter the number of principal components (0 to exit): "))
  
  # Check if the user wants to exit
  if (numComponents == 0) {
    break
  }
  
  # Check if the input is valid
  if (numComponents < 0 || numComponents > ncol(quokkaVector)) {
    cat("Invalid input. Please enter a valid number of principal components.\n")
    next
  }
  
  # Reconstruct the image using the specified number of components
  reconstructedImage <- reconstructImage(pcaResult, numComponents)
  
  # Plot the reconstructed image
  plotReconstructedImage(reconstructedImage, numComponents)
}

# Close any open devices
dev.off()
