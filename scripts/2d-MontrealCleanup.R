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
mon_tree_raw <- read_csv("input/mon_tree_raw.csv")

#### Data Cleaning ####
## Trees
# NOTE: only common name for species, requires further sorting
# Check for dupes
colnames(mon_tree_raw)
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
# identify which trees are park trees and which are street 
mon_tree$park <- ifelse(mon_tree$park == "","no","yes")
# Converting dbh from mm to cm
mon_tree$dbh <- mon_tree$dbh/10
# drop any rows that have NA lat/long
mon_tree <- drop_na(mon_tree, c(Latitude,Longitude))
# adding geometry column and specify projection outlined in City of Montreal metadata 
mon_tree <- st_as_sf(x = mon_tree, coords = c("Longitude", "Latitude"), crs = 4326, na.fail = FALSE, remove = FALSE)
# transform
mon_tree <- st_transform(mon_tree, crs = 6624)

## City Boundary & Roads 
# select Halifax boundary
# may have edited codes wrong, will see with the road dataset later?
mon_bound <- subset(can_bound, bound == "Montreal")
# select roads within the Calgary boundary
mon_road <- can_road[mon_bound,]
mon_road <- st_transform(mon_road, crs = 6624)
mon_road <- select(mon_road, c("CSDNAME", "geometry"))
saveRDS(mon_road, "large/MontrealRoadsCleaned.rds")

#### Spatial Joins ####
## Streets
mon_tree$street <- st_nearest_feature(mon_tree, mon_road)
# st_nearest_feature returns the index value not the street name
# need to replace index values with associated street

#### Remove park trees ####
mon_tree <- mon_tree %>% filter(park == "no")

#### Save ####
# reorder columns
mon_tree <- mon_tree[,c("city","id","genus","species","cultivar","geometry","hood","street","park","dbh")]
# save cleaned Ottawa tree dataset as rds and shapefile
saveRDS(mon_tree, "large/MontrealTreesCleaned.rds")
st_write(mon_tree, "large/MontrealTreesCleaned.shp")

View(mon_tree)
