# Librerías

import sys

import leafmap
import torch
from samgeo import tms_to_geotiff
from samgeo.fast_sam import SamGeo
import cv2
import os
import sys
import io


# Device
DEVICE = torch.device(
    "cuda"
    if torch.cuda.is_available()
    else "mps"
    if torch.backends.mps.is_available()
    else "cpu"
)


# Modelos SAM
model_path = 'weights/FastSAM-x.pt'
sam = SamGeo(model=model_path)



# Iterar por multiples carpetas
input_folder = "sam_input"
output_folder = 'results'

# Iterador que recorre las carpetas
for folder in sorted(os.listdir(input_folder)):
    input_folder = os.path.join(input_folder, folder)
    output_path = os.path.join(output_folder, folder)
    if not os.path.exists(output_path):
        os.makedirs(output_path)
    
    
    # Verificar si es una carpeta
    if os.path.isdir(input_folder):
        for filename in os.listdir(input_folder):
            if not filename.endswith(".tif"):  # Cambia esto según el tipo de imagen que tengas
                continue
            try:
                input_path = os.path.join(input_folder, filename)
                
                # output name
                base_name, ext = os.path.splitext(filename)
                output_tif = os.path.join(output_path, filename)
                output_png = os.path.join(output_path, base_name + ".png")
                output_shp = os.path.join(output_path, base_name + ".shp")
                output_geojson = os.path.join(output_path, base_name + ".geojson")
                
                # SAM
                stdout_backup = sys.stdout  # Guarda la salida estándar original
                sys.stdout = io.StringIO()  # Redirige la salida estándar a un objeto StringIO
                sam.set_image(input_path)
                output = sys.stdout.getvalue()  # Obtiene la salida estándar como una cadena
                sys.stdout = stdout_backup  # Restaura la salida estándar original
                
                if 'No object detected' in output:
                    print("NO DETECTADO")
                    continue
                
                sam.everything_prompt(output = output_tif)
                #sam.show_anns(output_png)
                sam.raster_to_vector(output_tif, output_shp)
                sam.raster_to_vector(output_tif, output_geojson)
                
            except Exception as e:
                print(f"Error al procesar {filename}: {e}")

                

