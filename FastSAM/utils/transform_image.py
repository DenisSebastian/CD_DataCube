import numpy as np
import cv2
import os
import rasterio





# Funciones
def fix_no_data_value(input_file, no_data_value=0):
    with rasterio.open(input_file, "r+") as src:
        src.nodata = no_data_value
        for i in range(1, src.count + 1):
            band = src.read(i)
            band = np.where(band==no_data_value, no_data_value,band)
    return band
                


                
# Agregar una dimensión al inicio
def add_dim(input_image_file, im_values_expanded,  output_image_file):
  with rasterio.open(input_image_file) as src:
      # Verificar si las dimensiones coinciden después de la expansión
      if im_values_expanded.shape[1:] == src.shape:
          # Actualizar perfil del raster para escritura
          profile = src.profile
          profile.update(count=1, dtype=str(im_values_expanded.dtype))
  
          # Guardar el raster modificado
          with rasterio.open(output_image_file, 'w', **profile) as dst:
              dst.write(im_values_expanded)
          print("Proceso completado.")
      else:
          print("Las dimensiones de los datos de reemplazo no coinciden con el raster.")


def apply_transform(input_image_file, output_image_file, no_data_value = 0):
    img_no_data = fix_no_data_value(input_image_file,no_data_value)
    im_values = (img_no_data*255).astype(np.uint16)
    im_values_expanded = np.expand_dims(im_values, axis=0)
    add_dim(input_image_file = input_image_file, 
            im_values_expanded = im_values_expanded, 
            output_image_file = output_image_file)
    

# apply_transform(input_image_file='./images/ST_001/DD_ST_001_255.tif',
#                 output_image_file='./sam_imputs/ST_001/DD_ST_001_255.tif')
                
