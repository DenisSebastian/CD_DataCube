


# Relación logarítmica (LR) (Dekker, 1998) --------------------------------


log_ratio <-  function(img1, img2){
  div_img <- overlay(img1, img2,
                     fun=function(x,y){return(y/x)})
  lr <- log10(div_img)
  return(lr)
}


#  Relación de verosimilitud logarítmica (LLR):  --------------------------

log_likelihood_ratio <- function(img1, img2, kernel) {
  # Apply the kernel to each pixel and sum the values of the neighborhood
  sum_img1 <- focal(img1, w=kernel, fun=sum, na.rm=TRUE, pad=T,padValue=0)
  if(sum(values(sum_img1), na.rm = T)==0){
   sum_img1 <- sum_img1 +0.01
  }
  sum_img2 <- focal(img2, w=kernel, fun=sum, na.rm=TRUE, pad=T,padValue=0)
  if(sum(values(sum_img2),  na.rm = T)==0){
    sum_img2 <- sum_img2 +0.01
  }

  llr <- log10((sum_img1+sum_img2)^2/(4* sum_img1*sum_img2))

  return(llr)
}



#  Enhanced difference image (EDI) ----------------------------------------


enhanced_difference <- function(d_lr, d_llr){
  EDI <- d_lr * d_llr
  return(EDI)
}





# Diferencia de Imágenes --------------------------------------------------

diff_image <- function(image_before, image_after, is_abs = TRUE,
                       is_multi_channel = FALSE) {
  img_diff <- as.numeric(image_after)-as.numeric(image_before)

  if (is_multi_channel) {
    img_diff <- sqrt(rowSums(img_diff^2))
  } else {
    if (is_abs) {
      img_diff <- abs(img_diff)
    }
  }

  return(as.numeric(img_diff))
}







#' Procedimiento extrar raster sobre triangular_threshold_segmentation
#'
#' @param r raster
#' @param img_ref  raster de referencia para destino
#'
#' @return imagen de referencia con valores NA si están bajo el umbral
#' @export
#'
#' @examples
tts_process <- function(r, img_ref){
  if(!is_scaled(r, max = 255)){
    r =  scaleRaster(r, max = 255)
  }
  r_matrix = r %>% as.matrix()

  dp_clases <-
    triangular_threshold_segmentation(r_matrix)

  umbral_r = dp_clases$threshold
  mayor_r <- dp_clases$gt_th %>% raster()


  mayor_r <- setValues(img_ref, values(mayor_r))
  mayor_r[mayor_r == 0] <- NA
  return(mayor_r)

}

