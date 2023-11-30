import numpy as np
import matplotlib.pyplot as plt
from scipy.io import imread
from skimage.color import rgb2gray

def pca_comparison(image_path):
    # Load the image
    quokka = imread(image_path)
    
    # Display the original image
    plt.figure()
    plt.imshow(quokka)
    plt.title('Original Image')
    plt.show()

    # Convert the image to grayscale
    quokka_bw = rgb2gray(quokka)

    # Display the grayscale image
    plt.figure()
    plt.imshow(quokka_bw, cmap='gray')
    plt.title('Grayscale Image')
    plt.show()

    # Get dimensions
    M, N = quokka_bw.shape

    # Subtract the mean for each dimension
    data_zero_mean = quokka_bw - np.mean(quokka_bw)

    # Calculate the covariance matrix
    covariance = (1 / (N - 1)) * data_zero_mean @ data_zero_mean.T

    # Find the eigenvectors and eigenvalues
    Vpca, PCpca = np.linalg.eigh(covariance)

    # Sort the variances in decreasing order
    rindices = np.argsort(Vpca)[::-1]
    Vpca = Vpca[rindices]
    PCpca = PCpca[:, rindices]

    # Project the original dataset
    signals = PCpca.T @ data_zero_mean
    # Recreate the original signal
    org_pca = PCpca @ signals + np.mean(quokka_bw)

    # Reconstruct the image using the first 10 PCs from PCA
    num_components = 10
    reconstruct_pca = PCpca[:, :num_components] @ signals[:num_components, :] + np.mean(quokka_bw)

    # Perform PCA using singular value decomposition (SVD)
    Y = data_zero_mean.T / np.sqrt(N - 1)

    # Run the SVD
    u, s, PCsvd = np.linalg.svd(Y, full_matrices=False)

    # Calculate variances
    Vsvd = s**2

    # Project the original dataset
    signals_svd = PCsvd @ data_zero_mean
    # Recreate the original signal
    org_svd = PCsvd.T @ signals_svd + np.mean(quokka_bw)

    # Reconstruct the image using the first 10 PCs from SVD
    reconstruct_svd = PCsvd[:, :num_components] @ signals_svd[:num_components, :] + np.mean(quokka_bw)

    # Display the reconstructed images
    plt.figure()
    plt.imshow(reconstruct_pca, cmap='gray')
    plt.title('Reconstructed Image (PCA)')
    plt.show()

    plt.figure()
    plt.imshow(reconstruct_svd, cmap='gray')
    plt.title('Reconstructed Image (SVD)')
    plt.show()

    # Use NumPy's built-in PCA function
    _, _, Vpca_builtin = np.linalg.svd(data_zero_mean.T / np.sqrt(N - 1), full_matrices=False)

    # Reconstruct the image using the first 10 PCs from built-in PCA
    reconstruct_builtin = Vpca_builtin[:num_components, :] @ signals[:num_components, :] + np.mean(quokka_bw)

    # Display the reconstructed image using NumPy's built-in PCA
    plt.figure()
    plt.imshow(reconstruct_builtin, cmap='gray')
    plt.title('Reconstructed Image (Built-in PCA)')
    plt.show()

    return PCpca, Vpca, PCsvd, Vsvd

# Call the function with the image path
PCpca, Vpca, PCsvd, Vsvd = pca_comparison('quokka.jpg')
