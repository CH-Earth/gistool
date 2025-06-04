# `generic-tif` Geospatial Dataset
In this file, the necessary technical details of the dataset is explained.

## Location of the `generic-tif` Dataset Files
This dataset can process any GeoTIFF file and is designed to handle those
data bases without any specific structure. Current datasets that can be
processed by this recipe along with their HPC locations are listed below.
These paths can be used as values for the `--dataset-dir` argument:

```console
# UCalgary ARC Cluster
/work/comphyd_lab/data/geospatial-data/hawaii_dem/3mDEM # High resolution Hawaii DEM
/work/comphyd_lab/data/geospatial-data/iceland_dem # High resolution Iceland DEM
/work/comphyd_lab/data/geospatial-data/baker_creek_dem # High resolution Baker Creek DEM
/work/comphyd_lab/data/geospatial-data/wolf_creek_dem # High resolution Wolf Creek DEM
/work/comphyd_lab/data/geospatial-data/marmot_creek_dem # High resolution Marmot Creek DEM
```

## Dataset Variables
This variables of this dataset are detailed in the table below:

|#      |Dataset Directory| Variable Name(s) (value for `--variables`)   |Description                            |Comments       |
|-------|-----------------|----------------------------------------------|---------------------------------------|---------------|
|1      |Hawaii DEM       |`Big_Island.tif`, `Kahoolawe.tif`, `Kauai_Puuwai.tif`, `Lanai.tif`, `Maui.tif`, `Molokai.tif`, `Oahu.tif`|High-resolution DEM of Hawaii islands|[^1] |
|2      |Iceland DEM      |`merged_iceland_dem.tif`                      |High-resolution DEM of Iceland         |[^2]           |
|3      |Baker Creek DEM  |`baker-creek-10m-DEM.tif`                     |10-m LiDAR DEM of the Baker Creek River Basin, NWT, Canada|[^3]|
|4      |Wolf Creek DEM   |`wolf-creek-30m-DEM.tif`                      |30-m LiDAR DEM of the Wolf Creek River Basin, YT, Canada|[^4]|
|5      |Marmot Creek DEM |`marmot-creek-8m-DEM.tif`                     |8-m LiDAR DEM of the Marmot Creek River Basin, AB, Canada|[^5]|


[^1]: NOAA National Centers for Environmental Information (NCEI). (2021). Continuously Updated Digital Elevation Model (CUDEM) – Ninth Arc-Second Resolution Bathymetric-Topographic Tiles: Hawaii Data set (Tile Cluster 9428; fileIdentifier gov.noaa.ngdc.mgg.dem:299919). NOAA. Retrieved September 12, 2024, from https://noaa-nos-coastal-lidar-pds.s3.amazonaws.com/dem/NCEI_ninth_Topobathy_Hawaii_9428/index.html
[^2]: National Land Survey of Iceland (Landmælingar Íslands). (2016). ÍslandsDEM v1.0 [Digital Elevation Model of Iceland, 10 m resolution]. License: CC BY 4.0. Available at https://atlas.lmi.is/dem or https://dem.lmi.is/mapview/?application=DEM.
[^3]: Spence, C., Hedstrom, N. (2018). Baker Creek Research Catchment Hydrometeorological and Hydrological Data. Federated Research Data Repository. https://doi.org/10.20383/101.026
[^4]: Rasouli, K., Pomeroy, J. W., Janowicz, J. R., Williams, T. J., & Carey, S. K. (2019). A long-term hydrometeorological dataset (1993–2014) of a northern mountain basin: Wolf Creek Research Basin, Yukon Territory, Canada. Earth System Science Data, 11(1), 89-100, https://doi.org/10.5194/essd-11-89-2019
[^5]: Fang, X., Pomeroy, J. W., DeBeer, C. M., Harder, P., and Siemens, E. (2019). Hydrometeorological data from Marmot Creek Research Basin, Canadian Rockies. Earth Syst. Sci. Data, 11, 455–471, https://doi.org/10.5194/essd-11-455-2019.
