#!/bin/bash

# Geospatial Dataset Processing Workflow
# Copyright (C) 2022, University of Saskatchewan
#
# This file is part of the Geospatial Dataset Processing Workflow
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This is a simple example to extract common statistics for the 
# pfaf 71 - Saskatchewan-Nelson System Shapefiles of Landsat landcover
# from the MERIT-Hydro rasters.

# Always call the script in the root directory of this repository
cd ..
echo "The current directory is: $(pwd)"

# first download a sample shapefile - could be any shapefile
wget -m -nd -nv -q -A "cat_pfaf_71_MERIT_Hydro_v07_Basins_v01_bugfix1.*" \
     "http://hydrology.princeton.edu/data/mpan/MERIT_Basins/MERIT_Hydro_v07_Basins_v01_bugfix1/pfaf_level_02/"; 


# Example 1: implement subsetting and zonal statistics
./extract-gis.sh --dataset="landsat" \
  --dataset-dir="/project/rpp-kshook/Model_Output/Landsat/" \
  --variable="land-cover" \
  --shape-file="$(pwd)/cat_pfaf_71_MERIT_Hydro_v07_Basins_v01_bugfix1.shp" \
  --print-geotiff=true \
  --output-dir="$HOME/scratch/landsat-test/" \
  --prefix="landsat_test_" \
  --start-date=2010 \
  --end-date=2015 \
  --stat="majority,minority,frac" \
  --email=your-email@company.ca \
  -j;

# Example 2: implement zonal statistics
./extract-gis.sh --dataset="landsat" \
  --dataset-dir="/project/rpp-kshook/Model_Output/Landsat/" \
  --variable="land-cover-change" \
  --shape-file="$(pwd)/cat_pfaf_71_MERIT_Hydro_v07_Basins_v01_bugfix1.shp" \
  --print-geotiff=false \
  --output-dir="$HOME/scratch/landsat-test/" \
  --prefix="landsat_test_" \
  --stat="majority,minority,frac" \
  --email=your-email@company.ca \
  -j;
