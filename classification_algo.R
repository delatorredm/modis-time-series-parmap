# Load libraries
library(data.table)
library(rgdal)
library(sp)
library(raster)

### Read shapefiles
shp <- shapefile("E:/DANIEL/Time_Series/1000 sample points/c3000_m_i_m_s.shp")

# Returns indices for classes of Single, Double and Perennial
idxSingle <- which(shp$TYPE == "Single")
idxDouble <- which(shp$TYPE == "Double")
idxPerennial <- which(shp$TYPE == "Perennial")

shp$TYPENUM[shp$TYPE == "Single"] <- 1
shp$TYPENUM[shp$TYPE == "Double"] <- 2
shp$TYPENUM[shp$TYPE == "Perennial"] <- 3

idxAll <- c(idxSingle, idxDouble)

shpSub <- shp[idxAll,]

# Open files containing EVI rasters
data.list <- list.files("G:/MODIS_DOWN/EVI_TIMESAT_PROCESSED/", full.names = TRUE, pattern = "*_EVI$")
sta <- stack()

for (i in 1:length(data.list)) {
  rast0 <- raster(data.list[i])
  sta <- addLayer(sta, rast0)
}

# Extract Coordinates from the Shapefile
coords <- coordinates(shpSub)
# Subset the Long-Lat
dfAll <- extract(sta, coords[,1:2]) 

### Code for Unsupervised Classification
#nr <- getValues(sta)
#nr.km <- kmeans(na.omit(nr), centers = 10, iter.max = 500, nstart = 3, algorithm="Lloyd")
#knr <- sta
#knr[] <- nr.km$cluster
#plot(knr, main = 'Unsupervised classification of EVI data')

## Code to implement Supervised Classification

#trainData <- shpSub
img <- sta

# Partition Data into Training 

## http://amsantac.co/blog/en/2015/11/28/classification-r.html

dfAll <- data.table(dfAll)
dfAll$TYPENUM <- shpSub$TYPENUM

library(caret)

training <- createDataPartition(dfAll$TYPENUM, p = 0.7, list = FALSE)
dfSubset <- dfAll[training,]  

# Model and Classification  
modFit <- train(as.factor(TYPENUM) ~ ., method = "svmLinear2", data = dfSubset)
beginCluster()
preds <- clusterR(img, raster::predict, args = list(model = modFit))
endCluster()
plot(preds)

# Accuracy Assessment
testShp <- shpSub[as.numeric(-training),]
testCoords <- coordinates(testShp)
testValues <- extract(preds, testCoords[, 1:2]) # Predicted
testTrueValues <- testShp$TYPENUM # Reference
confusionMatrix(testValues, reference = testTrueValues) # Confusion Matrix