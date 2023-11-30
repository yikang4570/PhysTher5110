import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from skimage import io, color

import os

# Set the working directory
working_directory = r"C:\Users\kelop\OneDrive\Documents"
os.chdir(working_directory)

def pca_comparison(image_path):
    # Load the image
    quokka = io.imread(image_path)
    
    # Display the original image
    plt.figure()
    plt.imshow(quokka)
    plt.title('Original Image')
    plt.show()

    # Convert to grayscale
    quokka_bw = color.rgb2gray(quokka)
    
    # Display the grayscale image
    plt.figure()
    plt.imshow(quokka_bw, cmap='gray')
    plt.title('Grayscale Image')
    plt.show()

    # Get image dimensions
    M, N = quokka_bw.shape

    # Subtract mean for each dimension
    data_zero_mean = quokka_bw - quokka_bw.mean(0)

    # Calculate the covariance matrix
    covariance = (1 / (N - 1)) * np.dot(data_zero_mean, data_zero_mean.T)

    # Find eigenvectors and eigenvalues
    Vpca, PCpca = np.linalg.eig(covariance)

    # Take the real part of eigenvalues
    Vpca = np.real(Vpca)

    # Sort variances in decreasing order
    rindices = np.argsort(Vpca)[::-1]
    Vpca = Vpca[rindices]
    PCpca = PCpca[:, rindices]

    # Project the original dataset
    signals = np.dot(PCpca.T, data_zero_mean)

    # Recreate the original signal
    org_pca1 = np.dot(PCpca[:, :1], signals[:1, :]) + quokka_bw.mean(0)

    # Normalize pixel values for display
    org_pca_display = np.abs(org_pca1) / np.max(np.abs(org_pca1))

    # Display the reconstructed image using the first PC alone
    plt.figure()
    plt.imshow(org_pca_display, cmap='gray')
    plt.title('Reconstructed Image using First PC')
    plt.show()

    # Perform PCA using singular value decomposition (SVD)
    Y = data_zero_mean.T / np.sqrt(N - 1)

    # Run SVD
    _, S, PCsvd = svd(Y)

    # Calculate variances
    Vsvd = S**2

    # Project the original dataset
    signals_svd = np.dot(PCsvd.T, data_zero_mean)

    # Recreate the original signal
    org_svd = np.dot(PCsvd, signals_svd) + quokka_bw.mean(0)

    # Normalize pixel values for display
    org_svd_display = np.abs(org_svd) / np.max(np.abs(org_svd))

    # Display the reconstructed image using the first 10 PCs from SVD
    plt.figure()
    plt.imshow(org_svd_display, cmap='gray')
    plt.title('Reconstructed Image using First 10 PCs from SVD')
    plt.show()

    # Reconstruct the image using the first 10 PCs from PCA
    org_pca_10 = np.dot(PCpca[:, :10], signals[:10, :]) + quokka_bw.mean(0)

    # Normalize pixel values for display
    org_pca_10_display = np.abs(org_pca_10) / np.max(np.abs(org_pca_10))

    # Display the reconstructed image using the first 10 PCs from PCA
    plt.figure()
    plt.imshow(org_pca_10_display, cmap='gray')
    plt.title('Reconstructed Image using First 10 PCs from PCA')
    plt.show()

    # Use NumPy's built-in PCA function
    _, _, Vpca_builtin = np.linalg.svd(data_zero_mean.T / np.sqrt(N - 1))
    PCpca_builtin = Vpca_builtin.T

    # Project the original dataset using NumPy's PCA result
    signals_builtin = np.dot(PCpca_builtin.T, data_zero_mean)

    # Recreate the original signal using NumPy's PCA result
    org_pca_builtin = np.dot(PCpca_builtin[:, :10], signals_builtin[:10, :]) + quokka_bw.mean(0)

    # Normalize pixel values for display
    org_pca_builtin_display = np.abs(org_pca_builtin) / np.max(np.abs(org_pca_builtin))

    # Display the reconstructed image using NumPy's PCA
    plt.figure()
    plt.imshow(org_pca_builtin_display, cmap='gray')
    plt.title('Reconstructed Image using NumPy\'s PCA')
    plt.show()

    return PCpca, Vpca, PCsvd, Vsvd

# Example usage
PCpca, Vpca, PCsvd, Vsvd = pca_comparison('quokka.jpg')
    
