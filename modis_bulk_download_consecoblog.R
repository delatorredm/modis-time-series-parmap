# Codes from https://conservationecology.wordpress.com/2014/08/11/bulk-downloading-and-analysing-modis-data-in-r/

# -----------------------------------------------------------------------------
# Using the MODISTools library to extract a single point time-series profile
library(MODISTools)
# MODISTools requires you to make a query data.frame
coord <- c(-3.223774, 37.424605) # Coordinates south of Mount Kilimanjaro
product <- "MOD13Q1"
bands <- c("250m_16_days_EVI","250m_16_days_pixel_reliability") # What to query. You can get the names via GetBands
savedir <- getwd() # You can save the downloaded File in a specific folder
pixel <- c(0,0) # Get the central pixel only (0,0) or a quadratic tile around it
period <- data.frame(lat=coord[1],long=coord[2],start.date=2001,end.date=2016,id=1)
# To download the pixels
MODISSubsets(LoadDat = period,Products = product,Bands = bands,Size = pixel,SaveDir = savedir,StartDate = T)
MODISSummaries(LoadDat = period,FileSep = ",", Product = "MOD13Q1", Bands = "250m_16_days_EVI",ValidRange = c(-2000,10000), NoDataFill = -3000, ScaleFactor = 0.0001,StartDate = TRUE,Yield = T,Interpolate = T, QualityScreen = TRUE, QualityThreshold = 0,QualityBand = "250m_16_days_pixel_reliability")
# Finally read the output
read.table("MODIS_Summary_MOD13Q1_2017-06-07_h11-m50-s22.csv",header = T,sep = ",")


# -----------------------------------------------------------------------------
# Using the MODIS library to 
library(MODIS)
dates <- as.POSIXct( as.Date(c("01/05/2014","31/05/2014"),format = "%d/%m/%Y") )
dates2 <- transDate(dates[1],dates[2]) # Transform input dates from before
# The MODIS package allows you select tiles interactively.  We however select them manually here
h = "29"
v = "07"
runGdal(product=product,begin=dates2$beginDOY,end = dates2$endDOY,tileH = h,tileV = v,)
# Per Default the data will be stored in
# ~homefolder/MODIS_ARC/PROCESSED
# After download you can stack the processed TIFS
vi <- preStack(path="~/MODIS_ARC/PROCESSED/MOD13Q1.005_20140810192530/", pattern="*_EVI.tif$")
s <- stack(vi)
s <- s*0.0001 # Rescale the downloaded Files with the scaling factor

# And extract the mean value for our point from before.
# First Transform our coordinates from lat-long to to the MODIS sinus Projection
sp <- SpatialPoints(coords = cbind(coord[2],coord[1]),proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84"))
sp <- spTransform(sp,CRS(proj4string(s)))
extract(s,sp) # Extract the EVI values for the available two layers from the generated stack
#>  0.2432  | 0.3113