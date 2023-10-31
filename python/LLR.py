
import numpy as np
import cv2


# Lectura de Imágenes
img1 = cv2.imread('data/samples/tif/1_1.tif', cv2.IMREAD_GRAYSCALE)
img2 = cv2.imread('data/samples/tif/1_2.tif', cv2.IMREAD_GRAYSCALE)


# definción de una función 

    
def log_likelihood_ratio(img1, img2, kernel, epsilon=1e-6):
    """
    Calculates the logarithmic likelihood ratio between two images pixel by pixel,
    using a kernel to define the neighborhood.

    Parameters:
    img1 (ndarray): first input image.
    img2 (ndarray): second input image.
    kernel (ndarray): matrix corresponding to the kernel to define the neighborhood.
    epsilon (float): small constant value to avoid division by zero.

    Returns:
    ndarray: an image with the differences between the two input images.
    """

    # Get the dimensions of the kernel
    k_height, k_width = kernel.shape

    # Calculate the padding needed for the convolution
    pad_height = k_height // 2
    pad_width = k_width // 2

    # Pad the images with zeros
    img1_padded = cv2.copyMakeBorder(img1, pad_height, pad_height, pad_width, pad_width, cv2.BORDER_CONSTANT)
    img2_padded = cv2.copyMakeBorder(img2, pad_height, pad_height, pad_width, pad_width, cv2.BORDER_CONSTANT)

    # Create a mask with the kernel values
    mask = np.zeros_like(kernel)
    mask[kernel != 0] = 1

    # Calculate the mean and standard deviation of each image in the neighborhood defined by the kernel
    mean1 = cv2.filter2D(img1_padded, -1, kernel) / cv2.filter2D(mask, -1, kernel)
    mean2 = cv2.filter2D(img2_padded, -1, kernel) / cv2.filter2D(mask, -1, kernel)
    std1 = np.sqrt(cv2.filter2D(np.square(img1_padded), -1, kernel) / cv2.filter2D(mask, -1, kernel) - np.square(mean1))
    std2 = np.sqrt(cv2.filter2D(np.square(img2_padded), -1, kernel) / cv2.filter2D(mask, -1, kernel) - np.square(mean2))

    # Calculate the variance of the difference between the two images
    diff_var = np.square(std1) + np.square(std2) - 2*np.multiply(std1, std2)*cv2.PSNR(img1_padded, img2_padded)

    # Calculate the logarithmic likelihood ratio for each pixel
    log_lk_ratio = np.log(np.divide((std2**2 + epsilon), (std1**2 + epsilon))) + (diff_var/(2*np.square(std1))) - 0.5

    # Remove the padding
    log_lk_ratio = log_lk_ratio[pad_height:-pad_height, pad_width:-pad_width]

    # Normalize the logarithmic likelihood ratio to [0, 255]
    log_lk_ratio = cv2.normalize(log_lk_ratio, None, 0, 255, cv2.NORM_MINMAX, cv2.CV_8UC1)

    return log_lk_ratio


    
# Define the kernel for the neighborhood
kernel = np.ones((3,3), np.float32) / 9

# Calculate the logarithmic likelihood ratio
diff_img = log_likelihood_ratio(img1, img2, kernel)

# Display the result
cv2.imshow("Differences", diff_img)

output_path = 'data/results/llr.tif'
cv2.imwrite(output_path, lr_img)

