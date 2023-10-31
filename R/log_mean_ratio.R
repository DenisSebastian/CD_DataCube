
# Log Mean Ratio (LMR)

lmr_neighbourhood <- function(raster_1, raster_2, neighbourhood_size) {

  # Convertir las imágenes a matrices
  matrix1 <- as.matrix(raster_1)
  matrix2 <- as.matrix(raster_2)

  # Obtener el tamaño del vecindario (neighbourhood)
  neighbourhood_radius <- (neighbourhood_size - 1) / 2

  # Obtener las dimensiones de las imágenes
  width <- dim(matrix1)[2]
  height <- dim(matrix1)[1]

  # Crear una matriz para almacenar los resultados del LMR
  lmr_matrix <- matrix(NA, nrow = height, ncol = width)

  # Calcular el LMR para cada píxel en el vecindario (neighbourhood)
  for (i in 1:height) {
    for (j in 1:width) {
      # Obtener el vecindario (neighbourhood) correspondiente al píxel (i,j)
      start_row <- max(1, i - neighbourhood_radius)
      end_row <- min(height, i + neighbourhood_radius)
      start_col <- max(1, j - neighbourhood_radius)
      end_col <- min(width, j + neighbourhood_radius)

      neighbourhood1 <- matrix1[start_row:end_row, start_col:end_col]
      neighbourhood2 <- matrix2[start_row:end_row, start_col:end_col]

      # Calcular la media logarítmica de cada imagen en el vecindario
      mean_1 <- mean(neighbourhood1 + 1, na.rm =T)
      mean_2 <- mean(neighbourhood2 + 1, na.rm =T)

      # Calcular el LMR
      lmr <- log(max((mean_1 / mean_2),(mean_2 / mean_1), na.rm =T))

      # Almacenar el valor del LMR en la matriz resultante
      lmr_matrix[i, j] <- lmr
    }
  }

  return(lmr_matrix)
}

