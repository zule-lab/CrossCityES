#### Calgary public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Calgary public tree inventory
# Still require street, neighbourhood, street, and park/street tree columns

#### Packages #### 
# load packages 
easypackages::packages("sf", "tidyverse")

#### Data ####
# load data downloaded in 1-DataDownload.R
# tree inventory
cal_tree_raw <- read_csv("large/cal_tree_raw.csv")
# parks
cal_park_raw <- read_csv("input/cal_park_raw.csv")
# neighbourhoods 
cal_hood <- readRDS("large/CalgaryNeighbourhoodsCleaned.rds")
# municipal boundaries 
can_bound <- readRDS("large/MunicipalBoundariesCleaned.rds")
# roads
can_road <- readRDS("large/RoadsCleaned.rds")
# dissemination areas
dsa_bound <- readRDS("large/DSACleaned.rds")

#### Data Cleaning ####
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
# select the required columns and rename 
cal_tree <- cal_tree_raw %>%
  select(c("GENUS", "SPECIES", "CULTIVAR", "DBH_CM", "WAM_ID", "latitude", "longitude")) %>%
  rename("genus" = "GENUS") %>% 
  rename("species" = "SPECIES") %>%
  rename("cultivar" = "CULTIVAR") %>%
  rename("dbh" = "DBH_CM") %>%
  rename("id" = "WAM_ID")
# assign blanks and NAs in species column to "sp."
cal_tree$species[cal_tree$species %in% c("",NA)]<-"sp."
# remove quotations from cultivar names 
cal_tree$cultivar <- substr(cal_tree$cultivar,2,nchar(cal_tree$cultivar)-1)
# drop geometry NAs
cal_tree <- drop_na(cal_tree, c(latitude,longitude))
# convert to sf object 
cal_tree <- st_as_sf(cal_tree, coords = c("longitude", "latitude"), crs = 4326)
# transform
cal_tree <- st_transform(cal_tree, crs = 6624)

## City Boundary & Roads 
# select Calgary boundary
cal_bound <- subset(can_bound, bound == "Calgary")
# select roads within the Calgary boundary
cal_road <- can_road[cal_bound,]
cal_road <- st_transform(cal_road, crs = 6624)
cal_road <- select(cal_road, c("street","streetid", "geometry"))
#add row index numbers as a column for recoding later
cal_road <- cal_road %>% mutate(index= 1:n())
#save
saveRDS(cal_road, "large/CalgaryRoadsCleaned.rds")

#### Spatial Joins ####
## Neighbourhoods
# want to add columns that specifies what city and neighbourhood each tree belongs to
# join trees and neighbourhoods using st_intersects
cal_tree <- st_join(cal_tree, cal_hood, join = st_intersects)
## Parks 
# want to identify which trees are park trees and which are street 
cal_tree <- st_join(cal_tree, cal_park, join = st_intersects)
# remove all trees on polygon boundaries after joining with parks by deleting duplicates
cal_dupe <- cal_tree$id[duplicated(cal_tree$id)]
cal_tree <- cal_tree %>% filter(!id %in% cal_dupe)
# replace NAs with "no" to indicate street trees 
cal_tree <- replace_na(cal_tree, list(park = "no"))
# if value is not "no", change value to "yes" so park column is binary yes/no
cal_tree$park[cal_tree$park != "no"] <- "yes"
## Streets
# st_nearest_feature returns the index value not the street name
cal_tree$streetid <- st_nearest_feature(cal_tree, cal_road)
# return unique streetid based on index values
cal_tree$streetid <- cal_road$streetid[match(as.character(cal_tree$streetid), as.character(cal_road$index))]
# add column with street name
cal_tree$street <- cal_road$street[match(as.character(cal_tree$streetid), as.character(cal_road$streetid))]
## Dissemination Areas
# assign forward sortation areas based on 2016 census data
cal_tree <- st_join(cal_tree, can_cen, join = st_intersects)

#### Remove park trees ####
cal_tree <- cal_tree %>% filter(park == "no")

#### Remove trees with incorrect coordinates ####
# some trees may have coordinates that place them outside the city's boundaries
# remove the erroneous trees using spatial join
cal_tree <- cal_tree[cal_bound,]

#### Save ####
# reorder columns
cal_tree <- cal_tree[,c("city","id","genus", "species", "cultivar", "geometry","hood","streetid","street","park","dsa","dbh")]# Check and make output
# save cleaned Calgary tree dataset as rds and shapefile
saveRDS(cal_tree, "large/CalgaryTreesCleaned.rds")
st_write(cal_tree, "large/CalgaryTreesCleaned.gpkg", driver="GPKG")
