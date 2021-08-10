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
van_tree_raw <-read.csv("input/van_tree_raw.csv", sep=";")
# parks
van_park_raw <- read_sf("large/van_park_raw/parks-polygon-representation.shp")
# neighbourhoods
van_hood <- readRDS("large/VancouverNeighbourhoodsCleaned.rds")
# municipal boundaries 
can_bound <- readRDS("large/MunicipalBoundariesCleaned.rds")

#### Data Cleaning ####
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
# check for dupes
unique(duplicated(van_tree_raw$TREE_ID))
# select the required columns and rename 
van_tree <- van_tree_raw %>%
  select(c("TREE_ID","GENUS_NAME","SPECIES_NAME","CULTIVAR_NAME","ON_STREET","DIAMETER","Geom")) %>%
  rename("id" = "TREE_ID") %>%
  rename("genus" = "GENUS_NAME") %>%
  rename("species" = "SPECIES_NAME") %>%
  rename("cultivar" = "CULTIVAR_NAME") %>%
  rename("street" = "ON_STREET") %>%
  rename("dbh" = "DIAMETER")
# add streetid column to match other cities
van_tree$streetid <- c(NA)
# change case of characters
van_tree$genus <- str_to_title(van_tree$genus) 
van_tree$species <- tolower(van_tree$species) 
van_tree$cultivar <- str_to_title(van_tree$cultivar) 
van_tree$street <- str_to_title(van_tree$street) 
van_tree$hood <- str_to_title(van_tree$hood) 
# change "species in species" column to "sp."
van_tree$species[van_tree$species == "species"] <- "sp."
# convert empty as NA for cultivar
van_tree$cultivar[van_tree$cultivar == ""] <- NA
# converting dbh from inches to cm
van_tree$dbh <- van_tree$dbh*2.54
# data is formatted as GeoJSON
van_tree$Geom <- substr(van_tree$Geom,35,nchar(van_tree$Geom)-2)
van_tree <- separate(data = van_tree, col = Geom, into = c("long", "lat"), sep = "\\, ")
van_tree <- st_as_sf(x = van_tree, coords = c("long", "lat"), crs = 4326, na.fail = FALSE, remove = FALSE)
# drop any rows that have NA lat/long
van_tree <- drop_na(van_tree, c(lat,long))
# transform
van_tree <- st_transform(van_tree, crs = 6624)

#### Spatial Joins ####
## Neighbourhoods
# want to add columns that specifies what city and neighbourhood each tree belongs to
# join trees and neighbourhoods using st_intersects
van_tree <- st_join(van_tree, van_hood, join = st_intersects)
## Parks 
# want to identify which trees are park trees and which are street 
van_tree <- st_join(van_tree, van_park, join = st_intersects)
# remove all trees on polygon boundaries after joining with parks by deleting duplicates
van_dupe <- van_tree$id[duplicated(van_tree$id)]
van_tree <- van_tree %>% filter(!id %in% van_dupe)
# replace NAs with "no" to indicate street trees 
van_tree <- replace_na(van_tree, list(park = "no"))
# if value is not "no", change value to "yes" so park column is binary yes/no
van_tree$park[van_tree$park != "no"] <- "yes"

#### Remove park trees ####
van_tree <- van_tree %>% filter(park == "no")

#### Remove trees with incorrect coordinates ####
# some trees may have coordinates that place them outside the city's boundaries
# select Vancouver boundary
van_bound <- subset(can_bound, bound == "Vancouver")
# remove the erroneous trees using spatial join
van_tree <- van_tree[van_bound,]

#### Save ####
# reorder columns
van_tree <- van_tree[,c("city","id","genus", "species", "cultivar", "geometry","hood","streetid","street","park","dbh")]# Check and make output
# save cleaned Vancouver tree dataset as rds and shapefile
saveRDS(van_tree, "large/VancouverTreesCleaned.rds")
st_write(van_tree, "large/VancouverTreesCleaned.gpkg", driver = "GPKG")
