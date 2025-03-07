.. Copyright 2022-2024 University of Calgary, University of Saskatchewan
   and other gistool Developers.

   SPDX-License-Identifier: (GPL-3.0-or-later)

.. _main-gistool:

===========
Quick Start
===========

-----------
Example Run
-----------
As an example, follow the code block below. Please remember that you MUST
have access to the RDRSv2.1 model outputs on your HPC of interest. Enter
the following codes in your ``bash`` shell as a test case:

.. code:: console

   foo@bar:~$ git clone https://github.com/CH-Earth/gistool.git # clone the repository
   foo@bar:~$ cd ./gistool/ # move to the repository's directory
   foo@bar:~$ ./extract-dataset.sh -h # view the usage message
   foo@bar:~$ ./extract-dataset.sh  \
                --dataset="modis" \
                --dataset-dir="/work/comphyd_lab/data/geospatial-data/MODIS" \
                --output-dir="$HOME/test-gistool/modis" \
                --print-geotiff=true \
                --variable="MCD12Q1.061" \
                --prefix="test_" \
                --shape-file="/modify/the/path/to/polygons.shp" \
                --stat="frac" \
                --start-date="2020-01-01" \
                --end-date="2020-01-01" \
                --fid="COMID" \
                --cache='$TMPDIR' \
                --cluster=./etc/clusters/ucalgary-arc.json \
                -j;

The test case above is assumed to be run on the ``University of Calgary``'s
ARC cluster. Nevertheless, the test case can run on any cluster
where the data are available. View the details of the
`JSON configuration file <json>`_ to configure the tool for various HPCs.

There are a few examples available in the
`examples <https://github.com/CH-Earth/gistool/tree/main/examples>`_ directory of the repository.

Setup on Other Clusters
-----------------------
If you are attempting to set up Gistool on a cluster that is not supported
by default, you may need to manually install the required environment using
the ``install-env.sh`` script. This script automates the installation of
the necessary dependencies and tools for Gistool to function correctly on
your target HPC system.


Usage of ``install-env.sh``
~~~~~~~~~~~~~~~~~~~~~~~~~~~
The ``install-env.sh`` script requires a JSON file describing the target HPC
system and optionally allows you to specify an installation path. Below is
the help message for the script:

.. code-block:: bash

    Usage:
      install-env.sh -j HPCJSON [-p INSTALL_PATH] [-h]

    Options:
      -j HPCJSON       The JSON file describing the target HPC system (required)
      -p INSTALL_PATH  The installation path for the environment required
                       for the tool [default: \$HOME/.local/R/exact-extract-renv]
      -h               Show this help message and exit


Specifying the Installation Path in the Cluster JSON
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Once the environment is installed using the ``install-env.sh`` script,
you can use the installation path (specified with the ``-p`` option or
the default path) as the value for the ``lib-path`` entry in the
cluster-specific JSON file. This ensures that ``gistool`` can locate
the required libraries and dependencies during execution.

Example JSON entry:

.. code-block:: json

    {
        "lib-path": "/path/to/installation"
    }

Replace ``/path/to/installation`` with the actual installation path used
during the environment setup. This step is crucial for ensuring
compatibility and proper functionality of Gistool on your cluster.

The ``./etc/clusters/`` directory contains example 
`JSON configuration files <file:///json.rst>`_
that describe various HPC systems. These files can serve as
templates for creating your own cluster-specific JSON configuration.


----
Logs
----
The datasets logs are generated under the ``$HOME/.gistool`` directory, only
in cases where jobs are submitted to clusters' schedulers. If processing is
not submitted as a job, then the logs are printed on screen (i.e., ``stdout``).


-------
Support
-------
Please open a new ticket on the `Issues <https://github.com/CH-Earth/gistool/issues>`_
tab of this repository for support.
