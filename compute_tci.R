# calculate TCI

library(rgdal)
library(sp)
library(raster)

# Script for MOD11B3

# Output mean imagery
#setwd("G:/MODIS_DOWN/MOD11B3_2")

dirs1 <- list.dirs(path="G:/MODIS_DOWN/MOD11B3_2", recursive = FALSE)
dirs2 <- list.dirs(path="G:/MODIS_DOWN/MOD11B3_2", recursive = FALSE, full.names = FALSE)

j <- 1

for (j in 1:length(dirs1)) {
  
  files <- list.files(path = dirs1[j],
                      pattern = "*LST_Day_6km.tif",
                      full.names = TRUE)
  
  i <- 1
  
  sta <- stack()
  
  for (i in 1:length(files)) {
    rast0 <- raster(files[i])
    sta <- addLayer(sta, rast0)
  }
  
  #sta0 <- stack(sta, bands = 1)
  #plot(sta0)
  
  #mean
  mean.stack <- mean(sta, na.rm = TRUE)
  #plot(mn.stack)
  filenm <- paste0("G:/MODIS_DOWN/MOD11B3_2/", dirs2[j], "_mean.tif")
  rf <- writeRaster(mean.stack, filename = filenm, format = "GTiff", overwrite = TRUE)
  
  #minimum
  min.stack <- min(sta, na.rm = TRUE)
  #plot(mn.stack)
  filenm <- paste0("G:/MODIS_DOWN/MOD11B3_2/", dirs2[j], "_min.tif")
  rf <- writeRaster(min.stack, filename = filenm, format = "GTiff", overwrite = TRUE)  
  
  #maximum
  max.stack <- max(sta, na.rm = TRUE)
  #plot(mn.stack)
  filenm <- paste0("G:/MODIS_DOWN/MOD11B3_2/", dirs2[j], "_max.tif")
  rf <- writeRaster(max.stack, filename = filenm, format = "GTiff", overwrite = TRUE)  
}

####
# Produce the datasets for TCI
####

k <- 1

count <- sprintf("%02d", 1:12)

for (k in 1:length(count)) {
  sta <- stack()
  list2 <- list.files(path=paste0("G:/MODIS_DOWN/MOD11B3_2/", count[k]), full.names = TRUE)
  minlst <- raster(paste0("G:/MODIS_DOWN/MOD11B3_2/", count[k], "_min.tif"))
  maxlst <- raster(paste0("G:/MODIS_DOWN/MOD11B3_2/", count[k], "_max.tif"))
  
  i <- 1
  for (i in 1:length(list2)) {
    rast1 <- raster(list2[i])
    tci <- ((maxlst - rast1) / (maxlst - minlst)) * 100
    #plot(tci)
    filename1 <- substr(list2[i],28,55)
    filename1 <- paste0("G:/MODIS_DOWN/MOD11B3_2/", filename1, ".TCI.tif")
    rp <- writeRaster(tci, filename = filename1, format = "GTiff", overwrite = TRUE)  
  }
}
