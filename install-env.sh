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
usage() {
  echo "Prepare environment for GISTOOL

Usage:
  install-env.sh -j HPCJSON [-p INSTALL_PATH] [-h]

Options:
  -j HPCJSON       The JSON file describing the target HPC system (required)
  -p INSTALL_PATH  The installation path for the environment required
                   for the tool [default: \$HOME/.local/R/exact-extract-renv]
  -h               Show this help message and exit

For bug reports, questions, and discussions open an issue
at https://github.com/CH-Earth/gistool/issues" >&1;

  exit 0;
}

# Initialize variables
cluster_json=""
install_path="${HOME}/.local/R/exact-extract-renv"

# Parse command-line options
while getopts ":j:p:h" opt; do
  case ${opt} in
    j)
      cluster_json="$OPTARG"
      ;;
    p)
      install_path="$OPTARG"
      ;;
    h)
      usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
  esac
done

# Check whether JSON argument is provided
if [[ -z "$cluster_json" ]]; then
  echo "$(basename $0): ERROR! HPC-specific JSON file missing" >&2
  usage
fi

# Verbosity
echo "$(basename $0): Installing in $install_path"

# Create install directories
mkdir -p "$HOME/.local/R/library/"
mkdir -p "$install_path"
mkdir -p "$HOME/.local/R/renv-env/"

# Assign relevant environment variables
export R_LIBS_USER="$HOME/.local/R/library"
export R_LIBS_SITE="$HOME/.local/R/library"
export RENV_PATHS_CACHE="$install_path"

# Find sqlite3 library path
export sqlite3_lib_path="$(pkgconf --variable=libdir sqlite3)"
if [[ -z "$sqlite3_lib_path" ]]; then
  echo "$(basename $0): ERROR! sqlite3 library path could not be determined" >&2
  exit 1
fi
echo "Sqlite3 library path is set to $sqlite3_lib_path"

# Copy necessary renv.lock file from the tools repository
if ! cp "$(dirname $0)/etc/renv/renv.lock" "$HOME/.local/R/renv-env/"; then
  echo "$(basename $0): ERROR! Failed to copy renv.lock file" >&2
  exit 1
fi

# Download `renv` package from R's CRAN repository
# Hardcoded to version 1.1.1
if ! wget -P "${RENV_PATHS_CACHE}" "https://cran.r-project.org/src/contrib/Archive/renv/renv_1.1.1.tar.gz"; then
  echo "$(basename $0): ERROR! Failed to download renv package" >&2
  exit 1
fi

# Change to the install_path (or renv's cache path)
cd "$RENV_PATHS_CACHE" || { echo "$(basename $0): ERROR! Failed to change directory to $RENV_PATHS_CACHE" >&2; exit 1; }

# Install `renv_v1.1.1`
if ! Rscript -e 'install.packages("renv_1.1.1.tar.gz", repos=NULL, type="source", quiet=TRUE, lib=Sys.getenv("R_LIBS_USER")[1]);'; then
  echo "$(basename $0): ERROR! Failed to install renv package" >&2
  exit 1
fi

# Change to the local renv directory
cd "${HOME}/.local/R/renv-env/" || { echo "$(basename $0): ERROR! Failed to change directory to ${HOME}/.local/R/renv-env/" >&2; exit 1; }

# Install relevant packages
# First activate the environment for the first time
if ! Rscript -e 'renv::activate();'; then
  echo "$(basename $0): ERROR! Failed to activate renv environment" >&2
  exit 1
fi

# Reactivate and restore the `renv.lock` file
if ! Rscript -e 'renv::activate(); renv::restore(prompt=FALSE); renv::isolate()'; then
  echo "$(basename $0): ERROR! Failed to restore renv environment" >&2
  exit 1
fi

# Trap the exit code
exit_code=$?

# If the `exit_code=0`, then print a success message
if [[ "$exit_code" -eq 0 ]]; then
  echo "$(basename $0): Environment successfully set up in $install_path"
fi

exit $exit_code
