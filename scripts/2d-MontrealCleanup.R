#### Montreal public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Montreal public tree inventory
# Montreal dataset has neighbourhood and park/street columns
# Still require street column

#### Packages #### 
# load packages 
easypackages::packages("sf", "tidyverse")

#### Data ####
# load data downloaded in 1-DataDownload.R
# tree inventory
mon_tree_raw <- read_csv("large/mon_tree_raw.csv")
# municipal boundaries 
can_bound <- readRDS("large/MunicipalBoundariesCleaned.rds")
# roads
can_road <- readRDS("large/RoadsCleaned.rds")

#### Data Cleaning ####
## Trees
# NOTE: only common name for species, requires further sorting
# Check for dupes
unique(duplicated(mon_tree_raw))
# add city column
mon_tree_raw$city <- c("Montreal")
# select the required columns and rename
mon_tree <- mon_tree_raw %>%
  select(c("ARROND_NOM","Essence_latin","DHP","CODE_PARC","Longitude","Latitude","city")) %>%
  rename("hood" = "ARROND_NOM") %>%
  rename("dbh" = "DHP") %>%
  rename("park" = "CODE_PARC") 
# adding id column
mon_tree$id <- seq.int(nrow(mon_tree))
# sorting species name into genus, species, and cultivar columns
mon_tree <- mon_tree %>% separate(Essence_latin, c("genus","species","var","cultivar"))
mon_tree$species[mon_tree$species %in% c("ssp", NA)]<-"sp."
mon_tree$var[mon_tree$var %in% c("","var")] <- NA
mon_treecul <- mon_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ")
mon_treesp <- mon_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ")
mon_tree <- rbind(mon_treecul, mon_treesp)
mon_tree$cultivar[mon_tree$cultivar == ""] <- NA
# identify which trees are park trees and which are street 
mon_tree$park <- ifelse(is.na(mon_tree$park),"no","yes")
# Converting dbh from mm to cm
mon_tree$dbh <- mon_tree$dbh/10
# drop any rows that have NA lat/long
mon_tree <- drop_na(mon_tree, c(Latitude,Longitude))
# adding geometry column and specify projection outlined in City of Montreal metadata 
mon_tree <- st_as_sf(x = mon_tree, coords = c("Longitude", "Latitude"), crs = 4326, na.fail = FALSE, remove = FALSE)
# transform
mon_tree <- st_transform(mon_tree, crs = 6624)

## City Boundary & Roads 
# select Montreal boundary
mon_bound <- subset(can_bound, bound == "Montreal")
# select roads within the Montreal boundary
mon_road <- can_road[mon_bound,]
mon_road <- st_transform(mon_road, crs = 6624)
mon_road <- select(mon_road, c("street","streetid", "geometry"))
#add row index numbers as a column for recoding later
mon_road <- mon_road %>% mutate(index= 1:n())
#save
saveRDS(mon_road, "large/MontrealRoadsCleaned.rds")

#### Spatial Joins ####
## Streets
# st_nearest_feature returns the index value not the street name
mon_tree$streetid <- st_nearest_feature(mon_tree, mon_road)
# return unique streetid based on index values
mon_tree$streetid <- mon_road$streetid[match(as.character(mon_tree$streetid), as.character(mon_road$index))]
# add column with street name
mon_tree$street <- mon_road$street[match(as.character(mon_tree$streetid), as.character(mon_road$streetid))]

#### Remove park trees ####
mon_tree <- mon_tree %>% filter(park == "no")

#### Remove trees with incorrect coordinates ####
# some trees have coordinates that place them outside the city's boundaries
# remove the erroneous trees using spatial join
mon_tree <- mon_tree[mon_bound,]

#### Save ####
# reorder columns
mon_tree <- mon_tree[,c("city","id","genus","species","cultivar","geometry","hood","streetid","street","park","dbh")]
# save cleaned Ottawa tree dataset as rds and shapefile
saveRDS(mon_tree, "large/MontrealTreesCleaned.rds")
st_write(mon_tree, "large/MontrealTreesCleaned.gpkg", driver = "GPKG")
