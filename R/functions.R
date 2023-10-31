

# Conserva outliers -------------------------------------------------------
keep_outliers <- function(x, n_sd = 1) {
  mean_x <- mean(x, na.rm = TRUE)
  sd_x <- sd(x, na.rm = TRUE) * n_sd
  x[x <= (mean_x + sd_x) & x >= (mean_x - sd_x)] <- NA
  return(x)
}


gte_zero <- function(x){ifelse(x<0, NA, x)}



gte_umbral <- function(value) {
  function(x) {
    ifelse(x < value, NA, x)
  }
}


zero_pad <- function(img, pad) {
  # img: matriz en formato R (m, n_H, n_W, n_C)
  # pad: vector de longitud 4 con valores (pad_top, pad_bottom, pad_left, pad_right)
  
  img_pad <- array(0, dim = c(dim(img)[1], dim(img)[2] + sum(pad[c(1, 2)]), dim(img)[3] + sum(pad[c(3, 4)]), dim(img)[4]))
  
  img_pad[, (pad[1] + 1):(dim(img)[2] + pad[1]), (pad[3] + 1):(dim(img)[3] + pad[3]), ] <- img
  
  return(img_pad)
}



inf_na <- function(x){ifelse(is.infinite(x)|is.infinite(x), NA, x)}

