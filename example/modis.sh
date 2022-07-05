#!/bin/bash

# Geospatial Dataset Processing Workflow
# Copyright (C) 2022, University of Saskatchewan
#
# This file is part of Meteorological Data Processing Workflow
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
# pfaf 71 (Saskatchewan-Nelson System) from the MODIS landcover rasters.

# Always run call the script in the root directory of this repository
cd ..
echo "The current directory is: $(pwd)"

# first download a sample shapefile
wget -m -nd -A "cat_pfaf_67_MERIT_Hydro_v07_Basins_v01_bugfix1.*" \
		"http://hydrology.princeton.edu/data/mpan/MERIT_Basins/MERIT_Hydro_v07_Basins_v01_bugfix1/pfaf_level_02/"

./extract-geotiff.sh --dataset="modis" \
  --dataset-dir="/project/rpp-kshook/Model_Output/MODIS/" \
  --variable="MCD12Q1.006" \
  --start-date="2001-01-01" \
  --end-date="2002-01-01" \
  --shape-file="./cat_pfaf_71_MERIT_Hydro_v07_Basins_v01_bugfix1.shp" \
  --print-geotiff=true \
  --output-dir="$HOME/scratch/modis-test/" \
  --prefix="test_" \
  --stat="majority,minority,frac" \
  -j;

