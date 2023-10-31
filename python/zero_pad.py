
def zero_pad(img, pad):
    """
     Pad with zeros all images of the data set X. The padding is applied to the height and width of an image.

    :param X: python numpy array of shape (m, n_H, n_W, n_C) representing a batch of m images
    :param pad: integer, amount of padding around each image on vertical and horizontal dimensions
    :return: padded image of shape (m, n_H + 2*pad, n_W + 2*pad, n_C)
    """

    img_pad = np.pad(img, ((pad[0, 0], pad[0, 1]), (pad[1, 0], pad[1, 1])), 'constant')

    return img_pad
