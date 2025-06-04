.. Copyright 2022-2025 University of Calgary, University of Saskatchewan
   and other gistool developers.

   SPDX-License-Identifier: (GPL-3.0-or-later)

.. _gistool-datasets:

========
Datasets
========
This page details the dataset recipes available with ``gistool``.

-------
Summary
-------
The following table lists available datasets, their DOI, and provides links to sections describing the dataset.

.. list-table:: 
   :header-rows: 1
   :widths: 5 20 15 10 25

   * - #
     - Dataset
     - Time Scale
     - CRS
     - DOI
   * - 1
     - MODIS
     - 2000 - 2021
     - 
     - 10.5067/MODIS/MCD12Q1.006
   * - 2
     - MERIT Hydro
     - Not Applicable (N/A)
     - 4326
     - 10.1029/2019WR024873
   * - 3
     - Soil Grids (v1)
     - Not Applicable (N/A)
     - 4326
     - 10.1371/journal.pone.0169748
   * - 4
     - Landsat NALCMS
     - 2010 and 2015
     - 4326
     - 10.3390/rs9111098
   * - 5
     - Global Depth to Bedrock
     - Not Applicable (N/A)
     - 
     - 10.1002/2016MS000686
   * - 6
     - USDA Soil Class
     - Not Applicable (N/A)
     - 4326
     - 10.4211/hs.1361509511e44adfba814f6950c6e742
   * - 7
     - Global Soil Dataset for Earth System Modelling (GSDE)
     - Not Applicable (N/A)
     - 4326
     - 10.1002/2013MS000293
   * - 8
     - Generic TIF Files
     - Any
     - Any
     - Multiple


---------------------
Detailed Descriptions
---------------------
.. toctree::
   :maxdepth: 2
   :caption: Contents:

   scripts/depth_to_bedrock.rst
   scripts/gsde.rst
   scripts/landsat.rst
   scripts/merit_hydro.rst
   scripts/modis.rst
   scripts/soil_class.rst
   scripts/soil_grids.rst
   scripts/generic-tif.rst

