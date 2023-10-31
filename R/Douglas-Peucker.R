
# "Triangular Threshold Segmentation" 
# Douglas-Peucker algoritmo
# Pseudocódigo:
  
# 1. Calcular el histograma de la imagen DI.
# 2. Calcular el valor umbral inicial (T) como el punto medio entre el valor mínimo y máximo de la imagen DI.
# 3. Inicializar una lista vacía para almacenar las clases resultantes.
# 4. Repetir los pasos 5-7 hasta que el valor umbral no cambie significativamente.
# 5. Calcular las medias de las clases formadas por los píxeles con valores por encima y por debajo del umbral actual.
# 6. Calcular el nuevo valor umbral como el promedio entre las medias de las clases.
# 8. Actualizar las clases resultantes dividiendo los píxeles en dos grupos: aquellos con valores por encima del umbral y aquellos con valores por debajo del umbral.
# Devolver las clases resultantes.


triangular_threshold_segmentation <- function(image) {
  # histogram <- hist(image, breaks = seq(0, 255, by = 1), plot = FALSE)
  min_val <- min(image, na.rm = T)
  max_val <- max(image, na.rm = T)
  threshold <- (min_val + max_val) %/% 2
  
  repeat {
    class_means <- c(mean(image[image <= threshold], na.rm = T), 
                     mean(image[image > threshold], na.rm = T))
    new_threshold <- mean(class_means, na.rm = T)
    
    if (abs(threshold - new_threshold) < 1) {
      break
    }
    
    threshold <- new_threshold
  }
  
  classes <- list(leq_th = (image <= threshold),
                  gt_th  = (image > threshold),
                  threshold = threshold)
  
  
  return(classes)
}

