#### Land Surface Temperature Data Cleaning #### 
# Author: Isabella Richmond

# Land Surface Temperature data was calculated and extracted using Landsat 8 satellite imagery 
# code for calculation was taken from Sofia Ermida: https://github.com/sofiaermida/Landsat_SMW_LST
# code for extraction was done in Google Earth Engine 
# all code and explanation can be found at: https://github.com/icrichmond/Landsat8Temperature 

#### FUNCTION #### 
clean_temp <- function(df){
  # packages 
  p <- c("anytime")
  lapply(p, library, character.only = T)
  # need to extract dates from the system.index column 
  df$date <- sapply(strsplit(df$system.index, "_"), function(x) x[3])
  df$date <- anydate(df$date)
  # need to extract image id from system.index without long series of 0s at the end
  df$id <- sub("_[^_]+$", "", df$system.index) 
  # drop system.index column - no longer useful 
  df <- subset(df, select = -system.index)
  
}

#### DATA #### 
city <- read.csv("large/temperature/MeanTempCity.csv")
hoods <- read.csv("large/temperature/MeanTempNeighbourhood.csv")
streets <- read.csv('large/temperature/MeanTempStreets.csv')


#### CLEAN #### 
city_clean <- clean_temp(city)
hood_clean <- clean_temp(hoods)
streets_clean <- clean_temp(streets)

#### SAVE #### 
write.csv(city_clean, "large/temperature/MeanTempCityClean.csv")              
write.csv(hood_clean, "large/temperature/MeanTempNeighbourhoodClean.csv")
write.csv(streets_clean, "large/temperature/MeanTempStreetClean.csv")
