``Soil Grids V1`` Geospatial Dataset
====================================

In this file, the necessary technical details of the dataset is
explained.

Location of the ``Soil Grids V1`` Dataset Files
-----------------------------------------------

The ``Soil Grids V1`` geospatial dataset files are located under the
following directory accessible from Digital Alliance (formerly Compute
Canada) Graham cluster:

.. code:: console

   /project/rpp-kshook/Model_Output/SoilGridsV1/soilgrids/former/2017-03-10/data

And the structure of the files is as following:

.. code:: console

   /project/rpp-kshook/Model_Output/SoilGridsV1/soilgrids/former/2017-03-10/data
   ├── ACDWRB_M_ss_250m_ll.tif 
   ├── ACDWRB_M_ss_250m_ll.tif.xml
   ├── AWCh1_M_sl1_250m_ll.tif
   ├── AWCh1_M_sl1_250m_ll.tif.xml
   ├── AWCh1_M_sl2_250m_ll.tif
   ├── AWCh1_M_sl2_250m_ll.tif.xml
   ├── %var_M_sl{%depth_level}_250m_ll.tif
   ├── %var_M_sl{%depth_level}_250m_ll.tif.xml
   ├── . 
   ├── .
   ├── .
   ├── AWCh1_M_sl7_250m_ll.tif
   ├── AWCh1_M_sl7_250m_ll.tif.xml
   ├── .
   ├── .
   ├── .
   ├── SNDPPT_M_sl7_250m_ll.tif
   ├── SNDPPT_M_sl7_250m_ll.tif.xml
   ├── WWP_M_sl7_250m_ll.tif
   ├── WWP_M_sl7_250m_ll.tif.xml
   ├── .
   ├── .
   ├── .
   ├── TAXNWRB_250m_ll.tif
   ├── TAXNWRB_250m_ll.tif.xml
   ├── TAXNWRB_Acric.Ferralsols_250m_ll.tif
   ├── TAXNWRB_Acric.Ferralsols_250m_ll.tif.xml
   ├── TAXNWRB_Acric.Plinthosols_250m_ll.tif
   ├── TAXNWRB_Acric.Plinthosols_250m_ll.tif.xml
   ├── .
   ├── .
   ├── .
   ├── TAXNWRB_%{short_group_name}_250m_ll.tif
   ├── TAXNWRB_%{short_group_name}_250m_ll.tif.xml
   ├── .
   ├── .
   ├── .
   ├── TAXNWRB_Vitric.Cryosols_250m_ll.tif
   ├── TAXNWRB_Vitric.Cryosols_250m_ll.tif.xml
   ├── TAXOUSDA_250m_ll.tif
   ├── TAXOUSDA_250m_ll.tif.xml
   ├── TAXOUSDA_Albolls_250m_ll.tif
   ├── TAXOUSDA_Albolls_250m_ll.tif.xml
   ├── .
   ├── .
   ├── .
   ├── TAXOUSDA_%{group_name}_250m_ll.tif
   ├── TAXOUSDA_${group_name}_250m_ll.tif.xml
   ├── .
   ├── .
   ├── .
   ├── TAXOUSDA_Xerults_250m_ll.tif
   └── TAXOUSDA_Xerults_250m_ll.tif.xml 

Spatial and Temporal Extents
----------------------------

The spatial extent of this dataset covers longitudes from ``-180`` to
``+180`` degress and latitudes from ``-90`` to ``+90`` degress. This
dataset is static and does not vary with time.

Dataset Variables
-----------------

This variables of this dataset are detailed in the table below:

+----+---------------------------+---------------------------+---------+
| #  | Variable Name (used in    | Description               | C       |
|    | ``gistool``)              |                           | omments |
+====+===========================+===========================+=========+
| 1  | BDRICM_M_250m_ll          | Depth to bedrock (R       |         |
|    |                           | horizon) up to 200 cm     |         |
+----+---------------------------+---------------------------+---------+
| 2  | BDRLOG_M_250m_ll          | Probability of occurrence |         |
|    |                           | of R horizon              |         |
+----+---------------------------+---------------------------+---------+
| 3  | BDTICM_M_250m_ll          | Absolute depth to bedrock |         |
|    |                           | (in cm)                   |         |
+----+---------------------------+---------------------------+---------+
| 4  | BLDFIE_M_sl1_250m_ll      | Bulk density (fine earth) |         |
|    |                           | in kg / cubic-meter       |         |
+----+---------------------------+---------------------------+---------+
| 5  | BLDFIE_M_sl2_250m_ll      | Bulk density (fine earth) |         |
|    |                           | in kg / cubic-meter       |         |
+----+---------------------------+---------------------------+---------+
| 6  | BLDFIE_M_sl3_250m_ll      | Bulk density (fine earth) |         |
|    |                           | in kg / cubic-meter       |         |
+----+---------------------------+---------------------------+---------+
| 7  | BLDFIE_M_sl4_250m_ll      | Bulk density (fine earth) |         |
|    |                           | in kg / cubic-meter       |         |
+----+---------------------------+---------------------------+---------+
| 8  | BLDFIE_M_sl5_250m_ll      | Bulk density (fine earth) |         |
|    |                           | in kg / cubic-meter       |         |
+----+---------------------------+---------------------------+---------+
| 9  | BLDFIE_M_sl6_250m_ll      | Bulk density (fine earth) |         |
|    |                           | in kg / cubic-meter       |         |
+----+---------------------------+---------------------------+---------+
| 10 | BLDFIE_M_sl7_250m_ll      | Bulk density (fine earth) |         |
|    |                           | in kg / cubic-meter       |         |
+----+---------------------------+---------------------------+---------+
| 11 | CECSOL_M_sl1_250m_ll      | Cation exchange capacity  |         |
|    |                           | of soil in cmolc/kg       |         |
+----+---------------------------+---------------------------+---------+
| 12 | CECSOL_M_sl2_250m_ll      | Cation exchange capacity  |         |
|    |                           | of soil in cmolc/kg       |         |
+----+---------------------------+---------------------------+---------+
| 13 | CECSOL_M_sl3_250m_ll      | Cation exchange capacity  |         |
|    |                           | of soil in cmolc/kg       |         |
+----+---------------------------+---------------------------+---------+
| 14 | CECSOL_M_sl4_250m_ll      | Cation exchange capacity  |         |
|    |                           | of soil in cmolc/kg       |         |
+----+---------------------------+---------------------------+---------+
| 15 | CECSOL_M_sl5_250m_ll      | Cation exchange capacity  |         |
|    |                           | of soil in cmolc/kg       |         |
+----+---------------------------+---------------------------+---------+
| 16 | CECSOL_M_sl6_250m_ll      | Cation exchange capacity  |         |
|    |                           | of soil in cmolc/kg       |         |
+----+---------------------------+---------------------------+---------+
| 17 | CECSOL_M_sl7_250m_ll      | Cation exchange capacity  |         |
|    |                           | of soil in cmolc/kg       |         |
+----+---------------------------+---------------------------+---------+
| 18 | CLYPPT_M_sl1_250m_ll      | Clay content (0-2 micro   |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 19 | CLYPPT_M_sl2_250m_ll      | Clay content (0-2 micro   |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 20 | CLYPPT_M_sl3_250m_ll      | Clay content (0-2 micro   |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 21 | CLYPPT_M_sl4_250m_ll      | Clay content (0-2 micro   |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 22 | CLYPPT_M_sl5_250m_ll      | Clay content (0-2 micro   |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 23 | CLYPPT_M_sl6_250m_ll      | Clay content (0-2 micro   |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 24 | CLYPPT_M_sl7_250m_ll      | Clay content (0-2 micro   |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 25 | CRFVOL_M_sl1_250m_ll      | Coarse fragments          |         |
|    |                           | volumetric in %           |         |
+----+---------------------------+---------------------------+---------+
| 26 | CRFVOL_M_sl2_250m_ll      | Coarse fragments          |         |
|    |                           | volumetric in %           |         |
+----+---------------------------+---------------------------+---------+
| 27 | CRFVOL_M_sl3_250m_ll      | Coarse fragments          |         |
|    |                           | volumetric in %           |         |
+----+---------------------------+---------------------------+---------+
| 28 | CRFVOL_M_sl4_250m_ll      | Coarse fragments          |         |
|    |                           | volumetric in %           |         |
+----+---------------------------+---------------------------+---------+
| 29 | CRFVOL_M_sl5_250m_ll      | Coarse fragments          |         |
|    |                           | volumetric in %           |         |
+----+---------------------------+---------------------------+---------+
| 30 | CRFVOL_M_sl6_250m_ll      | Coarse fragments          |         |
|    |                           | volumetric in %           |         |
+----+---------------------------+---------------------------+---------+
| 31 | CRFVOL_M_sl7_250m_ll      | Coarse fragments          |         |
|    |                           | volumetric in %           |         |
+----+---------------------------+---------------------------+---------+
| 32 | OCSTHA_M_sd1_250m_ll      | Soil organic carbon stock |         |
|    |                           | in tons per ha            |         |
+----+---------------------------+---------------------------+---------+
| 33 | OCSTHA_M_sd2_250m_ll      | Soil organic carbon stock |         |
|    |                           | in tons per ha            |         |
+----+---------------------------+---------------------------+---------+
| 34 | OCSTHA_M_sd3_250m_ll      | Soil organic carbon stock |         |
|    |                           | in tons per ha            |         |
+----+---------------------------+---------------------------+---------+
| 35 | OCSTHA_M_sd4_250m_ll      | Soil organic carbon stock |         |
|    |                           | in tons per ha            |         |
+----+---------------------------+---------------------------+---------+
| 36 | OCSTHA_M_sd5_250m_ll      | Soil organic carbon stock |         |
|    |                           | in tons per ha            |         |
+----+---------------------------+---------------------------+---------+
| 37 | OCSTHA_M_sd6_250m_ll      | Soil organic carbon stock |         |
|    |                           | in tons per ha            |         |
+----+---------------------------+---------------------------+---------+
| 38 | OCSTHA_M_30cm_250m_ll     | Soil organic carbon stock |         |
|    |                           | in tons per ha            |         |
+----+---------------------------+---------------------------+---------+
| 39 | OCSTHA_M_100cm_250m_ll    | Soil organic carbon stock |         |
|    |                           | in tons per ha            |         |
+----+---------------------------+---------------------------+---------+
| 40 | OCSTHA_M_200cm_250m_ll    | Soil organic carbon stock |         |
|    |                           | in tons per ha            |         |
+----+---------------------------+---------------------------+---------+
| 41 | OCDENS_M_sl1_250m_ll      | Soil organic carbon       |         |
|    |                           | density in kg per cubic-m |         |
+----+---------------------------+---------------------------+---------+
| 42 | OCDENS_M_sl2_250m_ll      | Soil organic carbon       |         |
|    |                           | density in kg per cubic-m |         |
+----+---------------------------+---------------------------+---------+
| 43 | OCDENS_M_sl3_250m_ll      | Soil organic carbon       |         |
|    |                           | density in kg per cubic-m |         |
+----+---------------------------+---------------------------+---------+
| 44 | OCDENS_M_sl4_250m_ll      | Soil organic carbon       |         |
|    |                           | density in kg per cubic-m |         |
+----+---------------------------+---------------------------+---------+
| 45 | OCDENS_M_sl5_250m_ll      | Soil organic carbon       |         |
|    |                           | density in kg per cubic-m |         |
+----+---------------------------+---------------------------+---------+
| 46 | OCDENS_M_sl6_250m_ll      | Soil organic carbon       |         |
|    |                           | density in kg per cubic-m |         |
+----+---------------------------+---------------------------+---------+
| 47 | OCDENS_M_sl7_250m_ll      | Soil organic carbon       |         |
|    |                           | density in kg per cubic-m |         |
+----+---------------------------+---------------------------+---------+
| 48 | ORCDRC_M_sl1_250m_ll      | Soil organic carbon       |         |
|    |                           | content (fine earth       |         |
|    |                           | fraction) in g per kg     |         |
+----+---------------------------+---------------------------+---------+
| 49 | ORCDRC_M_sl2_250m_ll      | Soil organic carbon       |         |
|    |                           | content (fine earth       |         |
|    |                           | fraction) in g per kg     |         |
+----+---------------------------+---------------------------+---------+
| 50 | ORCDRC_M_sl3_250m_ll      | Soil organic carbon       |         |
|    |                           | content (fine earth       |         |
|    |                           | fraction) in g per kg     |         |
+----+---------------------------+---------------------------+---------+
| 51 | ORCDRC_M_sl4_250m_ll      | Soil organic carbon       |         |
|    |                           | content (fine earth       |         |
|    |                           | fraction) in g per kg     |         |
+----+---------------------------+---------------------------+---------+
| 52 | ORCDRC_M_sl5_250m_ll      | Soil organic carbon       |         |
|    |                           | content (fine earth       |         |
|    |                           | fraction) in g per kg     |         |
+----+---------------------------+---------------------------+---------+
| 53 | ORCDRC_M_sl6_250m_ll      | Soil organic carbon       |         |
|    |                           | content (fine earth       |         |
|    |                           | fraction) in g per kg     |         |
+----+---------------------------+---------------------------+---------+
| 54 | ORCDRC_M_sl7_250m_ll      | Soil organic carbon       |         |
|    |                           | content (fine earth       |         |
|    |                           | fraction) in g per kg     |         |
+----+---------------------------+---------------------------+---------+
| 55 | PHIHOX_M_sl1_250m_ll      | Soil pH x 10 in H2O       |         |
+----+---------------------------+---------------------------+---------+
| 56 | PHIHOX_M_sl2_250m_ll      | Soil pH x 10 in H2O       |         |
+----+---------------------------+---------------------------+---------+
| 57 | PHIHOX_M_sl3_250m_ll      | Soil pH x 10 in H2O       |         |
+----+---------------------------+---------------------------+---------+
| 58 | PHIHOX_M_sl4_250m_ll      | Soil pH x 10 in H2O       |         |
+----+---------------------------+---------------------------+---------+
| 59 | PHIHOX_M_sl5_250m_ll      | Soil pH x 10 in H2O       |         |
+----+---------------------------+---------------------------+---------+
| 60 | PHIHOX_M_sl6_250m_ll      | Soil pH x 10 in H2O       |         |
+----+---------------------------+---------------------------+---------+
| 61 | PHIHOX_M_sl7_250m_ll      | Soil pH x 10 in H2O       |         |
+----+---------------------------+---------------------------+---------+
| 62 | PHIKCL_M_sl1_250m_ll      | Soil pH x 10 in KCl       |         |
+----+---------------------------+---------------------------+---------+
| 63 | PHIKCL_M_sl2_250m_ll      | Soil pH x 10 in KCl       |         |
+----+---------------------------+---------------------------+---------+
| 64 | PHIKCL_M_sl3_250m_ll      | Soil pH x 10 in KCl       |         |
+----+---------------------------+---------------------------+---------+
| 65 | PHIKCL_M_sl4_250m_ll      | Soil pH x 10 in KCl       |         |
+----+---------------------------+---------------------------+---------+
| 66 | PHIKCL_M_sl5_250m_ll      | Soil pH x 10 in KCl       |         |
+----+---------------------------+---------------------------+---------+
| 67 | PHIKCL_M_sl6_250m_ll      | Soil pH x 10 in KCl       |         |
+----+---------------------------+---------------------------+---------+
| 68 | PHIKCL_M_sl7_250m_ll      | Soil pH x 10 in KCl       |         |
+----+---------------------------+---------------------------+---------+
| 69 | SLTPPT_M_sl1_250m_ll      | Silt content (2-50 micro  |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 70 | SLTPPT_M_sl2_250m_ll      | Silt content (2-50 micro  |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 71 | SLTPPT_M_sl3_250m_ll      | Silt content (2-50 micro  |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 72 | SLTPPT_M_sl4_250m_ll      | Silt content (2-50 micro  |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 73 | SLTPPT_M_sl5_250m_ll      | Silt content (2-50 micro  |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 74 | SLTPPT_M_sl6_250m_ll      | Silt content (2-50 micro  |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 75 | SLTPPT_M_sl7_250m_ll      | Silt content (2-50 micro  |         |
|    |                           | meter) mass fraction in % |         |
+----+---------------------------+---------------------------+---------+
| 76 | SNDPPT_M_sl1_250m_ll      | Sand content (50-2000     |         |
|    |                           | micro meter) mass         |         |
|    |                           | fraction in %             |         |
+----+---------------------------+---------------------------+---------+
| 77 | SNDPPT_M_sl2_250m_ll      | Sand content (50-2000     |         |
|    |                           | micro meter) mass         |         |
|    |                           | fraction in %             |         |
+----+---------------------------+---------------------------+---------+
| 78 | SNDPPT_M_sl3_250m_ll      | Sand content (50-2000     |         |
|    |                           | micro meter) mass         |         |
|    |                           | fraction in %             |         |
+----+---------------------------+---------------------------+---------+
| 79 | SNDPPT_M_sl4_250m_ll      | Sand content (50-2000     |         |
|    |                           | micro meter) mass         |         |
|    |                           | fraction in %             |         |
+----+---------------------------+---------------------------+---------+
| 80 | SNDPPT_M_sl5_250m_ll      | Sand content (50-2000     |         |
|    |                           | micro meter) mass         |         |
|    |                           | fraction in %             |         |
+----+---------------------------+---------------------------+---------+
| 81 | SNDPPT_M_sl6_250m_ll      | Sand content (50-2000     |         |
|    |                           | micro meter) mass         |         |
|    |                           | fraction in %             |         |
+----+---------------------------+---------------------------+---------+
| 82 | SNDPPT_M_sl7_250m_ll      | Sand content (50-2000     |         |
|    |                           | micro meter) mass         |         |
|    |                           | fraction in %             |         |
+----+---------------------------+---------------------------+---------+
| 83 | TEXMHT_M_sl1_250m_ll      | Texture class (USDA       |         |
|    |                           | system)                   |         |
+----+---------------------------+---------------------------+---------+
| 84 | TEXMHT_M_sl2_250m_ll      | Texture class (USDA       |         |
|    |                           | system)                   |         |
+----+---------------------------+---------------------------+---------+
| 85 | TEXMHT_M_sl3_250m_ll      | Texture class (USDA       |         |
|    |                           | system)                   |         |
+----+---------------------------+---------------------------+---------+
| 86 | TEXMHT_M_sl4_250m_ll      | Texture class (USDA       |         |
|    |                           | system)                   |         |
+----+---------------------------+---------------------------+---------+
| 87 | TEXMHT_M_sl5_250m_ll      | Texture class (USDA       |         |
|    |                           | system)                   |         |
+----+---------------------------+---------------------------+---------+
| 88 | TEXMHT_M_sl6_250m_ll      | Texture class (USDA       |         |
|    |                           | system)                   |         |
+----+---------------------------+---------------------------+---------+
| 89 | TEXMHT_M_sl7_250m_ll      | Texture class (USDA       |         |
|    |                           | system)                   |         |
+----+---------------------------+---------------------------+---------+
| 90 | TAXNWRB_250m_ll           | WRB 2006 class            |         |
+----+---------------------------+---------------------------+---------+
| 91 | TAXNWRB                   | WRB 2006 class            |         |
|    | _Acric.Ferralsols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 92 | TAXNWRB_                  | WRB 2006 class            |         |
|    | Acric.Plinthosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 93 | TAXNWR                    | WRB 2006 class            |         |
|    | B_Albic.Arenosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 94 | TAXNW                     | WRB 2006 class            |         |
|    | RB_Albic.Luvisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 95 | TAXN                      | WRB 2006 class            |         |
|    | WRB_Alic.Nitisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 96 | TAXNWRB_                  | WRB 2006 class            |         |
|    | Aluandic.Andosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 97 | TAXN                      | WRB 2006 class            |         |
|    | WRB_Aric.Regosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 98 | TAXNWRB_                  | WRB 2006 class            |         |
|    | Calcaric.Regosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 99 | TAXNWRB_                  | WRB 2006 class            |         |
|    | Calcic.Chernozems_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 00 | B_Calcic.Gleysols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 01 | _Calcic.Gypsisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 02 | _Calcic.Histosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_C                 | WRB 2006 class            |         |
| 03 | alcic.Kastanozems_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 04 | B_Calcic.Luvisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 05 | B_Calcic.Solonetz_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 06 | _Calcic.Vertisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 07 | B_Cryic.Histosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 08 | B_Cutanic.Alisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_End               | WRB 2006 class            |         |
| 09 | ogleyic.Cambisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_End               | WRB 2006 class            |         |
| 10 | ogleyic.Planosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_F                 | WRB 2006 class            |         |
| 11 | erralic.Arenosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_F                 | WRB 2006 class            |         |
| 12 | erralic.Cambisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 13 | _Fibric.Histosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 14 | B_Gleyic.Luvisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNW                     | WRB 2006 class            |         |
| 15 | RB_Gleyic.Podzols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 16 | B_Gleyic.Solonetz_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_                  | WRB 2006 class            |         |
| 17 | Gypsic.Solonchaks_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 18 | B_Haplic.Acrisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.           | WRB 2006 class            |         |
| 19 | Acrisols..Alumic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.           | WRB 2006 class            |         |
| 20 | Acrisols..Ferric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic            | WRB 2006 class            |         |
| 21 | .Acrisols..Humic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Ha                | WRB 2006 class            |         |
| 22 | plic.Albeluvisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNW                     | WRB 2006 class            |         |
| 23 | RB_Haplic.Alisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 24 | B_Haplic.Andosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 25 | _Haplic.Arenosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.Are        | WRB 2006 class            |         |
| 26 | nosols..Calcaric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 27 | _Haplic.Calcisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.           | WRB 2006 class            |         |
| 28 | Calcisols..Sodic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 29 | _Haplic.Cambisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.Cam        | WRB 2006 class            |         |
| 30 | bisols..Calcaric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.Ca         | WRB 2006 class            |         |
| 31 | mbisols..Chromic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.Ca         | WRB 2006 class            |         |
| 32 | mbisols..Dystric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.C          | WRB 2006 class            |         |
| 33 | ambisols..Eutric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.           | WRB 2006 class            |         |
| 34 | Cambisols..Humic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.           | WRB 2006 class            |         |
| 35 | Cambisols..Sodic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_                  | WRB 2006 class            |         |
| 36 | Haplic.Chernozems_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 37 | B_Haplic.Cryosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_                  | WRB 2006 class            |         |
| 38 | Haplic.Ferralsols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.Fe         | WRB 2006 class            |         |
| 39 | rralsols..Rhodic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.Fer        | WRB 2006 class            |         |
| 40 | ralsols..Xanthic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 41 | _Haplic.Fluvisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.F          | WRB 2006 class            |         |
| 42 | luvisols..Arenic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.Flu        | WRB 2006 class            |         |
| 43 | visols..Calcaric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.Fl         | WRB 2006 class            |         |
| 44 | uvisols..Dystric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.F          | WRB 2006 class            |         |
| 45 | luvisols..Eutric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 46 | B_Haplic.Gleysols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.G          | WRB 2006 class            |         |
| 47 | leysols..Dystric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.           | WRB 2006 class            |         |
| 48 | Gleysols..Eutric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 49 | _Haplic.Gypsisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_H                 | WRB 2006 class            |         |
| 50 | aplic.Kastanozems_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 51 | _Haplic.Leptosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.L          | WRB 2006 class            |         |
| 52 | eptosols..Eutric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 53 | B_Haplic.Lixisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.L          | WRB 2006 class            |         |
| 54 | ixisols..Chromic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.           | WRB 2006 class            |         |
| 55 | Lixisols..Ferric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 56 | B_Haplic.Luvisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.L          | WRB 2006 class            |         |
| 57 | uvisols..Chromic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.           | WRB 2006 class            |         |
| 58 | Luvisols..Ferric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.           | WRB 2006 class            |         |
| 59 | Nitisols..Rhodic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 60 | _Haplic.Phaeozems_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.Pl         | WRB 2006 class            |         |
| 61 | anosols..Dystric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.P          | WRB 2006 class            |         |
| 62 | lanosols..Eutric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNW                     | WRB 2006 class            |         |
| 63 | RB_Haplic.Podzols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.R          | WRB 2006 class            |         |
| 64 | egosols..Dystric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.           | WRB 2006 class            |         |
| 65 | Regosols..Eutric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic            | WRB 2006 class            |         |
| 66 | .Regosols..Sodic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_                  | WRB 2006 class            |         |
| 67 | Haplic.Solonchaks_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.S          | WRB 2006 class            |         |
| 68 | olonchaks..Sodic._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 69 | B_Haplic.Solonetz_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 70 | _Haplic.Umbrisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 71 | _Haplic.Vertisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Haplic.V          | WRB 2006 class            |         |
| 72 | ertisols..Eutric._250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 73 | B_Hemic.Histosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Hi                | WRB 2006 class            |         |
| 74 | stic.Albeluvisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_Hy                | WRB 2006 class            |         |
| 75 | poluvic.Arenosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 76 | _Leptic.Cambisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 77 | B_Leptic.Luvisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 78 | _Leptic.Phaeozems_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 79 | B_Leptic.Regosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 80 | _Leptic.Umbrisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 81 | _Lithic.Leptosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_                  | WRB 2006 class            |         |
| 82 | Lixic.Plinthosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 83 | B_Luvic.Calcisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 84 | _Luvic.Chernozems_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 85 | B_Luvic.Phaeozems_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 86 | B_Luvic.Planosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 87 | _Luvic.Stagnosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 88 | B_Mollic.Gleysols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 89 | _Mollic.Leptosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 90 | B_Mollic.Solonetz_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 91 | _Mollic.Vertisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 92 | _Petric.Calcisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWR                    | WRB 2006 class            |         |
| 93 | B_Petric.Durisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_                  | WRB 2006 class            |         |
| 94 | Plinthic.Acrisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 95 | _Protic.Arenosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_                  | WRB 2006 class            |         |
| 96 | Rendzic.Leptosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 97 | _Sapric.Histosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB_                  | WRB 2006 class            |         |
| 98 | Solodic.Planosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 1  | TAXNWRB                   | WRB 2006 class            |         |
| 99 | _Stagnic.Luvisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXNWR                    | WRB 2006 class            |         |
| 00 | B_Turbic.Cryosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXNWRB_Um                | WRB 2006 class            |         |
| 01 | bric.Albeluvisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXNWRB_                  | WRB 2006 class            |         |
| 02 | Umbric.Ferralsols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXNWR                    | WRB 2006 class            |         |
| 03 | B_Umbric.Gleysols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXNWRB                   | WRB 2006 class            |         |
| 04 | _Vertic.Cambisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXNWR                    | WRB 2006 class            |         |
| 05 | B_Vertic.Luvisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXNW                     | WRB 2006 class            |         |
| 06 | RB_Vetic.Acrisols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXNWR                    | WRB 2006 class            |         |
| 07 | B_Vitric.Andosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXNWR                    | WRB 2006 class            |         |
| 08 | B_Vitric.Cryosols_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_250m_ll          | USDA 2014 class           |         |
| 09 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Albolls_250m_ll  | USDA 2014 class           |         |
| 10 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Aqualfs_250m_ll  | USDA 2014 class           |         |
| 11 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Aquands_250m_ll  | USDA 2014 class           |         |
| 12 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Aquents_250m_ll  | USDA 2014 class           |         |
| 13 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Aquepts_250m_ll  | USDA 2014 class           |         |
| 14 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Aquerts_250m_ll  | USDA 2014 class           |         |
| 15 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Aquods_250m_ll   | USDA 2014 class           |         |
| 16 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Aquolls_250m_ll  | USDA 2014 class           |         |
| 17 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Aquox_250m_ll    | USDA 2014 class           |         |
| 18 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Aquults_250m_ll  | USDA 2014 class           |         |
| 19 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Arents_250m_ll   | USDA 2014 class           |         |
| 20 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Argids_250m_ll   | USDA 2014 class           |         |
| 21 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Borolls_250m_ll  | USDA 2014 class           |         |
| 22 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Calcids_250m_ll  | USDA 2014 class           |         |
| 23 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Cambids_250m_ll  | USDA 2014 class           |         |
| 24 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Cryalfs_250m_ll  | USDA 2014 class           |         |
| 25 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Cryands_250m_ll  | USDA 2014 class           |         |
| 26 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Cryepts_250m_ll  | USDA 2014 class           |         |
| 27 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Cryids_250m_ll   | USDA 2014 class           |         |
| 28 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Cryods_250m_ll   | USDA 2014 class           |         |
| 29 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Cryolls_250m_ll  | USDA 2014 class           |         |
| 30 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Durids_250m_ll   | USDA 2014 class           |         |
| 31 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Fibrists_250m_ll | USDA 2014 class           |         |
| 32 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Fluvents_250m_ll | USDA 2014 class           |         |
| 33 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Folists_250m_ll  | USDA 2014 class           |         |
| 34 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Gelands_250m_ll  | USDA 2014 class           |         |
| 35 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Gelepts_250m_ll  | USDA 2014 class           |         |
| 36 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Gelods_250m_ll   | USDA 2014 class           |         |
| 37 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Gypsids_250m_ll  | USDA 2014 class           |         |
| 38 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Hemists_250m_ll  | USDA 2014 class           |         |
| 39 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Histels_250m_ll  | USDA 2014 class           |         |
| 40 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Humods_250m_ll   | USDA 2014 class           |         |
| 41 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Humults_250m_ll  | USDA 2014 class           |         |
| 42 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Ochrepts_250m_ll | USDA 2014 class           |         |
| 43 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Orthels_250m_ll  | USDA 2014 class           |         |
| 44 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Orthents_250m_ll | USDA 2014 class           |         |
| 45 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Orthods_250m_ll  | USDA 2014 class           |         |
| 46 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Perox_250m_ll    | USDA 2014 class           |         |
| 47 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | T                         | USDA 2014 class           |         |
| 48 | AXOUSDA_Psamments_250m_ll |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Rendolls_250m_ll | USDA 2014 class           |         |
| 49 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Salids_250m_ll   | USDA 2014 class           |         |
| 50 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Saprists_250m_ll | USDA 2014 class           |         |
| 51 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Torrands_250m_ll | USDA 2014 class           |         |
| 52 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Torrerts_250m_ll | USDA 2014 class           |         |
| 53 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Torrox_250m_ll   | USDA 2014 class           |         |
| 54 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Turbels_250m_ll  | USDA 2014 class           |         |
| 55 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Udalfs_250m_ll   | USDA 2014 class           |         |
| 56 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Udands_250m_ll   | USDA 2014 class           |         |
| 57 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Udepts_250m_ll   | USDA 2014 class           |         |
| 58 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Uderts_250m_ll   | USDA 2014 class           |         |
| 59 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Udolls_250m_ll   | USDA 2014 class           |         |
| 60 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Udox_250m_ll     | USDA 2014 class           |         |
| 61 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Udults_250m_ll   | USDA 2014 class           |         |
| 62 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Ustalfs_250m_ll  | USDA 2014 class           |         |
| 63 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Ustands_250m_ll  | USDA 2014 class           |         |
| 64 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Ustepts_250m_ll  | USDA 2014 class           |         |
| 65 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Usterts_250m_ll  | USDA 2014 class           |         |
| 66 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Ustolls_250m_ll  | USDA 2014 class           |         |
| 67 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Ustox_250m_ll    | USDA 2014 class           |         |
| 68 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Ustults_250m_ll  | USDA 2014 class           |         |
| 69 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Vitrands_250m_ll | USDA 2014 class           |         |
| 70 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Xeralfs_250m_ll  | USDA 2014 class           |         |
| 71 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Xerands_250m_ll  | USDA 2014 class           |         |
| 72 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Xerepts_250m_ll  | USDA 2014 class           |         |
| 73 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Xererts_250m_ll  | USDA 2014 class           |         |
| 74 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Xerolls_250m_ll  | USDA 2014 class           |         |
| 75 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | TAXOUSDA_Xerults_250m_ll  | USDA 2014 class           |         |
| 76 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh1_M_sl1_250m_ll       | Available soil water      |         |
| 77 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h1          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh1_M_sl2_250m_ll       | Available soil water      |         |
| 78 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h1          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh1_M_sl3_250m_ll       | Available soil water      |         |
| 79 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h1          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh1_M_sl4_250m_ll       | Available soil water      |         |
| 80 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h1          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh1_M_sl5_250m_ll       | Available soil water      |         |
| 81 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h1          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh1_M_sl6_250m_ll       | Available soil water      |         |
| 82 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h1          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh1_M_sl7_250m_ll       | Available soil water      |         |
| 83 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h1          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh2_M_sl1_250m_ll       | Available soil water      |         |
| 84 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h2          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh2_M_sl2_250m_ll       | Available soil water      |         |
| 85 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h2          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh2_M_sl3_250m_ll       | Available soil water      |         |
| 86 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h2          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh2_M_sl4_250m_ll       | Available soil water      |         |
| 87 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h2          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh2_M_sl5_250m_ll       | Available soil water      |         |
| 88 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h2          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh2_M_sl6_250m_ll       | Available soil water      |         |
| 89 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h2          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh2_M_sl7_250m_ll       | Available soil water      |         |
| 90 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h2          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh3_M_sl1_250m_ll       | Available soil water      |         |
| 91 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h3          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh3_M_sl2_250m_ll       | Available soil water      |         |
| 92 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h3          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh3_M_sl3_250m_ll       | Available soil water      |         |
| 93 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h3          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh3_M_sl4_250m_ll       | Available soil water      |         |
| 94 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h3          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh3_M_sl5_250m_ll       | Available soil water      |         |
| 95 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h3          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh3_M_sl6_250m_ll       | Available soil water      |         |
| 96 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h3          |         |
+----+---------------------------+---------------------------+---------+
| 2  | AWCh3_M_sl7_250m_ll       | Available soil water      |         |
| 97 |                           | capacity (volumetric      |         |
|    |                           | fraction) for h3          |         |
+----+---------------------------+---------------------------+---------+
| 2  | WWP_M_sl1_250m_ll         | Available soil water      |         |
| 98 |                           | capacity (volumetric      |         |
|    |                           | fraction) until wilting   |         |
|    |                           | point                     |         |
+----+---------------------------+---------------------------+---------+
| 2  | WWP_M_sl2_250m_ll         | Available soil water      |         |
| 99 |                           | capacity (volumetric      |         |
|    |                           | fraction) until wilting   |         |
|    |                           | point                     |         |
+----+---------------------------+---------------------------+---------+
| 3  | WWP_M_sl3_250m_ll         | Available soil water      |         |
| 00 |                           | capacity (volumetric      |         |
|    |                           | fraction) until wilting   |         |
|    |                           | point                     |         |
+----+---------------------------+---------------------------+---------+
| 3  | WWP_M_sl4_250m_ll         | Available soil water      |         |
| 01 |                           | capacity (volumetric      |         |
|    |                           | fraction) until wilting   |         |
|    |                           | point                     |         |
+----+---------------------------+---------------------------+---------+
| 3  | WWP_M_sl5_250m_ll         | Available soil water      |         |
| 02 |                           | capacity (volumetric      |         |
|    |                           | fraction) until wilting   |         |
|    |                           | point                     |         |
+----+---------------------------+---------------------------+---------+
| 3  | WWP_M_sl6_250m_ll         | Available soil water      |         |
| 03 |                           | capacity (volumetric      |         |
|    |                           | fraction) until wilting   |         |
|    |                           | point                     |         |
+----+---------------------------+---------------------------+---------+
| 3  | WWP_M_sl7_250m_ll         | Available soil water      |         |
| 04 |                           | capacity (volumetric      |         |
|    |                           | fraction) until wilting   |         |
|    |                           | point                     |         |
+----+---------------------------+---------------------------+---------+
| 3  | AWCtS_M_sl1_250m_ll       | Saturated water content   |         |
| 05 |                           | (volumetric fraction) for |         |
|    |                           | tS                        |         |
+----+---------------------------+---------------------------+---------+
| 3  | AWCtS_M_sl2_250m_ll       | Saturated water content   |         |
| 06 |                           | (volumetric fraction) for |         |
|    |                           | tS                        |         |
+----+---------------------------+---------------------------+---------+
| 3  | AWCtS_M_sl3_250m_ll       | Saturated water content   |         |
| 07 |                           | (volumetric fraction) for |         |
|    |                           | tS                        |         |
+----+---------------------------+---------------------------+---------+
| 3  | AWCtS_M_sl4_250m_ll       | Saturated water content   |         |
| 08 |                           | (volumetric fraction) for |         |
|    |                           | tS                        |         |
+----+---------------------------+---------------------------+---------+
| 3  | AWCtS_M_sl5_250m_ll       | Saturated water content   |         |
| 09 |                           | (volumetric fraction) for |         |
|    |                           | tS                        |         |
+----+---------------------------+---------------------------+---------+
| 3  | AWCtS_M_sl6_250m_ll       | Saturated water content   |         |
| 10 |                           | (volumetric fraction) for |         |
|    |                           | tS                        |         |
+----+---------------------------+---------------------------+---------+
| 3  | AWCtS_M_sl7_250m_ll       | Saturated water content   |         |
| 11 |                           | (volumetric fraction) for |         |
|    |                           | tS                        |         |
+----+---------------------------+---------------------------+---------+
| 3  | HISTPR_250m_ll            | Histosols probability     |         |
| 12 |                           | cumulative                |         |
+----+---------------------------+---------------------------+---------+
| 3  | SLGWRB_250m_ll            | Sodic soil grade          |         |
| 13 |                           |                           |         |
+----+---------------------------+---------------------------+---------+
| 3  | ACDWRB_M_ss_250m_ll       | Acid sub-soils grade      |         |
| 14 |                           |                           |         |
+----+---------------------------+---------------------------+---------+

.. note::


   Apart from the table above, a complete description of the variables is found in the following files available on the hosting `Soil Grids V1` website:

   1. `META_GEOTIFF_1B.csv <https://files.isric.org/soilgrids/former/2017-03-10/data/META_GEOTIFF_1B.csv>`_ - Details all the files included in the dataset.
   2. `TAXNWRB_250m_ll.tif.csv <https://files.isric.org/soilgrids/former/2017-03-10/data/TAXNWRB_250m_ll.tif.csv>`_ - Provides additional metadata.
   3. `TAXOUSDA_250m_ll.tif.csv <https://files.isric.org/soilgrids/former/2017-03-10/data/TAXOUSDA_250m_ll.tif.csv>`_ - Contains further details about the dataset.
