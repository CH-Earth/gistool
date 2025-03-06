#!/bin/bash
#
# Geospatial Data Processing Workflow
# Copyright (C) 2023-2025, University of Calgary
# Copyright (C) 2022-2025, gistool developers
#
# This file is part of Geospatial Data Processing Workflow
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

# main help function
usage () {
  echo "Prepare environment for GISTOOL

Usage:
  install-env.sh HPCJSON [INSTALL_PATH]

Script arguments:
  HPCJSON             The JSON file describing the target HPC system
  INSTALL_PATH        The installation path for the environment required
                      for the tool, 
                        [defaults to \$HOME/.local/R/exact-extract-renv]

For bug reports, questions, and discussions open an issue
at https://github.com/CH-Earth/gistool/issues" >&1;

  exit 0;
}

# input arguments
cluster_json="$1"
install_path="$2"

# check whether JSON arguments is provided
if [[ -z "$cluster_json" ]]; then
  echo "$(basename $0): ERROR! HPC-specific JSON file missing"
  exit 1;
fi

# if $install_path is not provided, use default path
if [[ -n "$install_path" ]]; then
  install_path="${HOME}/.local/R/exact-extract-r/"
fi

# verbosity
echo "$(basename $0): Installing in $install_path"

# create install directories
mkdir -p $HOME/.local/R/library/
mkdir -p $install_path 
mkdir -p $HOME/.local/R/renv-env/

# assign relevant environment variables
export R_LIBS_USER=$HOME/.local/R/library
export R_LIBS_SITE=$HOME/.local/R/library
export RENV_PATHS_CACHE=$install_path

# find sqlite3 library path
export sqlite3_lib_path="$(pkgconf --variable=libdir sqlite3)"
echo "Sqlite3 library path is set to $sqlite3_lib_path"

# copy necessary renv.lock file from the tools repository
cp "$(dirname $0)/etc/renv/renv.lock" $HOME/.local/R/renv-env/

# download `renv` package from R's CRAN repository
# hardcoded to version 1.1.1
wget \
  -P "${RENV_PATHS_CACHE}" \
  "https://cran.r-project.org/src/contrib/Archive/renv/renv_1.1.1.tar.gz"

# change to the install_path (or renv's cache path)
cd "$RENV_PATHS_CACHE"

# install `renv_v1.1.1`
Rscript -e 'install.packages("renv_1.1.1.tar.gz", repos=NULL, type="source", quiet=TRUE, lib=Sys.getenv("R_LIBS_USER")[1]);'

# change to the local renv directory
cd "${HOME}/.local/R/renv-env/"

# install relevant packages
# first activate the enviornment for the first time
Rscript -e 'renv::activate();'
# reactivate and restore the `renv.lock` file
Rscript -e 'renv::activate(); renv::restore(prompt=FALSE); renv::isolate()'
# trap the exit code
exit_code=$?
# make an renv::isolate
Rscript -e 'renv::isolate()'

# if the `exit_code=0`, then print a success message
if [[ "$exit_code" -eq 0 ]]; then
  echo "$(basename $0): Enviornment successfully set up in $install_path"
fi

exit 0;
