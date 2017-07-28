library(tools)
# Calculate VHI

tci.list <- list.files("G:/MODIS_DOWN/MOD11B3_2/TCI", full.names = TRUE)
vci.list <- list.files("G:/MODIS_DOWN/MOD13A3_2/VCI", full.names = TRUE)

list <- list.files("G:/MODIS_DOWN/MOD13A3_2/VCI")

# Open the files
i <- 1

for (i in 1: length(vci.list)) {
  nm <- strsplit(list[i], "[.]")
  tci.data <- raster(tci.list[i])
  vci.data <- raster(vci.list[i])
  a <- 0.5
  vhi <- (a*tci.data) + ((1-a)*vci.data)
  plot(vhi)
  filename <- paste0("G:/MODIS_DOWN/", nm[[1]][2], ".VHI.tif")
  rw <- writeRaster(vhi, filename = filename, format = "GTiff", overwrite = TRUE)  
}
