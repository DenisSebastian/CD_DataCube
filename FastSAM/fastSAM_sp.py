import leafmap
import torch
from samgeo import tms_to_geotiff
from samgeo.fast_sam import SamGeo


DEVICE = torch.device(
    "cuda"
    if torch.cuda.is_available()
    else "mps"
    if torch.backends.mps.is_available()
    else "cpu"
)


model_path = 'weights/FastSAM-x.pt'
sam = SamGeo(model=model_path)

# image = "images/ST_028/mod_DD_ST_028.tif"
image = "sam_imputs/ST_007/DD_ST_007.tif"
sam.set_image(image)


st =  "ST_007"
results = str("results/"+st)

salida_tif = str(results+"/"+"mask.tif")
salida_png = str(results+"/"+"mask.png")
salida_shp = str(results+"/"+"mask.shp")
salida_geojson = str(results+"/"+"mask.geojson")
salida_map_html = str(results+"/"+"map.html")


sam.everything_prompt(output=salida_tif)
sam.show_anns(salida_png)


sam.raster_to_vector(salida_tif, salida_shp)
sam.raster_to_vector(salida_tif,salida_geojson)

# latitude = -42.21212
# longitude = -73.71519
# m = leafmap.Map(center=[latitude, longitude], zoom=16, height="800px")
# m.add_basemap("SATELLITE")
# m.add_raster(salida_tif, opacity=0.5, layer_name="Mask")
# m.add_vector(salida_geojson, layer_name="Mask Vector")
# m.save(salida_map_html)

