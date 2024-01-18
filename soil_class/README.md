# `soil_class` Geospatial Dataset
In this file, the necessary technical details of the dataset is explained.

## Location of the `soil_class` Dataset Files
The `soil_class` geospatial dataset files are located under the following directory accessible from Digital Research Alliance of Canada (DRA, formerly Compute Canada) Graham cluster:

```console
/project/rpp-kshook/Model_Output/soil_classes # rpp-kshook allocation
/project/rrg-mclark/data/geospatial-data/soil_classes # rrg-mclark allocation
```

And the structure of the files is as following:

```console
/project/rpp-kshook/Model_Output/soil_classes
└── soil_classes.tif 
```

## Spatial and Temporal Extents
The spatial extent of this dataset covers longitudes from approximately `-180` to `+180` degress and latitudes from approximately `-90` to `+90` degress. This dataset is static and does not vary with time. 

## Dataset Variables
This variables of this dataset are detailed in the table below:

|#	|Variable Name (used in `gistool`)	|Description				|Comments	|
|-------|---------------------------------------|---------------------------------------|---------------|
|1      |soil_classes		        |USDA soil class 			|[link](https://www.hydroshare.org/resource/1361509511e44adfba814f6950c6e742/)|


# Other relevant information
## Soil Types
Below the land cover types for each values of the `.tif` files is detailed based on [1].

|Class Value (used in `gistool`)	|Soil Type			|
|---------------------------------------|-------------------------------|
|0					|no class assigned		|
|1					|Clay				|
|2					|Clay loam			|
|3					|Loam				|
|4					|Loamy sand			|
|5					|Sand				|
|6					|Sandy clay			|
|7					|Sandy clay loam		|
|8					|Sandy loam			|
|9					|Silt				|
|10					|Silty Clay			|
|11					|Silty clay loam		|
|12					|Silt loam			|

Also, the details of the above table has been included in the following files: [soil_classes.csv](./soil_classes.csv).

