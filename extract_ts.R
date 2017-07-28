data.list <- list.files("G:/MODIS_DOWN/VHI", full.names = TRUE)

sta <- stack()

for (i in 1:length(data.list)) {
  rast0 <- raster(data.list[i])
  sta <- addLayer(sta, rast0)
}

a <- sta[500,1000] #subset dataset at x=500, y=1000
a.col <- colnames(a)
a.num <- as.numeric(a[1,]) #remove headers
a.df <- data.frame(a)
test2 <- melt(a.df)
test2 <- na.omit(test2)
#test2$variable <- as.numeric(substr(test2$variable, 2, 8))
test2$variable <- substr(test2$variable, 2, 8)