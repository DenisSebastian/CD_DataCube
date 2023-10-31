import numpy as np


def diff_image(image_before, image_after, is_abs=True, is_multi_channel=False):
    img_diff = np.array(image_after, dtype=np.float32)-np.array(image_before, dtype=np.float32)
    if is_multi_channel:
        img_diff = np.sqrt(np.sum(np.square(img_diff), axis=-1))
    else:
        if is_abs:
            img_diff = np.abs(img_diff)
    return np.array(img_diff, dtype=np.uint8)




  
