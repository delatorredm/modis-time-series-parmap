##This script to extract the scientific datasets from MOD11B3 and MOD13A3.

# Script for MOD13A3
setwd("G:/MODIS_DOWN/MOD13A3_1")


#gdalinfo("MOD11B3.A2015274.hdf")
#sds <- get_subdatasets("MOD13A3.A2000032.hdf")
#sds

#gdal_translate(sds[1], dst_dataset = "MOD13A3.A2000032.tif")

# Load and plot the new .tif

#rast <- raster("MOD13A3.A2017121.1_km_monthly_EVI.tif")
#plot(rast)

# For batch processing
files <- dir(pattern = ".hdf")
files


filename <- substr(files,9,16)
filename <- paste0("MOD13A3.", filename, ".1_km_monthly_EVI", ".tif")
filename

i <- 1

for (i in 1:length(filename)){
  sds <- get_subdatasets(files[i])
  gdal_translate(sds[2], dst_dataset = filename[i])
}


filename <- substr(files,9,16)
filename <- paste0("MOD13A3.", filename, ".1_km_monthly_pixel_reliability", ".tif")
filename

i <- 1

for (i in 1:length(filename)){
  sds <- get_subdatasets(files[i])
  gdal_translate(sds[11], dst_dataset = filename[i])
}

# Script for MOD11B3
setwd("G:/MODIS_DOWN/MOD11B3_1")

files <- dir(pattern = ".hdf")
files


filename <- substr(files,9,16)
filename <- paste0("MOD11B3.", filename, ".LST_Day_6km", ".tif")
filename

i <- 1

for (i in 1:length(filename)){
  sds <- get_subdatasets(files[i])
  gdal_translate(sds[1], dst_dataset = filename[i])
}


rast <- raster("MOD13A3.A2017121.1_km_monthly_EVI.tif")
plot(rast)

#rast <- raster("MOD13A3.A2010182.1_km_monthly_pixel_reliability.tif")
#plot(rast)

p <- shapefile('C:\\Users\\User\\Desktop\\NSO_Provincial.shp')
plot(p, add=TRUE)