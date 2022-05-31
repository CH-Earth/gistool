# Description
This repository contains scripts to process necessary GeoTIFF datasets. The general usage of the script (i.e., `./extract-geotiff.sh`) is as follows:

```console
Usage:
  extract-geotiff [options...]

Script options:
  -d, --dataset				GeoTIFF dataset of interest,
                                        currently available options are:
                                        'MODIS';'MERIT-Hydro';'SoilGridsV1';
					'SoilGridsV2';
  -i, --dataset-dir=DIR			The source path of the dataset file(s)
  -v, --variable=var1[,var2[...]]	If applicable, variables to process
  -o, --output-dir=DIR			Writes processed files to DIR
  -s, --start-date=DATE			If applicable, start date of the forcing data; optional
  -e, --end-date=DATE			If applicable, end date of the forcing data; optional
  -l, --lat-lims=REAL,REAL		Latitude's upper and lower bounds; optional
  -n, --lon-lims=REAL,REAL		Longitude's upper and lower bounds; optional
  -p, --shape-file=PATH			Path to the ESRI '.shp' file; optional
  -j, --submit-job			Submit the data extraction process as a job
					on the SLURM system; optional
  -t, --stats=stat1[,stat2[...]]	If applicable, extract the statistics of
  					interest, currently available options are:
					'min';'max';'mean';'majority';'minority';
					'median';'quantiles';'variety';'variance';
					'stdev';'coefficient_of_variation';'frac';
  -p, --prefix=STR			Prefix  prepended to the output files
  -c, --cache=DIR			Path of the cache directory; optional
  -E, --email=STR			E-mail when job starts, ends, and finishes; optional
  -V, --version				Show version
  -h, --help				Show this screen and exit
```


# Available Datasets
|#    |Dataset                        		   |Time Scale            |DOI                    |Description          |
|-----|--------------------------------------------|----------------------|-----------------------|---------------------|
|1    |MODIS			     		   |2000 - 2021           | 			  |[link](modis)	|
|  1.1|  `landcover` (MCD12Q1 v006)    		   |  Yearly (2000 - 2021)|			  |*ditto*		|
|2    |MERIT Hydro		     		   |Not Applicable (N/A)  |10.1029/2019WR024873   |[link](merit_hydro)	|
|  2.1|  `dir` (Flow Direction)	     		   |  N/A		  |*ditto*		  |*ditto*		|
|  2.2|  `elv` (Adjusted Elevation)    		   |  N/A		  |*ditto*		  |*ditto*		|
|  2.3|  `upa` (Upstream Drainage Area)		   |  N/A		  |*ditto*		  |*ditto*		|
|  2.4|  `upg` (Number of Upstream Drainage Pixels)|  N/A		  |*ditto*		  |*ditto*		|
|  2.5|  `wth` (River Width)			   |  N/A		  |*ditto*		  |*ditto*		|
|  2.6|  `hnd` (HAND-Height Above Nearest Drainage)|  N/A		  |*ditto*		  |*ditto*		|
|3    |Soil Grids (v1)				   |  N/A		  |*ditto*		  |[link](soil_grids_v1)|
|  3.1| *to be completed*		  	   |			  |			  |*ditto*		|
|4    |Soil Grids (v2)				   |  N/A		  |*ditto*		  |[link](soil_grids_v2)|
|  4.1| *to be completed*			   |			  |			  |*ditto*		|


# General Example 
As an example, follow the code block below. Please remember that you MUST have access to Graham cluster with Compute Canada (CC) and have access to `MERIT-Hydro` dataset. Also, remember to generate a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with GitHub in advance. Enter the following codes in your Graham shell as a test case:

```console
foo@bar:~$ git clone https://github.com/kasra-keshavarz/geotifftool # clone the repository
foo@bar:~$ cd ./geotifftool/ # always move to the repository's directory
foo@bar:~$ ./extract-geotiff.sh -h # view the usage message
foo@bar:~$ ./extract-geotiff.sh  --geotiff="MERIT-Hydro" \
                                 --dataset-dir="/project/rpp-kshook/Model_Output/WRF/CONUS/CTRL" \
                                 --output-dir="$HOME/scratch/conus_i_output/" \
                                 --start-date="2001-01-01 00:00:00" \
                                 --end-date="2001-12-31 23:00:00" \
                                 --lat-lims=49,51  \
                                 --lon-lims=-117,-115 \
                                 --variable=T2,PREC_ACC_NC,Q2,ACSWDNB,ACLWDNB,U10,V10,PSFC \
                                 --prefix="conus_i";
```
See the [example](./example) directory for real-world scripts for each GeoTIFF dataset included in this repository.


# New Datasets
If you are considering any new dataset to be added to the data repository, and subsequently the associated scripts added here, you can open a new ticket on the **Issues** tab of the current repository. Or, you can make a [Pull Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) on this repository with your own script.


# Support
Please open a new ticket on the **Issues** tab of the current repository in case of any problem.


# License
GeoTIFF Processing Workflow<br>
Copyright (C) 2022, University of Saskatchewan<br>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

