library(reshape2)
library(rgdal)
library(sp)
library(raster)
data.list <- list.files("G:/MODIS_DOWN/EVI_TIMESAT_PROCESSED/", full.names = TRUE, pattern = "*_EVI$")

# Produce a RasterBrick/RasterStack of the Timesate Processed Datasets
sta <- stack()

for (i in 1:length(data.list)) {
  rast0 <- raster(data.list[i])
  sta <- addLayer(sta, rast0)
}

# Testing Code for Extraction of Coordinates
#a <- sta[500,1000] #subset dataset at x=500, y=1000
#a.col <- colnames(a)
#a.num <- as.numeric(a[1,]) #remove headers
#a.df <- data.frame(a)
#test2 <- melt(a.df)
#test2 <- na.omit(test2)
#test2$variable <- as.numeric(substr(test2$variable, 2, 8))
#test2$variable <- substr(test2$variable, 2, 8)

# Open the Shapefile Containing the Points for training and validation.
shp <- shapefile('G:/1000 sample points/3000_merged_intersect.shp')

#shp <- readOGR(dsn = 'G:/LC_subset/annual_SpatialJoin_kml.shp', 
#               layer = 'annual_SpatialJoin_kml.shp')
# Set the CRS first

shp.utm <- spTransform(shp, projection(rast0))

# Extract Coordinates from the Shapefile
coords <- coordinates(shp.utm)
coords.sta <- extract(sta, coords[,1:2]) # Subset the Long-Lat

#library(xlsx)
#write.xlsx(coords.sta, "G:/coords_v2.xlsx")

# Date Formatting of Strings from the RasterStack
p <- strptime(substr(colnames(coords.sta),10,16), format="%Y%j", tz="UTC")
p <- format(p, "%Y-%m-%d")

#
#library(ggplot2)
#testit <- function(x)
#{
#  p1 <- proc.time()
#  Sys.sleep(x)
#  proc.time() - p1 # The cpu usage should be negligible
#}

# Plotting for Quality Checking of All Points
x <- dim(coords)
for (i in 1:x[1]) {
  d <- data.frame(date = as.Date(p), evi = coords.sta[i,])
  meanevi <- mean(d$evi*0.0001)
  sdevi <-sd(d$evi*0.0001)
  
  png(paste0("G:/plots_list2/plot_", i, ".png"), 
      width = 15,
      height = 6,
      units = "in",
      res = 100)
  
  plot(d$date, d$evi*0.0001, type="l", ylim=c(-0.2, 1.0), xlab='', xaxt='n',ylab='EVI', 
       main=paste0(i, ', ', coords[i,1],', ',coords[i,2], ', mean = ', round(meanevi, digits = 4), ', sd = ', round(sdevi, digits = 4)))
  axis.Date(1, at = seq.Date(as.Date("2000-01-01"), as.Date("2017-01-01"), by='year'), format = "%Y")
  abline(v=as.numeric(seq.Date(as.Date("2000-01-01"), as.Date("2017-01-01"), by='year')), lty='dotted')
  abline(h=seq(-0.2, 1, by =0.2), lty='dotted')
  abline(h=mean(d$evi*0.0001), lty="dotdash", col="red")
  abline(h=sd(d$evi*0.0001), lty="dotdash", col="blue")
  dev.off()
  #Sys.sleep(5)
}

library(ggplot2)
ggplot(d, aes(date, evi*0.0001)) + 
  geom_line() +
  coord_cartesian(ylim=c(0,1)) +
  scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
  xlab("") + 
  ylab("EVI") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, vjust =1, hjust = 1))