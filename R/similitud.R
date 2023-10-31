# Cargar la biblioteca
library(raster)
library(dplyr)


# Recursos ----------------------------------------------------------------
source("R/fnc_simulitud.R")
source("R/libraries.R")
source("R/fnc_spatials.R")



# changes -----------------------------------------------------------------

folder_roi <-  "data/turberas/shapes/"
path_roi <- paste0(folder_roi, "changes.shp")
roi <-  read_shps(path_file = path_roi, crs_dest = 4326)
roi <- roi %>% mutate(ID = sprintf("%03d", as.numeric(ID)))
mapview(roi)


img_prd <-  raster("data/turberas/sitios/ST_021/mask.tif")
# img_prd <-  calc(x = img_prd, fun = function(x) ifelse(x ==255, 1, x))
img_prd[img_prd==255] <- 1


change <-  roi %>% filter(ID == "021")
mapview(img_prd)



# shape to raster  (GT) ---------------------------------------------------

gt_base  <-  img_prd
values(gt_base) <- 0

img_gt <- rasterize(change, gt_base, field = 1, getCover=TRUE)


mapview(img_prd) + mapview(img_gt)

img_eval <-  img_prd



# Metricas ----------------------------------------------------------------


simDICE <- Dice(raster1 = img_eval,raster2 = img_gt, val_true =1)
print(simDICE) %>% round(3)

simJaccard<- Jaccard(raster1 = img_eval,raster2 =img_gt, val_true = 1)
print(simJaccard)%>% round(3)


similitary_visual(image_eval = img_eval,ground_truth =img_gt)





