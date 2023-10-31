# Función para calcular el índice DICE

Dice <- function(raster1, raster2, val_true = 255) {
  if(max(values(raster1), na.rm= T) != max(values(raster2), na.rm= T)){
    stop("El valor máximo no es igual")
  }
  
  # Convertir las imágenes a matrices
  matriz1 <- as.matrix(raster1)
  matriz2 <- as.matrix(raster2)
  
  # Calcular el número de píxeles coincidentes
  coincidentes <- sum(matriz1 == val_true & matriz2 == val_true, na.rm = T)
  
  # Calcular el número total de píxeles en ambas imágenes
  total <- sum(matriz1 == val_true, na.rm = T) + sum(matriz2 == val_true, na.rm = T)
  
  # Calcular el índice DICE
  dice <- (2 * coincidentes) / total
  
  return(dice)
}



# Función para calcular el índice de similitud Jaccard
Jaccard <- function(raster1, raster2, val_true = 255) {
  
  if(max(values(raster1), na.rm= T) != max(values(raster2), na.rm= T)){
    stop("El valor máximo no es igual")
  }
  
  # Convertir las imágenes a matrices
  matriz1 <- as.matrix(raster1)
  matriz2 <- as.matrix(raster2)
  
  # Calcular el número de píxeles coincidentes
  coincidentes <- sum(matriz1 == val_true & matriz2 == val_true, na.rm = T)
  
  # Calcular el número de píxeles en alguna de las imágenes
  union <- sum(matriz1 == val_true | matriz2 == val_true, na.rm = T)
  
  # Calcular el índice de similitud Jaccard
  jaccard <- coincidentes / union
  
  return(jaccard)
}


similitary_visual <- function(image_eval, ground_truth){
  
  map_sim <- mapview::mapview( ground_truth, alpha.regions = 1, 
                               layer.name = "Ground Truth")+
    mapview::mapview(image_eval, alpha.regions = 0.5,
                     layer.name = "Image Evaluada")
  
  
  return(map_sim)
}
