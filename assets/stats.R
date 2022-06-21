# reading arguments
args <- commandArgs(); 

# assigning variables to input arguments
exactextractr_cache_path <- args[6]; 
renv_source_package <- args[7]; 
virtual_env_path <- args[8];
working_dir_path <- args[9];
lockfile_path <- args[10];
vrt_path <- args[11];
shapefile_path <- args[12];
output_path <- args[13];
stats <- args[14];
quantiles <- args[15];

# set the working directory path
setwd(working_dir_path)

# set cache and initialize the environment, i.e., `renv`
Sys.setenv("RENV_PATHS_CACHE"=exactextractr_cache_path);
install.packages(renv_source_package, repos=NULL, type="source", quiet=TRUE);
renv::activate(virtual_env_path);
renv::restore(lockfile=lockfile_path, prompt=FALSE);

# produce necessary stats and print a csv file
r <- raster::raster(vrt_path);
p <- sf::st_read(shapefile_path, quiet=TRUE);
q <- as.double(unlist(strsplit(quantiles, ",")));
s <- unlist(strsplit(stats, ","));
df <- cbind(p[[1]], exactextractr::exact_extract(r, p, s, quantiles=q)); # assuming first column indicates ID
write.csv(df, output_path, row.names=FALSE, quote=FALSE)
