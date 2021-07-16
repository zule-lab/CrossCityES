#### Toronto public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Toronto public tree inventory
# Toronto dataset has street column
# Still require neighbourhood and park/street tree column

#### Packages #### 
# load packages 
easypackages::packages("sf", "tidyverse")

#### Data ####
# load data downloaded in 1-DataDownload.R
# tree inventory
tor_tree_raw <- read_sf("large/tor_tree_raw/TMMS_Open_Data_WGS84.shp")
# parks
tor_park_raw <- read_sf("large/tor_park_raw/CITY_GREEN_SPACE_WGS84.shp")
# neighbourhoods
tor_hood_raw <- read_sf("large/tor_hood_raw/Neighbourhoods.shp")

#### Data Cleaning ####
## Neighbourhoods
# select neighbourhood name and geometry from hood dataset
tor_hood <- tor_hood_raw %>% 
  select(c("FIELD_8", "geometry")) %>% 
  rename("hood" = "FIELD_8")
# transform to EPSG: 6624 to be consistent with other layers
tor_hood <- st_transform(tor_hood, crs = 6624)

## Parks
# select relevant columns and rename 
tor_park <- tor_park_raw %>%
  select(c("OBJECTID", "geometry")) %>%
  rename("park" = "OBJECTID")
# transform to EPSG: 6624 to be consistent with other layers
tor_park <- st_transform(tor_park, crs = 6624)
# save
saveRDS(tor_park, "large/TorontoParksCleaned.rds")

## Trees
# Check for dupes
unique(duplicated(tor_tree_raw$STRUCTID))
# add city column
tor_tree_raw$city <- c("Toronto")
# select the required columns and rename
tor_tree <- tor_tree_raw %>%
  select(c("STRUCTID","NAME","DBH_TRUNK","BOTANICAL_","geometry","city")) %>%
  rename("id" = "STRUCTID") %>%
  rename("street" = "NAME") %>%
  rename("dbh" = "DBH_TRUNK") 
# add streetid column to match other cities
tor_tree$streetid <- c(NA)
# sorting species name into genus, species, and cultivar columns
tor_tree <- tor_tree %>% separate(BOTANICAL_, c("genus","species","var","cultivar", "cultivar2"))
tor_tree$species[tor_tree$species == "sp"] <- "sp."
tor_tree$species[tor_tree$species == "X"] <- "x"
tor_tree$var[tor_tree$var == "var"] <- NA
tor_treecul <- tor_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar", "cultivar2"), na.rm = TRUE, sep = " ")%>%
  mutate(cultivar = na_if(cultivar, ""))
tor_treesp <- tor_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ") %>% unite(cultivar, c("cultivar", "cultivar2"), na.rm = TRUE, sep = " ")%>%
  mutate(cultivar = na_if(cultivar, ""))
tor_tree <- rbind(tor_treecul, tor_treesp)
tor_tree$street <- str_to_title(tor_tree$street)
# transform
tor_tree <- st_transform(tor_tree, crs = 6624)

#### Spatial Joins ####
## Neighbourhoods
# want to add a column that specifies what neighbourhood each tree belongs to
# join trees and neighbourhoods using st_intersects
tor_tree <- st_join(tor_tree, tor_hood, join = st_intersects)
## Parks 
# want to identify which trees are park trees and which are street 
# code adds 11 columns to the dataset?? why?
tor_tree <- st_join(tor_tree, tor_park, join = st_intersects)
# remove all trees on polygon boundaries after joining with parks by deleting duplicates
tor_dupe <- tor_tree$id[duplicated(tor_tree$id)]
tor_tree <- tor_tree %>% filter(!id %in% tor_dupe)
# replace NAs with "no" to indicate street trees 
tor_tree <- replace_na(tor_tree, list(park = "no"))
# if value is not "no", change value to "yes" so park column is binary yes/no
tor_tree$park[tor_tree$park != "no"] <- "yes"

#### Remove park trees ####
tor_tree <- tor_tree %>% filter(park == "no")

#### Save ####
# reorder columns
tor_tree <- tor_tree[,c("city","id","genus","species","cultivar","geometry","hood","streetid","street","park","dbh")]
# save cleaned Ottawa tree dataset as rds and shapefile
saveRDS(tor_tree, "large/TorontoTreesCleaned.rds")
st_write(tor_tree, "large/TorontoTreesCleaned.shp")
