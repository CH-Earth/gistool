``MODIS`` Geospatial Dataset
============================

In this file, the necessary technical details of the dataset is
explained. It is worth noting that, ``MODIS`` has many products and here
only useful products for the Canadian hydrological community are
described.

Location of the ``MODIS`` Dataset Files
---------------------------------------

The ``MODIS`` geospatial dataset files are located under the following
directory accessible from multiple clusters:

.. code:: console

   # DRAC Graham HPC location
   /project/rpp-kshook/Climate_Forcing_Data/geospatial-data/MODIS/ #rpp-kshook allocation

   # UCalgary ARC HPC location
   /work/comphyd_lab/data/geospatial-data/MODIS #comphyd_lab allocation

   # Perdue University Anvil HPC location
   /anvil/datasets/geospatial # Anvil community storage

And the structure of the files is as following:

.. code:: console

   /path/to/dataset/dir/
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
   │   │   ├── .
   │   │   ├── MCD12Q1.A2002001.h35v10.006.2018143070809.hdf
   │   │   └── MCD12Q1.A2002001.h35v10.006.2018143070809.hdf.xml
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

Dataset Variables
-----------------

This dataset has 1 main variable that is described in the following
table:

+---+-----------------------------+---------------------------+----------+
| # | Variable Name (keyword for  | Description               | Comments |
|   | ``--variable``)             |                           |          |
+===+=============================+===========================+==========+
| 1 | ``MCD12Q1.006``             | Global land cover classes | This     |
|   |                             |                           | dataset  |
|   |                             |                           | is       |
|   |                             |                           | retired, |
|   |                             |                           | though   |
|   |                             |                           | a        |
|   |                             |                           | vailable |
|   |                             |                           | `Link    |
|   |                             |                           | <https:/ |
|   |                             |                           | /modis.g |
|   |                             |                           | sfc.nasa |
|   |                             |                           | .gov/dat |
|   |                             |                           | a/datapr |
|   |                             |                           | od/mod12 |
|   |                             |                           | .php>`__ |
+---+-----------------------------+---------------------------+----------+
| 2 | ``MCD12Q1.061``             | Global land cover classes | The most |
|   |                             |                           | up       |
|   |                             |                           | -to-date |
|   |                             |                           | MODIS    |
|   |                             |                           | L        |
|   |                             |                           | andcover |
|   |                             |                           | dataset  |
|   |                             |                           | `Link <h |
|   |                             |                           | ttps://l |
|   |                             |                           | pdaac.us |
|   |                             |                           | gs.gov/p |
|   |                             |                           | roducts/ |
|   |                             |                           | mcd12q1v |
|   |                             |                           | 061/>`__ |
+---+-----------------------------+---------------------------+----------+
| 3 | ``MOD16A2.061``             | Global ET/PET/LE/PLE Land | 8-day    |
|   |                             |                           | tim      |
|   |                             |                           | e-series |
|   |                             |                           | of       |
|   |                             |                           | ev       |
|   |                             |                           | apotrans |
|   |                             |                           | piration |
|   |                             |                           | (ET) and |
|   |                             |                           | its      |
|   |                             |                           | p        |
|   |                             |                           | otential |
|   |                             |                           | value    |
|   |                             |                           | (PET),   |
|   |                             |                           | Latent   |
|   |                             |                           | Heat     |
|   |                             |                           | flux     |
|   |                             |                           | (LE) and |
|   |                             |                           | its      |
|   |                             |                           | p        |
|   |                             |                           | otential |
|   |                             |                           | value    |
|   |                             |                           | (PLE)    |
|   |                             |                           | `link    |
|   |                             |                           | <https:/ |
|   |                             |                           | /modis.g |
|   |                             |                           | sfc.nasa |
|   |                             |                           | .gov/dat |
|   |                             |                           | a/datapr |
|   |                             |                           | od/mod16 |
|   |                             |                           | .php>`__ |
+---+-----------------------------+---------------------------+----------+
| 4 | ``MOD16A2GF.061``           | Global gap-filled         | 8-day    |
|   |                             | ET/PET/LE/PLE Land        | tim      |
|   |                             |                           | e-series |
|   |                             |                           | of       |
|   |                             |                           | ev       |
|   |                             |                           | apotrans |
|   |                             |                           | piration |
|   |                             |                           | (ET) and |
|   |                             |                           | its      |
|   |                             |                           | p        |
|   |                             |                           | otential |
|   |                             |                           | value    |
|   |                             |                           | (PET),   |
|   |                             |                           | Latent   |
|   |                             |                           | Heat     |
|   |                             |                           | flux     |
|   |                             |                           | (LE) and |
|   |                             |                           | its      |
|   |                             |                           | p        |
|   |                             |                           | otential |
|   |                             |                           | value    |
|   |                             |                           | (PLE)    |
|   |                             |                           | `link    |
|   |                             |                           | <https:/ |
|   |                             |                           | /modis.g |
|   |                             |                           | sfc.nasa |
|   |                             |                           | .gov/dat |
|   |                             |                           | a/datapr |
|   |                             |                           | od/mod16 |
|   |                             |                           | .php>`__ |
+---+-----------------------------+---------------------------+----------+
| 5 | ``MYD16A2.061``             | Global ET/PET/LE/PLE Aqua | 8-day    |
|   |                             |                           | tim      |
|   |                             |                           | e-series |
|   |                             |                           | of       |
|   |                             |                           | ev       |
|   |                             |                           | apotrans |
|   |                             |                           | piration |
|   |                             |                           | (ET) and |
|   |                             |                           | its      |
|   |                             |                           | p        |
|   |                             |                           | otential |
|   |                             |                           | value    |
|   |                             |                           | (PET),   |
|   |                             |                           | Latent   |
|   |                             |                           | Heat     |
|   |                             |                           | flux     |
|   |                             |                           | (LE) and |
|   |                             |                           | its      |
|   |                             |                           | p        |
|   |                             |                           | otential |
|   |                             |                           | value    |
|   |                             |                           | (PLE)    |
|   |                             |                           | `link    |
|   |                             |                           | <https:/ |
|   |                             |                           | /modis.g |
|   |                             |                           | sfc.nasa |
|   |                             |                           | .gov/dat |
|   |                             |                           | a/datapr |
|   |                             |                           | od/mod16 |
|   |                             |                           | .php>`__ |
+---+-----------------------------+---------------------------+----------+
| 6 | ``MOD16A3GF.061``           | Global gap-filled         | Annual   |
|   |                             | ET/PET/LE/PLE Land        | tim      |
|   |                             |                           | e-series |
|   |                             |                           | of       |
|   |                             |                           | ev       |
|   |                             |                           | apotrans |
|   |                             |                           | piration |
|   |                             |                           | (ET) and |
|   |                             |                           | its      |
|   |                             |                           | p        |
|   |                             |                           | otential |
|   |                             |                           | value    |
|   |                             |                           | (PET),   |
|   |                             |                           | Latent   |
|   |                             |                           | Heat     |
|   |                             |                           | flux     |
|   |                             |                           | (LE) and |
|   |                             |                           | its      |
|   |                             |                           | p        |
|   |                             |                           | otential |
|   |                             |                           | value    |
|   |                             |                           | (PLE)    |
|   |                             |                           | `link    |
|   |                             |                           | <https:/ |
|   |                             |                           | /modis.g |
|   |                             |                           | sfc.nasa |
|   |                             |                           | .gov/dat |
|   |                             |                           | a/datapr |
|   |                             |                           | od/mod16 |
|   |                             |                           | .php>`__ |
+---+-----------------------------+---------------------------+----------+

..

   [!WARNING] Currently, ``gistool`` **only** extracts ``ET`` values
   from ``MOD16A2.061``, ``MOD16A2GF.061``, ``MYD16A2.061``,
   ``MOD16A3GF.061`` variables. This is a shortcoming of ``gistool`` and
   will be resolved in the future versions.

Spatial and Temporal Extents
----------------------------

.. list-table:: Spatial and Temporal Extents
   :header-rows: 1
   :widths: 5 25 20 20 30

   * - #
     - Variable Name (keyword for `--variable`)
     - Longitude Extents
     - Latitude Extents
     - Temporal Extents
   * - 1
     - ``MCD12Q1.006``
     - ``-180`` |deg| to ``+180`` |deg|
     - ``-90`` |deg| to ``+90`` |deg|
     - ``2001-01-01`` to ``2020-01-01``
   * - 2
     - ``MCD12Q1.061``
     - ``-180`` |deg| to ``+180`` |deg|
     - ``-90`` |deg| to ``+90`` |deg|
     - ``2001-01-01`` to ``2022-01-01``
   * - 3
     - ``MOD16A2.061``
     - ``-180`` |deg| to ``+180`` |deg|
     - ``-90`` |deg| to ``+90`` |deg|
     - ``2021-01-01`` to ``2024-02-10``
   * - 4
     - ``MOD16A2GF.061``
     - ``-180`` |deg| to ``+180`` |deg|
     - ``-90`` |deg| to ``+90`` |deg|
     - ``2000-01-01`` to ``2023-12-27``
   * - 5
     - ``MYD16A2.061``
     - ``-180`` |deg| to ``+180`` |deg|
     - ``-90`` |deg| to ``+90`` |deg|
     - ``2021-01-01`` to ``2024-02-18``
   * - 6
     - ``MOD16A3GF.061``
     - ``-180`` |deg| to ``+180`` |deg|
     - ``-90`` |deg| to ``+90`` |deg|
     - ``2000-02-18`` to ``2023-01-01``

.. |deg| unicode:: U+00B0 .. degree symbol


..

   [!NOTE] The spatial resolution of MODIS datasets is 500m globally.

Other relevant information
--------------------------

Land Cover Types
~~~~~~~~~~~~~~~~

Below the land cover types for each values of the generated ``.tif``
files by ``gistool`` is detailed based on  [1]_. These classes apply to
the following variables of the MODIS datasets: 1. ``MCD12Q1.006`` and 2.
``MCD12Q1.061``.

+----------+------------------------------------+----------------------+
| Class    | Name                               | Land Cover           |
| Value    |                                    | Description          |
+==========+====================================+======================+
| 1        | Evergreen Needleleaf Forests       | Dominated by         |
|          |                                    | evergreen conifer    |
|          |                                    | trees (canopy>2m).   |
|          |                                    | Tree cover>60%.      |
+----------+------------------------------------+----------------------+
| 2        | Evergreen Broadleaf Forests        | Dominated by         |
|          |                                    | evergreen broadleaf  |
|          |                                    | and palmate trees    |
|          |                                    | (canopy >2m). Tree   |
|          |                                    | cover >60%.          |
+----------+------------------------------------+----------------------+
| 3        | Deciduous Needleleaf Forests       | Dominated by         |
|          |                                    | deciduous needleleaf |
|          |                                    | (larch) trees        |
|          |                                    | (canopy >2m). Tree   |
|          |                                    | cover >60%.          |
+----------+------------------------------------+----------------------+
| 4        | Deciduous Broadleaf Forests        | Dominated by         |
|          |                                    | deciduous broadleaf  |
|          |                                    | trees (canopy >2m).  |
|          |                                    | Tree cover >60%.     |
+----------+------------------------------------+----------------------+
| 5        | Mixed Forests                      | Dominated by neither |
|          |                                    | deciduous nor        |
|          |                                    | evergreen (40-60% of |
|          |                                    | each) tree type      |
|          |                                    | (canopy >2m). Tree   |
|          |                                    | cover >60%.          |
+----------+------------------------------------+----------------------+
| 6        | Closed Shrublands                  | Dominated by woody   |
|          |                                    | perennials (1-2m     |
|          |                                    | height) >60% cover.  |
+----------+------------------------------------+----------------------+
| 7        | Open Shrublands                    | Dominated by woody   |
|          |                                    | perennials (1-2m     |
|          |                                    | height) 10-60%       |
|          |                                    | cover.               |
+----------+------------------------------------+----------------------+
| 8        | Woody Savannas                     | Tree cover 30-60%    |
|          |                                    | (canopy >2m).        |
+----------+------------------------------------+----------------------+
| 9        | Savannas                           | Tree cover 10-30%    |
|          |                                    | (canopy >2m).        |
+----------+------------------------------------+----------------------+
| 10       | Grasslands                         | Dominated by         |
|          |                                    | herbaceous annuals   |
|          |                                    | (<2m).               |
+----------+------------------------------------+----------------------+
| 11       | Permanent Wetlands                 | Permanently          |
|          |                                    | inundated lands with |
|          |                                    | 30-60% water cover   |
|          |                                    | and >10% vegetated   |
|          |                                    | cover.               |
+----------+------------------------------------+----------------------+
| 12       | Croplands                          | At least 60% of area |
|          |                                    | is cultivated        |
|          |                                    | cropland.            |
+----------+------------------------------------+----------------------+
| 13       | Urban and Built-up Lands           | At least 30%         |
|          |                                    | impervious surface   |
|          |                                    | area including       |
|          |                                    | building materials,  |
|          |                                    | asphalt, and         |
|          |                                    | vehicles.            |
+----------+------------------------------------+----------------------+
| 14       | Cropland/Natural Vegetation        | Mosaics of           |
|          | Mosaics                            | small-scale          |
|          |                                    | cultivation 40-60%   |
|          |                                    | with natural tree,   |
|          |                                    | shrub, or herbaceous |
|          |                                    | vegetation.          |
+----------+------------------------------------+----------------------+
| 15       | Permanent Snow and Ice             | At least 60% of area |
|          |                                    | is covered by snow   |
|          |                                    | and ice for at least |
|          |                                    | 10 months of the     |
|          |                                    | year.                |
+----------+------------------------------------+----------------------+
| 16       | Barren                             | At least 60% of area |
|          |                                    | is non-vegetated     |
|          |                                    | barren (sand, rock,  |
|          |                                    | soil) areas with     |
|          |                                    | less than 10% veg-   |
|          |                                    | etation.             |
+----------+------------------------------------+----------------------+
| 17       | Water Bodies                       | At least 60% of area |
|          |                                    | is covered by        |
|          |                                    | permanent wa- ter    |
|          |                                    | bodies.              |
+----------+------------------------------------+----------------------+
| 255      | Unclassified                       | Has not received a   |
|          |                                    | map label because of |
|          |                                    | missing inputs.      |
+----------+------------------------------------+----------------------+

Also, the details of the above table has been included in the following
files: `modis_classes.csv <./modis_classes.csv>`__.

ET Values
~~~~~~~~~

Based on [2]_, the ET values calculated from the following variables
of the MODIS dataset come with a scale factor of ``0.1``. In other words,
``final_values = gistool_outputs * 0.1``:

1. ``MOD16A2.061``
2. ``MOD16A2GF.061``
3. ``MYD16A2.061``
4. ``MOD16A3GF.061``

.. [1] https://lpdaac.usgs.gov/products/mcd12q1v061/
.. [2] https://lpdaac.usgs.gov/products/mod16a3gfv061/
