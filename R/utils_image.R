


# cambiar fotmato de tif a png()


# list.files(path = "results", pattern = ".tif", full.names = T)%>%
#   purrr::map(tif2png)

tif2png <- function(path_tif){
  path_out <- path_tif %>% gsub(".tif$", ".png", .)
  # read
  tif_img <- magick::image_read(path_tif, depth =16, strip =F,
                                defines= c("colormap:type"= "gray"))
  # #convert
  # png_img <- magick::image_convert(tif_img, format = "png",
  #                                  colorspace = "gray")
  #write

  magick::image_write(tif_img,
                      path = path_out, depth =16, quality = 100,
                      defines= c("colorspace:type"= "gray"))
}

tif2png_v2 <- function(path_tif){
  path_out <- path_tif %>% gsub(".tif$", ".png", .)
  png::writePNG(raster::raster(path_tif) %>% as.matrix(),
                target = path_out)
}

png2tif <- function(path_png){
  path_out <- path_png %>% gsub(".png$",".tif", .)
  magick::image_write(magick::image_read(path_png), path = path_out)

}

# guardar imagen tif
write_img <- function(image, name, format_out = "tif", path_out = "results"
                      # ,datatype = "FLT4S"
                      ){
  if(format_out == "tif"|format_out == "tiff"){
    name_file_out = paste0(path_out, "/", name,".", format_out)
    terra::writeRaster(image, name_file_out, overwrite = T
                       # ,
                       # datatype=datatype
                       # , datatype='INT2U'
                       )
  }
  print(paste0("Guardando imagen en: ", name_file_out))
}

inf_na <- function(x){ifelse(is.infinite(x)| !is.infinite(x), NA, x)}

th_zero <- function(x, th=200){ifelse(x<th, 0, x)}

scaleRaster <- function(raster, max = 255) {
  # raster <- calc(raster, fun = inf_na)
  # Obtener el valor mínimo y máximo del raster
  min_valor <- min(raster[], na.rm = TRUE)
  max_valor <- max(raster[], na.rm = TRUE)

  if(min_valor == max_valor){
    values(raster) <- max
    raster_escalado <-  raster

  }else{
    # Calcular el rango de valores
    rango <- max_valor - min_valor

    # Escalar el raster desde 0
    raster_escalado <- (raster - min_valor) / rango
    raster_escalado <- raster_escalado*max

  }


  return(raster_escalado)
}


th_lte <- function(x, th_lt=20, to = NA){ifelse(x<=th, to, x)}
th_gte <- function(x, th_lt=20, to = NA){ifelse(x>=th, to, x)}
th_gte_bin <- function(x, th_gte=100, yes = 1, no = 0){ifelse(x>=th_gte, yes, no)}

# eliminación de ruido
filter_noise <- function(image, vmax_255 = T, nb=7){

  suma_vecinos <- terra::focal(image, fun = sum,
                               w = matrix(1, nrow = 3, ncol = 3))
  mascara <- suma_vecinos < nb
  imagen_limpia <- image
  imagen_limpia[mascara] <- 0
  if(isTRUE(vmax_255)){
    imagen_limpia <- imagen_limpia*255
  }
  return(imagen_limpia)
}

padding_mean <- function(imagen, padding_size, n_matrix = 3,vmax_255 = T) {
  if(max(values(imagen), na.rm = T)==255){
    imagen <- imagen/255
  }

  # Extender el raster con el tamaño de padding especificado
  raster_padding <- extend(imagen, padding_size)

  # Aplicar la función de vecindad con el raster extendido
  resultado <- focal(raster_padding, fun = mean,
                     w = matrix(1, nrow = n_matrix, ncol = n_matrix))

  # Recortar el resultado para eliminar el padding agregado
  resultado_recortado <- crop(resultado, imagen)


  if(isTRUE(vmax_255) & max(values(imagen), na.rm = T)<=1){
    resultado_recortado <- resultado_recortado*255
  }

  return(resultado_recortado)
}


filter_noise_pad <- function(image, vmax_255 = T, nb=7){
  if(max(values(image), na.rm = T)==255){
    image <- image/255
  }
  imagen_borde <- extend(image, y =  1)
  suma_vecinos <- terra::focal(imagen_borde, fun = sum,
                               w = matrix(1, nrow = 3, ncol = 3))
  mascara <- suma_vecinos < nb
  imagen_limpia <- imagen_borde
  imagen_limpia[mascara] <- 0
  if(isTRUE(vmax_255)){
    imagen_limpia <- imagen_limpia*255
  }

  imagen_limpia <- crop(imagen_limpia, image)
  return(imagen_limpia)
}




#' Verificación si raster está escalado
#'
#' @param r raster
#' @param max valor máximo a verificar
#' @param min valor mínimo a verificas
#'
#' @return TRUE si está escalado por los valores min y max
#' @export
#'
#' @examples
is_scaled <- function(r, max = 255, min = 0){

  state <- if(cellStats(r, "min") == min &
              cellStats(r, "max") == max) T

  return(state)

}

