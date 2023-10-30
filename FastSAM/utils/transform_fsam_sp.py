
import sys

import cv2
import os
from utils.transform_image import *

# Iterar por multiples carpetas
input_folder = "MC_DIF_samsara"
output_folder = 'sam_input'

# Iterador que recorre las carpetas
for folder in os.listdir(input_folder):
    input_folder = os.path.join(input_folder, folder)
    # Verificar si es una carpeta
    if os.path.isdir(input_folder):
        for filename in os.listdir(input_folder):
            if filename.endswith(".tif"):  # Cambia esto según el tipo de imagen que tengas
                input_path = os.path.join(input_folder, filename)
                output_path = os.path.join(output_folder, folder)
                
                if not os.path.exists(output_path):
                    os.makedirs(output_path)

                output_name = os.path.join(output_path, filename)
                apply_transform(input_image_file=input_path,
                        output_image_file=output_name)
                print(filename)       


