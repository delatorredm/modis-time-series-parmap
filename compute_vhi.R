library(raster)
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
  #filename <- paste0("G:/MODIS_DOWN/", nm[[1]][2], "_VHI_.tif")
  #rw <- writeRaster(vhi, 
  #                  filename = filename, 
  #                  format = "GTiff", 
  #                  NAflag = -99,
  #                  bandorder = 'BIL',
  #                  overwrite = TRUE)  
  
  # Write As BIL
  filename <- paste0("G:/MODIS_DOWN/BIL/", nm[[1]][2], "_VHI_.bil")
  rw <- writeRaster(vhi, 
                    filename = filename, 
                    format = "ENVI", 
                    NAflag = -99,
                    bandorder = 'BIL',
                    overwrite = TRUE)  
  
  # Write As BSQ
  filename <- paste0("G:/MODIS_DOWN/BSQ/", nm[[1]][2], "_VHI_.bsq")
  rw <- writeRaster(vhi, 
                    filename = filename, 
                    format = "ENVI", 
                    NAflag = -99,
                    bandorder = 'BSQ',
                    overwrite = TRUE)  
  
  # Write As BIP
  filename <- paste0("G:/MODIS_DOWN/BIP/", nm[[1]][2], "_VHI_.bip")
  rw <- writeRaster(vhi, 
                    filename = filename, 
                    format = "ENVI", 
                    NAflag = -99,
                    bandorder = 'BIP',
                    overwrite = TRUE)  
  
  # Write As IDRISI
  filename <- paste0("G:/MODIS_DOWN/IDRISI/", nm[[1]][2], "_VHI_.rst")
  rw <- writeRaster(vhi, 
                    filename = filename, 
                    format = "IDRISI", 
                    NAflag = -99,
                    overwrite = TRUE)  
  
}
