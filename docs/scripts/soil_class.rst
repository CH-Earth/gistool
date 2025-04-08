``soil_class`` Geospatial Dataset
=================================

In this file, the necessary technical details of the dataset is
explained.

Location of the ``soil_class`` Dataset Files
--------------------------------------------

The ``soil_class`` geospatial dataset files are located under the
following directory accessible from multiple clusters:

.. code:: console

   # DRAC Graham HPC location
   /project/rpp-kshook/Model_Output/soil_classes # rpp-kshook allocation

   # UCalgary ARC HPC location
   /work/comphyd_lab/data/geospatial-data/soil_classes # comphyd_lab allocation

And the structure of the files is as following:

.. code:: console

   /path/to/dataset/dir/
   └── soil_classes.tif 

Spatial and Temporal Extents
----------------------------

The spatial extent of this dataset covers longitudes from approximately
``-180`` to ``+180`` degress and latitudes from approximately ``-90`` to
``+90`` degress. This dataset is static and does not vary with time.

Dataset Variables
-----------------

This variables of this dataset are detailed in the table below:

+----+---------------------------+---------------------------+---------+
| #  | Variable Name (used in    | Description               | C       |
|    | ``gistool``)              |                           | omments |
+====+===========================+===========================+=========+
| 1  | soil_classes              | USDA soil class           | `li     |
|    |                           |                           | nk <htt |
|    |                           |                           | ps://ww |
|    |                           |                           | w.hydro |
|    |                           |                           | share.o |
|    |                           |                           | rg/reso |
|    |                           |                           | urce/13 |
|    |                           |                           | 6150951 |
|    |                           |                           | 1e44adf |
|    |                           |                           | ba814f6 |
|    |                           |                           | 950c6e7 |
|    |                           |                           | 42/>`__ |
+----+---------------------------+---------------------------+---------+

Other relevant information
--------------------------

Soil Types
~~~~~~~~~~

Below the land cover types for each values of the ``.tif`` files is
detailed based on [1].

+---------------------------------------+------------------------------+
| Class Value (used in ``gistool``)     | Soil Type                    |
+=======================================+==============================+
| 0                                     | no class assigned            |
+---------------------------------------+------------------------------+
| 1                                     | Clay                         |
+---------------------------------------+------------------------------+
| 2                                     | Clay loam                    |
+---------------------------------------+------------------------------+
| 3                                     | Loam                         |
+---------------------------------------+------------------------------+
| 4                                     | Loamy sand                   |
+---------------------------------------+------------------------------+
| 5                                     | Sand                         |
+---------------------------------------+------------------------------+
| 6                                     | Sandy clay                   |
+---------------------------------------+------------------------------+
| 7                                     | Sandy clay loam              |
+---------------------------------------+------------------------------+
| 8                                     | Sandy loam                   |
+---------------------------------------+------------------------------+
| 9                                     | Silt                         |
+---------------------------------------+------------------------------+
| 10                                    | Silty Clay                   |
+---------------------------------------+------------------------------+
| 11                                    | Silty clay loam              |
+---------------------------------------+------------------------------+
| 12                                    | Silt loam                    |
+---------------------------------------+------------------------------+

Also, the details of the above table has been included in the following
files: `soil_classes.csv <./soil_classes.csv>`__.
