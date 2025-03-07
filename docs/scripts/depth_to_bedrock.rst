``Global Depth to Bedrock`` Geospatial Dataset
==============================================

In this file, the necessary technical details of the dataset is
explained.

Location of the ``Global Depth to Bedrock`` Dataset Files
---------------------------------------------------------

The ``Global Depth to Bedrock`` geospatial dataset files are located
under the following directory accessible from Digital Alliance (formerly
Compute Canada) Graham cluster:

.. code:: console

   /project/rpp-kshook/Model_Output/DTB # Graham's rpp-kshook allocation
   /work/comphyd_lab/data/geospatial-data/DTB # University of Calgary's ARC comphyd_lab allocation


And the structure of the files is as following:

.. code:: console

   /project/rpp-kshook/Model_Output/DTB
   ├── BDRICM_M_10km_ll.zip
   ├── BDRICM_M_1km_ll.zip
   ├── BDRICM_M_250m_ll.zip
   ├── BDRLOG_M_10km_ll.zip
   ├── BDRLOG_M_1km_ll.zip
   ├── BDRLOG_M_250m_ll.zip
   ├── BDTICM_M_10km_ll.zip
   ├── BDTICM_M_1km_ll.zip
   └── BDTICM_M_250m_ll.zip

Spatial and Temporal Extents
----------------------------

The spatial extent of this dataset covers longitudes from ``-180`` to
``+180`` degress and latitudes from ``-90`` to ``+90`` degress. This
dataset is static and does not vary with time.

Dataset Variables
-----------------

This variables of this dataset are detailed in the table below:

+---+-------------------------+-------------------------+--------------+
| # | Variable Name (used in  | Description             | Comments     |
|   | ``gistool``)            |                         |              |
+===+=========================+=========================+==============+
| 1 | BDRICM_M_10km_ll        | censored DTB [1]_ in    | 5-minute     |
|   |                         | ``cm``                  | resolution   |
+---+-------------------------+-------------------------+--------------+
| 2 | BDRLOG_M_10km_ll        | occurrence of R horizon | 5-minute     |
|   |                         | in ``%``                | resolution   |
+---+-------------------------+-------------------------+--------------+
| 3 | BDTICM_M_10km_ll        | absolute DTB in ``cm``  | 5-minute     |
|   |                         |                         | resolution   |
+---+-------------------------+-------------------------+--------------+
| 4 | BDRICM_M_1km_ll         | censored DTB in ``cm``  | 30-second    |
|   |                         |                         | resolution   |
+---+-------------------------+-------------------------+--------------+
| 5 | BDRLOG_M_1km_ll         | occurrence of R horizon | 30-second    |
|   |                         | in ``%``                | resolution   |
+---+-------------------------+-------------------------+--------------+
| 6 | BDTICM_M_1km_ll         | absolute DTB in ``cm``  | 30-second    |
|   |                         |                         | resolution   |
+---+-------------------------+-------------------------+--------------+
| 7 | BDRICM_M_250m_ll        | censored DTB in ``cm``  | 7.5-second   |
|   |                         |                         | resolution   |
+---+-------------------------+-------------------------+--------------+
| 8 | BDRLOG_M_250m_ll        | occurrence of R horizon | 7.5-second   |
|   |                         | in ``%``                | resolution   |
+---+-------------------------+-------------------------+--------------+
| 9 | BDTICM_M_250m_ll        | absolute DTB in ``cm``  | 7.5-second   |
|   |                         |                         | resolution   |
+---+-------------------------+-------------------------+--------------+

The following
`link <http://globalchange.bnu.edu.cn/research/dtbd.jsp>`__ and
`paper <http://onlinelibrary.wiley.com/doi/10.1002/2016MS000686/full>`__
provide extensive details of the mentioned variables.

.. [1]
   DTB: Depth to Bedrock
