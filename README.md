---
title: "Change Detection SAR to Data Cube"
author: "Denis Berroeta"
date: "2023-10-30"
---


## Convencional Methods



## Segmenting remote sensing imagery with FastSAM

[[`📕Paper`](https://arxiv.org/pdf/2306.12156.pdf)] [[`🤗HuggingFace Demo`](https://huggingface.co/spaces/An-619/FastSAM)] [[`Colab demo`](https://colab.research.google.com/drive/1oX14f6IneGGw612WgVlAiy91UHwFAvr9?usp=sharing)] [[`Replicate demo & API`](https://replicate.com/casia-iva-lab/fastsam)] [[`Model Zoo`](#model-checkpoints)] [[`BibTeX`](#citing-fastsam)]




The **Fast Segment Anything Model(FastSAM)** is a CNN Segment Anything Model trained using only 2% of the SA-1B dataset published by SAM authors. FastSAM achieves comparable performance with
the SAM method at **50× higher run-time speed**.
Reference: [https://samgeo.gishub.org/examples/fast_sam/](https://samgeo.gishub.org/examples/fast_sam/)


## Installation

Clone the repository locally:

```shell
git clone https://github.com/CASIA-IVA-Lab/FastSAM.git
```

Create the conda env. The code requires `python>=3.7`, as well as `pytorch>=1.7` and `torchvision>=0.8`. Please follow the instructions [here](https://pytorch.org/get-started/locally/) to install both PyTorch and TorchVision dependencies. Installing both PyTorch and TorchVision with CUDA support is strongly recommended.

```shell
conda create -n FastSAM python=3.9
conda activate FastSAM
```

Install the packages:

```shell
cd FastSAM
pip install -r requirements.txt
```

Install CLIP:

```shell
pip install git+https://github.com/openai/CLIP.git
```


## <a name="Models"></a>Model Checkpoints

Two model versions of the model are available with different sizes. Click the links below to download the checkpoint for the corresponding model type.

- **`default` or `FastSAM`: [YOLOv8x based Segment Anything Model](https://drive.google.com/file/d/1m1sjY4ihXBU1fZXdQ-Xdj-mDltW-2Rqv/view?usp=sharing) | [Baidu Cloud (pwd: 0000).](https://pan.baidu.com/s/18KzBmOTENjByoWWR17zdiQ?pwd=0000)**
- `FastSAM-s`: [YOLOv8s based Segment Anything Model.](https://drive.google.com/file/d/10XmSj6mmpmRb8NhXbtiuO9cTTBwR_9SV/view?usp=sharing)


## Usage

### Step 1: Image preprocessing

**preprocessing unique:**

To transform image to be read by FastSAM then apply the `utils/transform_image.py` script, for example:

```python
apply_transform(input_image_file='./images/ST_001/DD_ST_001_255.tif',
                output_image_file='./sam_imputs/ST_001/DD_ST_001_255.tif')

```

**Multi preprocessing:**

If you want to apply the above procedure massively to all image files contained in folders and subfolders you should use the `utils/transform_fsam_sp.py` script and add only the source folder (`input_folder`) and the output folder (`output_folder`).


```python
...

# Iterar por multiples carpetas
input_folder = "MC_DIF_samsara"
output_folder = 'sam_input'

...
```


### Step 2: Apply FastSAM

This procedure returns the segmentation in different formats:

- Image PNG
- Image TIF
- Polygon Shapefile 
- Polygon geojson 



**unique segmentation:**

The second step is the segmentation with the **FastSAM** model, where you can apply the model for an image using the `fastSAM_sp.py` script, just modify the path of the input image, as shown below:

```python
...

# model fastSAM
model_path = 'weights/FastSAM-x.pt'
sam = SamGeo(model=model_path)

image = "sam_imputs/ST_007/DD_ST_007.tif"
sam.set_image(image)
...
```

**Multi segmentation:**

If you want to apply the above procedure in bulk to all image files contained in folders and subfolders you should use the `fastSAM_all.py` script and add only the source folder (`input_folder`) and the output folder (`output_folder`).



```python
...

# Modelos SAM
model_path = 'weights/FastSAM-x.pt'
sam = SamGeo(model=model_path)

# Iterar por multiples carpetas
input_folder = "sam_input"
output_folder = 'results'
...
```


