#### Calgary public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Calgary public tree inventory
# Still require street, neighbourhood, and park/street columns

#### Packages #### 
# load packages 
easypackages::packages("sf", "tidyverse")

#### Data ####
# load data downloaded in 1-DataDownload.R
# tree inventory
cal_tree_raw <- read_csv("large/cal_tree_raw.csv")
# parks
cal_park_raw <- read_sf("input/cal_park_raw.csv")
# neighbourhoods 
# NOTE: need to add this to DataDownload and initial cleaning codebut don't know where it is from
cal_hood_code <- read_csv("input/cal_tree_hoodcode.csv")
# city boundary 
can_bound <- read_sf("large/can_bound/lcma000b16a_e.shp")
# roads
can_road <- read_sf("large/can_road/lcsd000a20a_e.shp")

#### Data Cleaning ####
## Neighbourhoods
# replace neighbourhood code in tree dataset with actual neighbourhood names 
cal_tree_raw$hood <- cal_hood_code$hood[match(as.character(cal_tree_raw$COMM_CODE), as.character(cal_hood_code$code))]
# NOTE: missing a couple codes, need to look into this 

## Parks
# select relevant columns and rename 
cal_park <- cal_park_raw %>%
  select(c("SITE_NAME", "the_geom")) %>%
  rename("park" = "SITE_NAME") %>%
  rename("geometry" = "the_geom")
# convert to sf object 
cal_park <- st_as_sf(cal_park, wkt = "geometry", crs = 4326)
cal_park <- st_transform(cal_park, crs = 6624)
# save
saveRDS(cal_park, "large/CalgaryParksCleaned.rds")

## Trees
# check for dupes
unique(duplicated(cal_tree_raw$WAM_ID))
# extract columns needed and rename
cal_tree <- cal_tree_raw %>%
  select(c("GENUS", "SPECIES", "CULTIVAR", "DBH_CM", "WAM_ID", "latitude", "longitude", "hood")) %>%
  rename("genus" = "GENUS") %>% 
  rename("species" = "SPECIES") %>%
  rename("cultivar" = "CULTIVAR") %>%
  rename("dbh" = "DBH_CM") %>%
  rename("id" = "WAM_ID")
# add city column
cal_tree$city <- c("Calgary")
# assign blanks and NAs in species column to "sp."
cal_tree$species[cal_tree$species %in% c("",NA)]<-"sp."
# remove quotations from cultivar names 
cal_tree$cultivar <- substr(cal_tree$cultivar,2,nchar(cal_tree$cultivar)-1)
# drop NAs
cal_tree <- drop_na(cal_tree, c(latitude,longitude))
# convert to sf object 
cal_tree <- st_as_sf(cal_tree, coords = c("longitude", "latitude"), crs = 4326)
# transform
cal_tree <- st_transform(cal_tree, crs = 6624)

## City Boundary & Roads 
# select Calgary boundary
can_bound <- subset(can_bound, CMANAME == "Calgary")
# select roads within the Calgary boundary
cal_road <- can_road[can_bound,]
cal_road <- st_transform(cal_road, crs = 6624)
cal_road <- select(cal_road, c("CSDNAME", "geometry"))
saveRDS(cal_road, "large/CalgaryRoadsCleaned.rds")

#### Spatial Joins ####
## Parks 
# want to identify which trees are park trees and which are street 
cal_tree <- st_join(cal_tree, cal_park, join = st_intersects)
# replace NAs with "no" to indicate street trees 
cal_tree <- replace_na(cal_tree, list(park = "no"))
# if value is not "no", change value to "yes" so park column is binary yes/no
cal_tree$park[cal_tree$park != "no"] <- "yes"
## Streets
cal_tree$street <- st_nearest_feature(cal_tree, cal_road)
# st_nearest_feature returns the index value not the street name
# need to replace index values with associated street

#### Save ####
# reorder columns
cal_tree <- cal_tree[,c("city","id","genus", "species", "cultivar", "geometry","hood","street","park","dbh")]# Check and make output
# save cleaned Ottawa tree dataset as rds and shapefile
saveRDS(cal_tree, "large/CalgaryTreesCleaned.rds")
st_write(cal_tree, "large/CalgaryTreesCleaned.shp")