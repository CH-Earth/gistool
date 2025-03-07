JSON Configuration File for HPC Module Systems
==============================================
This JSON file provides the configuration specifications for running ``gistool``
on any High-Performance Computing (HPC) system. It primarily describes the
scheduler, "unit" job specifications, and module systems required for successful
execution of the subset extraction process.

General View
------------
Below is an example of the ``JSON`` file that can be fed to ``gistool``
using the ``--cluster`` option.

.. code-block:: json

    {
        "scheduler": "slurm",
        "specs": {
            "cpus": 1,
            "time": "04:00:00",
            "nodes": 1,
            "partition": "cpu2023",
            "account": "",
            "mem": "8000M"
        },
        "modules": {
            "init": [
                ". /work/comphyd_lab/local/modules/spack/2024v5/lmod-init-bash",
                "module unuse $MODULEPATH",
                "module use /work/comphyd_lab/local/modules/spack/2024v5/modules/linux-rocky8-x86_64/Core/",
                "module -q purge"
            ],
            "compiler": "module -q load gcc/14.2.0",
            "sqlite3": "module -q load sqlite/3.46.0",
            "r": "module -q load r/4.4.1",
            "7z": "module -q load p7zip/17.05",
            "gdal": "module -q load gdal/3.9.2",
            "udunits": "module -q load udunits/2.2.28",
            "geos": "module -q load geos/3.12.2",
            "proj": "module -q load proj/9.4.1"
        },
        "lib-path": "/work/comphyd_lab/envs/r-env/"
    }


In brief, the ``JSON`` configuration file, describes the specifics about
the HPC of interest's scheduler type, the "unit" job executation details,
including the number of CPUs, time needed to finish the process of a
single job, the number of nodes where the executation happens, the
partition where executions should take place, the memory required per unit
job, and the account name of the user.

.. note::

   If an option in the JSON file is left empty, the tool will ignore that
   option during processing. Ensure that optional fields are left empty only
   if their functionality is not required on your HPC of choice.

In the following, the details of each section of the required ``JSON``
file are described.


File Structure
--------------
**Root Keys:**

- **scheduler**: Specifies the type of scheduler used by the HPC system. 
  In this case, the scheduler is set to ``slurm``. Currently available
  schedulers are: ``SLURM``, ``PBS Pro`` and ``IBM Spectrum LFS``. The 
  acceptable keyword for each scheduler in the ``JSON`` file is:

  +--------+-------------------+--------------+
  | Number | Scheduler Name    | Keyword      |
  +========+===================+==============+
  | 1      | SLURM             | ``slurm``    |
  +--------+-------------------+--------------+
  | 2      | PBS Pro           | ``pbs``      |
  +--------+-------------------+--------------+
  | 3      | IBM Spectrum LFS  | ``lfs``      |
  +--------+-------------------+--------------+

- **specs**: A dictionary containing the job specifications, such as
  allocated CPUs, runtime, memory, and other SLURM-specific parameters.

- **modules**: A dictionary defining the module system initialization
  commands and specific software modules required.


Details
-------

**Job Specifications**

- **specs**:
  Defines the job configuration to be submitted to the scheduler:
  
    .. list-table::
       :header-rows: 1

       * - Parameter
         - Description
       * - ``cpus``
         - Number of CPUs to allocate
       * - ``time``
         - Maximum runtime for the job in ``d-HH:MM:SS`` format
       * - ``nodes``
         - Number of nodes to allocate
       * - ``partition``
         - SLURM partition to use
       * - ``account``
         - HPC account name
       * - ``mem``
         - Memory allocation for the job in megabytes


**Modules**

- **modules**:
  This section defines the module system setup and required software.
  Please note that all arguments are optional and should be entered at the
  discretion of the end-user:


.. list-table::
   :header-rows: 1
   :widths: 15 85

   * - Module
     - Description
   * - ``init``
     - List of initialization commands for the module system.
   * - ``compiler``
     - Loads the compiler (e.g., ``module -q load gcc/14.2.0``)
   * - ``sqlite3``
     - Loads SQLite library (e.g., ``module -q load sqlite/3.46.0``)
   * - ``r``
     - Loads R programming language (e.g., ``module -q load r/4.4.1``)
   * - ``7z``
     - Loads 7-Zip compression tool (e.g., ``module -q load p7zip/17.05``)
   * - ``gdal``
     - Loads GDAL library for geospatial data processing (e.g., ``module -q load gdal/3.9.2``)
   * - ``udunits``
     - Loads UDUNITS library for unit conversions (e.g., ``module -q load udunits/2.2.28``)
   * - ``geos``
     - Loads GEOS library for geometric operations (e.g., ``module -q load geos/3.12.2``)
   * - ``proj``
     - Loads PROJ library for cartographic projections (e.g., ``module -q load proj/9.4.1``)


.. note::

   Users may add other options as needed. However, the order of the sections is 
   important for the proper execution of targeted module systems.


Usage
-----

This configuration file ensures that all necessary software and environment
settings are loaded before running ``gistool`` on an HPC system. Customize
the fields (e.g., ``account`` or ``partition``) based on your specific HPC setup.

Predefined HPC Configurations
-----------------------------
For ease of use, a few HPC systems have default configuration files included.
Users can refer to these pre-configured files as needed:

.. list-table:: Cluster Configuration Files
   :header-rows: 1

   * - **Cluster Name**
     - **Configuration File Path**
   * - Digital Research Alliance of Canada - Graham HPC
     - ``./etc/clusters/drac-graham.json``
   * - Perdue ACCESS Anvil HPC
     - ``./etc/clusters/perdue-anvil.json``
   * - UCalgary ARC HPC
     - ``./etc/clusters/ucalgary-arc.json``
   * - Environment and Climate Change Canada's (ECCC) Collab HPC
     - ``./etc/clusters/eccc-collab.json``
   * - Environment and Climate Change Canada's (ECCC) Science HPC
     - ``./etc/clusters/eccc-science.json``

Users may target these HPCs by using the ``--cluster`` option and specify
the path to each. For instance by using
``--cluster=./etc/clusters/drac-graham.json``, the tool uses the
pre-defined configuration file of the ``Digital Research Alliance of
Canada``'s ``Graham`` cluster to execute subset extraction processes.


Explanation of ``lib-path``
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``lib-path`` in the provided JSON file specifies the directory
where the R environment and its associated libraries are installed.
This path is crucial because it tells the system where to find the
necessary libraries and dependencies required for running R scripts
and related tools. In this case, the ``lib-path`` is set to
``/work/comphyd_lab/envs/r-env/``, indicating that all the R libraries
and dependencies are located in this directory.

Workflow to Build the Environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To build the R environment and set up the necessary libraries, you can
use the ``install-env.sh`` script available in the repository. This
script automates the process of installing the required R packages
and dependencies in the specified ``lib-path``.

1. **Clone the Repository**: First, clone the repository that contains 
the ``install-env.sh`` script.
2. **Run the Script**: Execute the ``install-env.sh`` script, which will
install the R environment and all necessary libraries in the directory
specified by ``lib-path``.

Further Documentation
~~~~~~~~~~~~~~~~~~~~~

For more detailed instructions on how to specify the installation path
in the cluster JSON and how to run the ``install-env.sh`` script, refer to
:doc:`quick_start`.

This section will guide you through the process of configuring the
``lib-path`` and running the installation script to set up your R environment
correctly.
