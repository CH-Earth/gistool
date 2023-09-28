# `MODIS` Geospatial Dataset
In this file, the necessary technical details of the dataset is explained. It is worth noting that, `MODIS` has many products and here only useful products for the Canadian hydrological community are described.

## Location of the `MODIS` Dataset Files
The `MODIS` geospatial dataset files are located under the following directory accessible from Digital Alliance (formerly Compute Canada) Graham cluster:

```console
/project/rpp-kshook/Climate_Forcing_Data/geospatial-data/MODIS/
```

And the structure of the files is as following:

```console
/project/rpp-kshook/Climate_Forcing_Data/geospatial-data/MODIS/
├── MCD12Q1.006
│   ├── 2001.01.01
│   │   ├── MCD12Q1.A2001001.h00v08.006.2018142182903.hdf 
│   │   ├── MCD12Q1.A2001001.h00v08.006.2018142182903.hdf.xml
│   │   ├── MCD12Q1.A2001001.h00v09.006.2018142182901.hdf
│   │   ├── MCD12Q1.A2001001.h00v09.006.2018142182901.hdf.xml
│   │   ├── .
│   │   ├── .
│   │   ├── .
│   │   ├── MCD12Q1.A2001001.h35v10.006.2018142183401.hdf
│   │   └── MCD12Q1.A2001001.h35v10.006.2018142183401.hdf.xml
│   ├── 2002.01.01
│   │   ├── MCD12Q1.A2002001.h00v08.006.2018143043830.hdf
│   │   ├── MCD12Q1.A2002001.h00v08.006.2018143043830.hdf.xml
│   │   ├── MCD12Q1.A2002001.h00v09.006.2018143043923.hdf 
│   │   ├── MCD12Q1.A2002001.h00v09.006.2018143043923.hdf.xml
│   │   ├── .
│   │   ├── .
│   │	├── .
│   │	├── MCD12Q1.A2002001.h35v10.006.2018143070809.hdf
│   │	└── MCD12Q1.A2002001.h35v10.006.2018143070809.hdf.xml
│   .
│   .
│   .
│   ├── %YYYY.01.01
│   │   ├── MCD12Q1.A{%Y}001.h00v08.006.{%HASHNUM}.hdf
│   │   ├── MCD12Q1.A{%Y}001.h00v08.006.{%HASHNUM}.hdf.xml
│   │   .
│   │   .
│   │   .
│   .
│   .
│   .
└── %var
    ├── .
    ├── .
    ├── .
    └── .
```
"The MCD12Q1 V6 product provides global land cover types at yearly intervals (2001-[2020]) derived from six different classification schemes. It is derived using supervised classifications of `MODIS` Terra and Aqua reflectance data. The supervised classifications then undergo additional post-processing that incorporate prior knowledge and ancillary information to further refine specific classes" [^reference]. The newest land cover dataset, `MCD12Q1.061`, is available annually for the 2001-2022 period [^reference2]

[^reference]: Google. (n.d.). MCD12Q1.006 MODIS land cover type yearly global 500M | Earth Engine Data catalog | Google developers. Google. Retrieved July 7, 2022, from https://developers.google.com/earth-engine/datasets/catalog/MODIS_006_MCD12Q1.
[^reference2]: USGS (n.d.). MODIS/Terra+Aqua Land Cover Type Yearly L3 Global 500m SIN Grid. Retrieved September 28, 2023, from https://lpdaac.usgs.gov/products/mcd12q1v061/.

## Spatial and Temporal Extents

The spatial extent of this dataset covers longitudes from `-180` to `+180` degress and latitudes from `-90` to `+90` degress. The `MCD12Q1.006` variable includes yearly land cover types from 2001 to 2020, while `MCD12Q1.061` provides from 2001 to 2022.

## Dataset Variables
This dataset has 1 main variable that is described in the following table:

|#	|Variable Name (used in `gistool`)	|Description				|Comments	|
|-------|---------------------------------------|---------------------------------------|---------------|
|1	|`MCD12Q1.006`				|Global land cover classes		|This dataset is retired, though available [Link](https://modis.gsfc.nasa.gov/data/dataprod/mod12.php)|
|2	|`MCD12Q1.061`				|Global land cover classes		|The most up-to-date MODIS Landcover dataset[Link](https://lpdaac.usgs.gov/products/mcd12q1v061/)|

# Other relevant information
## Land Cover Types
Below the land cover types for each values of the `.tif` files is detailed based on [1].

|Class Value (used in `gistool`)	|Name					|Land Cover Description						|
|---------------------------------------|---------------------------------------|---------------------------------------------------------------|
|1					|Evergreen Needleleaf Forests		|Dominated by evergreen conifer trees (canopy>2m). Tree cover>60%.|
|2					|Evergreen Broadleaf Forests		|Dominated by evergreen broadleaf and palmate trees (canopy >2m). Tree cover >60%.|
|3					|Deciduous Needleleaf Forests		|Dominated by deciduous needleleaf (larch) trees (canopy >2m). Tree cover >60%.|
|4					|Deciduous Broadleaf Forests		|Dominated by deciduous broadleaf trees (canopy >2m). Tree cover >60%.|
|5					|Mixed Forests				|Dominated by neither deciduous nor evergreen (40-60% of each) tree type (canopy >2m). Tree cover >60%.|
|6					|Closed Shrublands			|Dominated by woody perennials (1-2m height) >60% cover.	|
|7					|Open Shrublands			|Dominated by woody perennials (1-2m height) 10-60% cover.	|
|8					|Woody Savannas 			|Tree cover 30-60% (canopy >2m).				|
|9					|Savannas				|Tree cover 10-30% (canopy >2m).				|
|10					|Grasslands				|Dominated by herbaceous annuals (<2m).				|
|11					|Permanent Wetlands			|Permanently inundated lands with 30-60% water cover and >10% vegetated cover.|
|12					|Croplands				|At least 60% of area is cultivated cropland.			|
|13					|Urban and Built-up Lands		|At least 30% impervious surface area including building materials, asphalt, and vehicles.|
|14					|Cropland/Natural Vegetation Mosaics	|Mosaics of small-scale cultivation 40-60% with natural tree, shrub, or herbaceous vegetation.|
|15					|Permanent Snow and Ice			|At least 60% of area is covered by snow and ice for at least 10 months of the year.|
|16					|Barren					|At least 60% of area is non-vegetated barren (sand, rock, soil) areas with less than 10% veg- etation.|
|17					|Water Bodies				|At least 60% of area is covered by permanent wa- ter bodies.	|
|255					|Unclassified				|Has not received a map label because of missing inputs.	|

Also, the details of the above table has been included in the following files: [modis_classes.csv](./modis_classes.csv).

