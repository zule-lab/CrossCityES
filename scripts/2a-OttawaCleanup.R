#### Ottawa public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Ottawa public tree inventory
# Ottawa dataset has street name 
# Still require neighbourhood and park/street columns

#### Packages #### 
# load packages 
easypackages::packages("sf", "tidyverse")

#### Data ####
# load data downloaded in 1-DataDownload.R
# tree inventory
ott_tree_raw <- read_csv("input/ott_tree_raw.csv")
# parks
ott_park_raw <- read_sf("large/ott_park_raw/Parks_and_Greenspace.shp")
# neighbourhoods 
ott_hood_raw <- read_sf("large/ott_hood_raw/Ottawa_Neighbourhood_Study_(ONS)_-_Neighbourhood_Boundaries_Gen_2.shp")

#### Data Cleaning ####
## Neighbourhoods
# select neighbourhood name and geometry from hood dataset
ott_hood <- ott_hood_raw %>% 
  select(c("Name", "geometry")) %>% 
  rename("hood" = "Name")
# transform to EPSG: 6624 to be consistent with other layers
ott_hood <- st_transform(ott_hood, crs = 6624)
View(ott_hood)
# save cleaned neighbourhoods layer 
saveRDS(ott_hood, "large/OttawaNeighbourhoodsCleaned.rds")

## Parks
# select relevant columns and rename 
ott_park <- ott_park_raw %>%
  select(c("NAME", "geometry")) %>%
  rename("park" = "NAME")
# transform to ESPG: 6624
ott_park <- st_transform(ott_park, crs = 6624)
# save 
saveRDS(ott_park, "large/OttawaParksCleaned.rds")

## Trees
# NOTE: only common name for species, requires further sorting
# check for dupes
unique(duplicated(ott_tree_raw$OBJECTID))
# add city column
ott_tree_raw$city <- c("Ottawa")
# select the required columns and rename 
ott_tree <- ott_tree_raw %>%
  select(c("X","Y","OBJECTID","ADDSTR","SPECIES","DBH")) %>%
  rename("long" = "X") %>%
  rename("lat" = "Y") %>%
  rename("id" = "OBJECTID") %>%
  rename("street" = "ADDSTR") %>%
  rename("species" = "SPECIES") %>%
  rename("dbh" = "DBH")
# drop any rows that have NA lat/long
ott_tree <- drop_na(ott_tree, c(lat,long))
# adding geometry column and specify projection outlined in City of Ottawa metadata 
ott_tree <- st_as_sf(x = ott_tree, coords = c("long", "lat"), crs = 4326, na.fail = FALSE, remove = FALSE)
# transform to match parks layer
ott_tree <- st_transform(ott_tree, crs = 6624)

#### Spatial Joins ####
## Neighbourhoods
# want to add a column that specifies what neighbourhood each tree belongs to
# join trees and neighbourhoods using st_intersects
ott_tree <- st_join(ott_tree, ott_hood, join = st_intersects)
## Parks 
# want to identify which trees are park trees and which are street 
ott_tree <- st_join(ott_tree, ott_park, join = st_intersects)
# replace NAs with "no" to indicate street trees 
ott_tree <- replace_na(ott_tree, list(park = "no"))
# if value is not "no", change value to "yes" so park column is binary yes/no
ott_tree$park[ott_tree$park != "no"] <- "yes"

#### Save ####
# reorder columns
ott_tree <- ott_tree[,c("city","id","species","geometry","hood","street","park","dbh")]
# save cleaned Ottawa tree dataset as rds and shapefile
saveRDS(ott_tree, "large/OttawaTreesCleaned.rds")
st_write(ott_tree, "large/OttawaTreesCleaned.shp")
