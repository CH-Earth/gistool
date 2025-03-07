.. Copyright 2022-2025 University of Calgary, University of Saskatchewan
   and other gistool Developers.

   SPDX-License-Identifier: (GPL-3.0-or-later)

.. _main-gistool:

========================================
Welcome to ``gistool``'s documentation!
========================================
``gistool`` is an HPC-indepenent workflow enabling end-users extracting
subsets from community geospatial datasets through a simple
command-line interface (CLI). The tool works at large with geospatial files,
but is not limited to any file format, structure, or dataset.

Through crowsourcing, ``gistool`` aims to enable end-users extract subsets
from any dataset available to the community members.

------------
Dependencies
------------

The tool requires several basic dependencies to function properly. Below is
a list of the minimum versions required for each dependency:

+------------+----------------+
| Dependency | Minimum Version|
+============+================+
| jq         | 1.6            |
+------------+----------------+
| m4         | 1.4.18         |
+------------+----------------+
| gdal       | 3.9.1          |
+------------+----------------+
| hdf        | 4.2.16         |
+------------+----------------+
| r          | 4.4.0          |
+------------+----------------+
| udunits    | 2.2.28         |
+------------+----------------+
| geos       | 3.12.0         |
+------------+----------------+
| proj       | 9.2.0          |
+------------+----------------+
| (p)7zip    | 16.02          |
+------------+----------------+
| getopt     | 2.38.1         |
+------------+----------------+
| getopts    | 4.2            |
+------------+----------------+
| bash       | 5              |
+------------+----------------+

These dependencies are essential for the tool to operate correctly. Ensure
that all dependencies are installed and meet the minimum version
requirements before using the tool.

--------------
User Interface
--------------
This repository contains scripts to process meteorological datasets in NetCDF 
file format. The general usage of the script (i.e., ``./extract-dataset.sh``)
is as follows:

.. code-block:: console

    Usage:
      extract-gis [options...]
    
    Script options:
      -d, --dataset                    Geospatial dataset of interest
      -i, --dataset-dir=DIR            The source path of the dataset file(s)
      -r, --crs=INT                    The EPSG code of interest; optional
                                       [defaults to 4326]
      -v, --variable=var1[,var2[...]]  If applicable, variables to process
      -o, --output-dir=DIR             Writes processed files to DIR
      -s, --start-date=DATE            If applicable, start date of the geospatial
                                       data; optional
      -e, --end-date=DATE              If applicable, end date of the geospatial
                                       data; optional
      -l, --lat-lims=REAL,REAL         Latitude's upper and lower bounds; optional
      -n, --lon-lims=REAL,REAL         Longitude's upper and lower bounds; optional
      -f, --shape-file=PATH            Path to the ESRI '.shp' file; optional
      -F, --fid=STR                    Column name representing elements of the
                                       Polygons to report statistics; optional
                                       [defaults to the first column]
      -j, --submit-job                 Submit the data extraction process as a job
                                       to HPC's scheduler; optional
      -t, --print-geotiff=BOOL         Extract the subsetted GeoTIFF file; optional
                                       [defaults to 'true']
      -a, --stat=stat1[,stat2[...]]    If applicable, extract the statistics of
                                       interest, currently available options are:
                                       'min';'max';'mean';'majority';'minority';
                                       'median';'quantile';'variety';'variance';
                                       'stdev';'coefficient_of_variation';'frac';
                                       'coords'; 'count'; 'sum'; optional
      -U, --include-na                 Include NA values in generated
                                       statistics, optional 
      -q, --quantile=q1[,q2[...]]      Quantiles of interest to be produced if 'quantile'
                                       is included in the '--stat' argument. The values
                                       must be comma delimited float numbers between
                                       0 and 1; optional [defaults to every 5th quantile]
      -p, --prefix=STR                 Prefix  prepended to the output files
      -b, --parsable                   Parsable SLURM message mainly used
                                       for chained job submissions
      -c, --cache=DIR                  Path of the cache directory; optional
      -E, --email=STR                  E-mail when job starts, ends, and fails; optional
      -C, --cluster=JSON                JSON file detailing cluster-specific details
      -V, --version                    Show version
      -h, --help                       Show this screen and exit


Use the navigation menu on the left to explore the ``gistool``'s
documentation!

.. toctree::
   :maxdepth: 2
   :caption: User Manual

   index
   quick_start
   json

   :maxdepth: 3
   :caption: Datasets

   datasets

   :maxdepth: 1
   :caption: License

   license
