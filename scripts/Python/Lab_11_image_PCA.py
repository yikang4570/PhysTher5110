import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from skimage import io, color

# Load the image
image_path = "quokka.jpg"
quokka_image = io.imread(image_path)

# Convert the image to grayscale
grayscale_quokka = color.rgb2gray(quokka_image)

# Flatten the image to a 1D array
flattened_quokka = grayscale_quokka.flatten()

# Perform PCA
n_components_list = [1, 20, 50, 100]
for n_components in n_components_list:
    pca = PCA(n_components=n_components)
    reduced_quokka = pca.fit_transform(flattened_quokka.reshape(1, -1))
    reconstructed_quokka = pca.inverse_transform(reduced_quokka)

    # Reshape the reconstructed image to its original shape
    reconstructed_quokka = reconstructed_quokka.reshape(grayscale_quokka.shape)

    # Display the original and reconstructed images
    plt.figure(figsize=(8, 4))
    
    plt.subplot(1, 2, 1)
    plt.imshow(grayscale_quokka, cmap='gray')
    plt.title('Original Image')

    plt.subplot(1, 2, 2)
    plt.imshow(reconstructed_quokka, cmap='gray')
    plt.title(f'Reconstructed Image ({n_components} PCs)')

    plt.show()


    
