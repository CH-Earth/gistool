# `Landsat` Geospatial Dataset
In this file, the necessary technical details of the dataset is explained.

## Location of the `Landsat` Dataset Files
The `LandSat` geospatial dataset files are located under the following directory accessible from Digital Alliance (formerly Compute Canada) Graham cluster:

```console
/project/rpp-kshook/Model_Output/Landsat/
```

And the structure of the files is as following:

```console
/project/rpp-kshook/Model_Output/Landsat/
├── land_change_2010v2_2015v2_30m_tif.zip 
├── land_cover_2010v2_30m_tif.zip
├── land_cover_2015v2_30m_tif.zip
└── dl-landcover.sh
```

## Spatial and Temporal Extents

The spatial extent of this dataset (so far only `NALCMS` that is a land cover dataset) covers longitudes from approximately `-180` to `-50` degress and latitudes from approximately `+14` to `+84` degress. This dataset is static and does not vary with time. 

## Dataset Variables
This variables of this dataset are detailed in the table below:

|#	|Variable Name (used in `gistool`)	|Description					|Comments	|
|-------|---------------------------------------|-----------------------------------------------|---------------|
|1      |land-cover				|Land cover classes				|[2010 dataset info](http://www.cec.org/north-american-environmental-atlas/land-cover-2010-landsat-30m/) and [2015 dataset info](http://www.cec.org/north-american-environmental-atlas/land-cover-30m-2015-landsat-and-rapideye/)|
|2	|land-cover-change			|Land cover change (between 2010 and 2015)	|[2010-2015 difference info](http://www.cec.org/north-american-environmental-atlas/land-cover-change-30m-2010-2015-landsat/)|


# Other relevant information
## Land Cover Types
Below the land cover types for each values of the `.tif` files is detailed based on [1].

|#      |Class Value (used in `gistool`)	|Land Cover Description						|RGB Value		|
|-------|---------------------------------------|---------------------------------------------------------------|-----------------------|
|1	|1					|Temperate or sub-polar needleleaf forest			|RGB (0, 61, 0)		|
|2	|2					|Sub-polar taiga needleleaf forest				|RGB (148, 156, 112)	|
|3	|3					|Tropical or sub-tropical broadleaf evergreen forest		|RGB (0, 99, 0)		|
|4	|4					|Tropical or sub-tropical broadleaf deciduous forest		|RGB (30, 171, 5)	|
|5	|5					|Temperate or sub-polar broadleaf deciduous forest		|RGB (20, 140, 61)	|
|6	|6					|Mixed forest							|RGB (92, 117, 43)	|
|7	|7					|Tropical or sub-tropical shrubland				|RGB (179, 158, 43)	|
|8	|8					|Temperate or sub-polar shrubland				|RGB (179, 138, 51)	|
|9	|9					|Tropical or sub-tropical grassland				|RGB (232, 220, 94)	|
|10	|10					|Temperate or sub-polar grassland				|RGB (225, 207, 138)	|
|11	|11					|Sub-polar or polar shrubland-lichen-moss			|RGB (156, 117, 84)	|
|12	|12					|Sub-polar or polar grassland-lichen-moss			|RGB (186, 212, 143)	|
|13	|13					|Sub-polar or polar barren-lichen-moss				|RGB (64, 138, 112)	|
|14	|14					|Wetland							|RGB (107, 163, 138)	|
|15	|15					|Cropland							|RGB (230, 174, 102)	|
|16	|16					|Barren lands							|RGB (168, 171, 174)	|
|17	|17					|Urban								|RGB (220, 33, 38)	|
|18	|18					|Water								|RGB (76, 112, 163)	|
|19	|19					|Snow and ice							|RGB (255, 250, 255)	|

Also, the details of the above table has been included in the following files: [landsat_classes.csv](./landsat_classes.csv).

## Land Cover Changes between 2010 and 2015
The following file contains the following GeoTIFF data:
```console
/project/rpp-kshook/Model_Output/Landsat/land_change_2010v2_2015v2_30m_tif.zip
├── NA_NALCMS_2010v2_2015v2_30m_barren_land_loss_and_gain.tif
├── NA_NALCMS_2010v2_2015v2_30m_cropland_loss_and_gain.tif
├── NA_NALCMS_2010v2_2015v2_30m_forest_loss_and_gain.tif
├── NA_NALCMS_2010v2_2015v2_30m_grassland_loss_and_gain.tif
├── NA_NALCMS_2010v2_2015v2_30m_shrubland_loss_and_gain.tif
├── NA_NALCMS_2010v2_2015v2_30m_snow_ice_loss_and_gain.tif
├── NA_NALCMS_2010v2_2015v2_30m_urban_loss_and_gain.tif
├── NA_NALCMS_2010v2_2015v2_30m_water_loss_and_gain.tif
├── NA_NALCMS_2010v2_2015v2_30m_wetland_loss_and_gain.tif
└── NA_NALCMS_land_change_2010v2_2015v2_30m.tif
```

Based on the metadata also available in the mentioned .zip file, the GeoTIFF data containing the `*_land_loss_and_gain.tif` phrase in their file name contain "[g]eneral land cover gains an losses [...] at the North American scale [...] for the following land cover class groups:"

  1. Forest
  2. Shrubland
  3. Grassland
  4. Wetland
  5. Cropland
  6. Barren Land
  7. Urban and Built-up
  8. Water
  9. Snow and Ice   

And, the pixel values of the mentioned `.tif` files are as following:

|#	|Pixel Value |Value Description |
|-------|------------|------------------|
|1	|1	     |Gain	        |
|2	|2	     |Loss	        |

Furthermore, the GeoTIFF data named `NA_NALCMS_land_change_2010v2_2015v2_30m.tif` also contains the landcover change data. Each pixel value of the GeoTIFF file contains information regarding transformations between different landcover classes of the dataset at the North American scale. Each pixel values of the file contains three or four digits, with "[t]he first one or two digits in each pixel value show the land cover class in 2010, while the third and four digits show the land cover class in 2015." An example of digit values are given in the following:

```
105   = Class 1 to 5	"Temperate or sub-polar needleleaf forest" to "Temperate or sub-polar broadleaf deciduous forest"
206   = Class 2 to 6	"Sub-polar taiga needleleaf forest" to "Mixed forest"
814   = Class 8 to 14	"Temperate or sub-polar shrubland" to "Wetland"
915   = Class 9 to 15	"Tropical or sub-tropical grassland" to "Cropland"
1018  = Class 10 to 18	"Temperate or sub-polar grassland" to "Water"
1502  = Class 15 to 02	"Cropland" to "Sub-polar taiga needleleaf forest"
1716  = Class 17 to 16	"Urban and built-up" to "Barren land"
1913  = Class 19 to 01	"Snow and ice" to "Sub-polar or polar barren-lichen-moss"
```
