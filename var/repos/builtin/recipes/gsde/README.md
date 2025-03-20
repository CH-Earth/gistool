# `GSDE` Geospatial Dataset
In this file, the necessary technical details of the dataset is explained.

## Location of the `GSDE` Dataset Files
The `GSDE` geospatial dataset files are located under the following directory accessible from Digital Alliance (formerly Compute Canada) Graham cluster:

```console
/project/rpp-kshook/Model_Output/GSDE/download/gsde-30sec/
```

And the structure of the files is as following:

```console
/project/rpp-kshook/Model_Output/GSDE/download/gsde-30sec/
├──  BD1.zip
├──  BD2.zip
├──  BS1.zip
├──  BS2.zip
├──  CACO31.zip
├──  CACO32.zip
├──  CEC1.zip
├──  CEC2.zip
├──  CLAY1.zip
├──  CLAY2.zip
├──  ECE1.zip
├──  ECE2.zip
├──  ESP1.zip
├──  ESP2.zip
├──  EXAL1.zip
├──  EXAL2.zip
├──  EXCA1.zip
├──  EXCA2.zip
├──  EXH1.zip
├──  EXH2.zip
├──  EXK1.zip
├──  EXK2.zip
├──  EXMG1.zip
├──  EXMG2.zip
├──  EXNA1.zip
├──  EXNA2.zip
├──  GRAV1.zip
├──  GRAV2.zip
├──  GYP1.zip
├──  GYP2.zip
├──  OC1.zip
├──  OC2.zip
├──  PBR1.zip
├──  PBR2.zip
├──  PHCA1.zip
├──  PHCA2.zip
├──  PHH2O1.zip
├──  PHH2O2.zip
├──  PHK1.zip
├──  PHK2.zip
├──  PHO1.zip
├──  PHO2.zip
├──  PMEH1.zip
├──  PMEH2.zip
├──  PNZ1.zip
├──  PNZ2.zip
├──  POL1.zip
├──  POL2.zip
├──  SAND1.zip
├──  SAND2.zip
├──  SILT1.zip
├──  SILT2.zip
├──  TC1.zip
├──  TC2.zip
├──  TK1.zip
├──  TK2.zip
├──  TN1.zip
├──  TN2.zip
├──  TP1.zip
├──  TP2.zip
├──  TS1.zip
├──  TS2.zip
├──  VMC11.zip
├──  VMC12.zip
├──  VMC21.zip
├──  VMC22.zip
├──  VMC31.zip
└──  VMC32.zip
```

## Spatial and Temporal Extents

The spatial extent of this dataset covers longitudes from `-180` to `+180` degress and latitudes from `-90` to `+90` degress. This dataset is static and does not vary with time. 

## Dataset Variables
This variables of this dataset are detailed in the table below:

|#	|Variable Name (used in `gistool`)	|Description				|Units		|
|-------|---------------------------------------|---------------------------------------|---------------|
|1	|BD1					|Bulk density				|g/cm3		|
|2	|BD2					|Bulk density				|g/cm3		|
|3	|BS1					|Base Saturation			|%		|
|4	|BS2					|Base Saturation			|%		|
|5	|CACO31					|CaCO3					|% of weight	|
|6	|CACO32					|CaCO3					|% of weight	|
|7	|CEC1					|Caution Exchange Capacity		|cmol/kg	|
|8	|CEC2					|Caution Exchange Capacity		|cmol/kg	|
|9	|CLAY1					|Clay Content				|% of weight	|
|10	|CLAY2					|Clay Content				|% of weight	|
|11	|ECE1					|Electrical Conductivity		|ds/m		|
|12	|ECE2					|Electrical Conductivity		|ds/m		|
|13	|ESP1					|Exchangable sodium percentage		|% of weight	|
|14	|ESP2					|Exchangable sodium percentage		|% of weight	|
|15	|EXAL1					|Exchangable aluminum			|cmol/kg	|
|16	|EXAL2					|Exchangable aluminum			|cmol/kg	|
|17	|EXCA1					|Exchangable calcium			|cmol/kg	|
|18	|EXCA2					|Exchangable calcium			|cmol/kg	|
|19	|EXH1					|Exchangable Acidity			|cmol/kg	|
|20	|EXH2					|Exchangable Acidity			|cmol/kg	|
|21	|EXK1					|Exchangable Potassium			|cmol/kg	|
|22	|EXK2					|Exchangable Potassium			|cmol/kg	|
|23	|EXMG1					|Exchangable magnesium			|cmol/kg	|
|24	|EXMG2					|Exchangable magnesium			|cmol/kg	|
|25	|EXNA1					|Exchangable sodium			|cmol/kg	|
|26	|EXNA2					|Exchangable sodium			|cmol/kg	|
|27	|GRAV1					|Gravel content				|% of volume	|
|28	|GRAV2					|Gravel content				|% of volume	|
|29	|GYP1					|Gypsum					|% of weight	|
|30	|GYP2					|Gypsum					|% of weight	|
|31	|OC1					|Organic carbon				|% of weight	|
|32	|OC2					|Organic carbon				|% of weight	|
|33	|PBR1					|The amount of phosphorous using Bray1 method|ppm of weight|
|34	|PBR2					|The amount of phosphorous using Bray1 method|ppm of weight|
|35	|PHCA1					|pH(CaCl2)				|-		|
|36	|PHCA2					|pH(CaCl2)				|-		|
|37	|PHH2O1					|pH(H2O)				|-		|
|38	|PHH2O2					|pH(H2O)				|-		|
|39	|PHK1					|pH(KCl)				|-		|
|40	|PHK2					|pH(KCl)				|-		|
|41	|PHO1					|The amount of water soluble phosphorous|ppm of weight	|
|42	|PHO2					|The amount of water soluble phosphorous|ppm of weight	|
|43	|PMEH1					|The amount of phosphorous by Mehlich Method|ppm of weight|
|44	|PMEH2					|The amount of phosphorous by Mehlich Method|ppm of weight|
|45	|PNZ1					|Phosphorous retention by New Zealand method|% of weight|
|46	|PNZ2					|Phosphorous retention by New Zealand method|% of weight|
|47	|POL1					|The amount of phosphorous by Olsen method|ppm of weight|
|48	|POL2					|The amount of phosphorous by Olsen method|ppm of weight|
|49	|SAND1					|Sand content				|% of weight	|
|50	|SAND2					|Sand content				|% of weight	|
|51	|SILT1					|Silt content				|% of weight	|
|52	|SILT2					|Silt content				|% of weight	|
|53	|TC1					|Total carbon				|% of weight	|
|54	|TC2					|Total carbon				|% of weight	|
|55	|TK1					|Total potassium			|% of weight	|
|56	|TK2					|Total potassium			|% of weight	|
|57	|TN1					|Total N				|% of weight	|
|58	|TN2					|Total N				|% of weight	|
|59	|TP1					|Total phosphorous			|% of weight	|
|60	|TP2					|Total phosphorous			|% of weight	|
|61	|TS1					|Total S				|% of weight	|
|62	|TS2					|Total S				|% of weight	|
|63	|VMC11					|Volumetric water content at -10 kPa	|% of volume	|
|64	|VMC12					|Volumetric water content at -10 kPa	|% of volume	|
|65	|VMC21					|Volumetric water content at -33 kPa	|% of volume	|
|66	|VMC22					|Volumetric water content at -33 kPa	|% of volume	|
|67	|VMC31					|Volumetric water content at -1500 kPa	|% of volume	|
|68	|VMC32					|Volumetric water content at -1500 kPa	|% of volume	|

Further explanations could be found on the [dataset's webpage](http://globalchange.bnu.edu.cn/research/soilw).
