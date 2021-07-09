#### Halifax public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Halifax public tree inventory
# Still requires neighbourhood, street, and park/street tree columns

#### Packages #### 
# load packages 
easypackages::packages("sf", "tidyverse")

#### Data ####
# load data downloaded in 1-DataDownload.R
# tree inventory
hal_tree_raw <- read_csv("input/hal_tree_raw.csv")
# parks
hal_park_raw <- read_sf("large/hal_park_raw/Parks_and_Greenspace.shp")
# neighbourhoods 
hal_hood_raw <- read_sf("large/hal_hood_raw/Community_Boundaries.shp")
# tree species code
hal_tree_spcode <-read.csv("input/hal_tree_spcode.csv", row.names = NULL)
# tree dbh code
hal_tree_dbhcode <-read.csv("input/hal_tree_dbhcode.csv", row.names = NULL)

#### Data Cleaning ####
## Neighbourhoods
# select neighbourhood name and geometry from hood dataset
hal_hood <- hal_hood_raw %>% 
  select(c("GSA_NAME", "geometry")) %>% 
  rename("hood" = "GSA_NAME")
# change case of hood names
hal_hood$hood <- str_to_title(hal_hood$hood)
# transform to EPSG: 6624 to be consistent with other layers
hal_hood <- st_transform(hal_hood, crs = 6624)
# remove Halifax row
hal_hood<-hal_hood[!(hal_hood$hood=="HALIFAX"),]

View(hal_hood)
# save cleaned neighbourhoods layer 
saveRDS(hal_hood, "large/HalifaxNeighbourhoodsCleaned.rds")

## Parks
# select relevant columns and rename 
hal_park <- hal_park_raw %>%
  select(c("PARK_NAME", "geometry")) %>%
  rename("park" = "PARK_NAME")
# transform to ESPG: 6624
hal_park <- st_transform(hal_park, crs = 6624)
# save 
saveRDS(hal_park, "large/HalifaxParksCleaned.rds")

## Trees
# check for dupes
unique(duplicated(hal_tree_raw$TREEID))
# extract only trees in service, columns needed, and rename
hal_tree <- hal_tree_raw %>% 
  filter(ASSETSTAT == "INS") %>%
  select(c("X", "Y", "TREEID", "SP_SCIEN", "DBH")) %>%
  rename("id" = "TREEID") %>%
  rename("dbh" = "DBH")
# add city column
hal_tree$city <- c("Halifax")
# recode species from code to scientific name
# "BUROAK", "BLAOAK", "BOAK", "FMAPLE" undefined in metadata, "BUROAK" <- "Bur Oak", "BLAOAK" <- "Black Oak"
hal_tree$botname <- hal_tree_spcode$botname[match(as.character(hal_tree$SP_SCIEN), as.character(hal_tree_spcode$code))]
# sorting species name into genus, species, and cultivar columns
hal_tree <- hal_tree %>% separate(botname, c("genus","species","var","cultivar"))
hal_tree$var[hal_tree$var == "var"] <- NA
hal_treecul <- hal_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ")
hal_treesp <- hal_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ")
hal_tree <- rbind(hal_treecul, hal_treesp)
# assign blanks and NAs in species column to "sp."
hal_tree$species[hal_tree$species %in% c("",NA)] <- "sp."
# recode dbh from categories to median measurements
hal_tree$dbh <- hal_tree_dbhcode$dbh[match(as.character(hal_tree$dbh), as.character(hal_tree_dbhcode$code))]
# drop geometry NAs
hal_tree <- drop_na(hal_tree, c(X,Y))
# convert to sf object 
hal_tree <- st_as_sf(hal_tree, coords = c("X", "Y"), crs = 4326)
# transform
hal_tree <- st_transform(hal_tree, crs = 6624)

## City Boundary & Roads 
# select Halifax boundary
# may have edited codes wrong, will see with the road dataset later?
hal_bound <- subset(can_bound, bound == "Halifax")
# select roads within the Calgary boundary
hal_road <- can_road[hal_bound,]
hal_road <- st_transform(hal_road, crs = 6624)
hal_road <- select(hal_road, c("CSDNAME", "geometry"))
saveRDS(hal_road, "large/HalifaxRoadsCleaned.rds")

#### Spatial Joins ####
# none of the codes in this section working for now
## Neighbourhood
hal_tree <- st_join(hal_tree, hal_hood, join = st_intersects)
# replace NAs with "no" to indicate street trees 
hal_tree <- replace_na(hal_tree, list(park = "no"))
## Parks 
# want to identify which trees are park trees and which are street 
hal_tree <- st_join(hal_tree, hal_park, join = st_intersects)
# replace NAs with "no" to indicate street trees 
hal_tree <- replace_na(hal_tree, list(park = "no"))
# if value is not "no", change value to "yes" so park column is binary yes/no
hal_tree$park[hal_tree$park != "no"] <- "yes"
## Streets
hal_tree$street <- st_nearest_feature(hal_tree, hal_road)
# st_nearest_feature returns the index value not the street name
# need to replace index values with associated street

#### Save ####
# reorder columns
hal_tree <- hal_tree[,c("city","id","genus","species","cultivar","geometry","hood","street","park","dbh")]# Check and make output
# save cleaned Ottawa tree dataset as rds and shapefile
saveRDS(hal_tree, "large/HalifaxTreesCleaned.rds")
st_write(hal_tree, "large/HalifaxTreesCleaned.shp")
