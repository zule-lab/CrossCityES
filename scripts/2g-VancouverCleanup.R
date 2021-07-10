#### Vancouver public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Vancouver public tree inventory
# Vancouver dataset has neighbourhood and street
# Still require park/street column

#### Packages #### 
# load packages 
easypackages::packages("sf", "tidyverse")

#### Data ####
# load data downloaded in 1-DataDownload.R
# tree inventory
van_tree_raw <-read.csv(van_tree_dest, sep=";")
# parks
van_park_raw <- read_sf("large/van_park_raw/parks-polygon-representation.shp")

#### Data Cleaning ####
## Neighbourhoods
# select neighbourhood name and geometry from hood dataset
van_hood <- van_hood_raw %>% 
  select(c("name", "geometry")) %>% 
  rename("hood" = "name")
# transform to EPSG: 6624 to be consistent with other layers
van_hood <- st_transform(van_hood, crs = 6624)
View(van_hood)
# save cleaned neighbourhoods layer 
saveRDS(van_hood, "large/VancouverNeighbourhoodsCleaned.rds")

## Parks
# select relevant columns and rename 
van_park <- van_park_raw %>%
  select(c("park_name", "geometry")) %>%
  rename("park" = "park_name")
# transform to ESPG: 6624
van_park <- st_transform(van_park, crs = 6624)
# save 
saveRDS(van_park, "large/VancouverParksCleaned.rds")

## Trees
# NOTE: only common name for species, requires further sorting
# check for dupes
unique(duplicated(van_tree_raw$TREE_ID))
# add city column
van_tree_raw$city <- c("Vancouver")
# select the required columns and rename 
van_tree <- van_tree_raw %>%
  select(c("TREE_ID","GENUS_NAME","SPECIES_NAME","CULTIVAR_NAME","ON_STREET","NEIGHBOURHOOD_NAME","DIAMETER","Geom","city")) %>%
  rename("id" = "TREE_ID") %>%
  rename("genus" = "GENUS_NAME") %>%
  rename("species" = "SPECIES_NAME") %>%
  rename("cultivar" = "CULTIVAR_NAME") %>%
  rename("street" = "ON_STREET") %>%
  rename("hood" = "NEIGHBOURHOOD_NAME") %>%
  rename("dbh" = "DIAMETER")
# change case of characters
van_tree$genus <- str_to_title(van_tree$genus) 
van_tree$species <- tolower(van_tree$species) 
van_tree$cultivar <- str_to_title(van_tree$cultivar) 
van_tree$street <- str_to_title(van_tree$street) 
van_tree$hood <- str_to_title(van_tree$hood) 
# change "species in species" column to "sp."
van_tree$species[van_tree$species == "species"] <- "sp."
# converting dbh from inches to cm
van_tree$dbh <- van_tree$dbh*2.54
# converting to sf
van_tree$Geom <- substr(van_tree$Geom,35,nchar(van_tree$Geom)-2)
van_tree <- separate(data = van_tree, col = Geom, into = c("long", "lat"), sep = "\\, ")
van_tree <- st_as_sf(x = van_tree, coords = c("long", "lat"), crs = 4326, na.fail = FALSE, remove = FALSE)
# drop any rows that have NA lat/long
van_tree <- drop_na(van_tree, c(lat,long))
# transform
van_tree <- st_transform(van_tree, crs = 6624)

#### Spatial Joins ####
## Parks 
# want to identify which trees are park trees and which are street 
van_tree <- st_join(van_tree, van_park, join = st_intersects)
# replace NAs with "no" to indicate street trees 
van_tree <- replace_na(van_tree, list(park = "no"))
# if value is not "no", change value to "yes" so park column is binary yes/no
van_tree$park[van_tree$park != "no"] <- "yes"

#### Save ####
# reorder columns
van_tree <- van_tree[,c("city","id","genus", "species", "cultivar", "geometry","hood","street","park","dbh")]# Check and make output
# save cleaned Vancouver tree dataset as rds and shapefile
saveRDS(van_tree, "large/VancouverTreesCleaned.rds")
st_write(van_tree, "large/VancouverTreesCleaned.shp")
