
import numpy as np
import cv2


# Lectura de Imágenes
img1 = cv2.imread('data/samples/tif/1_1.tif', cv2.IMREAD_GRAYSCALE)
img2 = cv2.imread('data/samples/tif/1_2.tif', cv2.IMREAD_GRAYSCALE)


# definción de una función 

def log_ratio(image1, image2, epsilon=1e-6):
  # Divide la imagen 1 por la imagen 2 y calcula el logaritmo en base 10 del resultado
  ratio = np.log10(image2.astype('float')/ image1.astype('float')+ epsilon)
  
  # Escala el resultado a un rango de 0-255 para que se pueda mostrar como imagen
  # ratio = cv2.normalize(ratio, None, 0, 255, cv2.NORM_MINMAX)
    
  # Convierte la imagen de flotante a entero
  ratio = ratio.astype('uint8')
  
  return ratio


    
lr_img = log_ratio(img1, img2)
cv2.imshow('Resultado', lr_img)

output_path = 'data/results/lr.tif'
cv2.imwrite(output_path, lr_img)





# 
