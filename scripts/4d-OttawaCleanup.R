#### Ottawa public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Ottawa public tree inventory
# Still require neighbourhood and park/street columns

#### PACKAGES #### 
# load packages 
p <- c("sf", "dplyr", "tidyr", "readr")
lapply(p, library, character.only = T)

#### FUNCTIONS ####
source("scripts/function-TreeCleaning.R")

#### DATA ####
# tree inventory
ott_tree_raw <- read_csv("large/trees/ott_tree_raw.csv")
# parks
ott_park_raw <- st_read(file.path("/vsizip", "large/parks/ott_park_raw.zip"))
# neighbourhoods 
ott_hood <- readRDS("large/neighbourhoods/OttawaNeighbourhoodsCleaned.rds")
# municipal boundaries 
can_bound <- readRDS("large/national/MunicipalBoundariesCleaned.rds")
# roads 
can_road <- readRDS("large/national/RoadsCleaned.rds")


#### CLEANING ####
## Parks
ott_park <- ott_park_raw %>%
  select(c("NAME", "geometry")) %>%
  rename("park" = "NAME")

## Trees
# NOTE: only common name for species, requires further sorting
# check for dupes
unique(duplicated(ott_tree_raw$OBJECTID))
# select the required columns and rename 
ott_tree <- ott_tree_raw %>%
  select(c("X","Y","OBJECTID","ADDSTR","SPECIES","DBH")) %>%
  rename("long" = "X") %>%
  rename("lat" = "Y") %>%
  rename("id" = "OBJECTID") %>%
  rename("street" = "ADDSTR") %>%
  rename("species" = "SPECIES") %>%
  rename("dbh" = "DBH")
# no scientific names yet so just add empty genus and cultivar columns 
ott_tree$genus <- c(NA)
ott_tree$cultivar <- c(NA)
# drop any rows that have NA lat/long
ott_tree <- drop_na(ott_tree, c(lat,long))
# adding geometry column and specify projection outlined in City of Ottawa metadata 
ott_tree <- st_as_sf(x = ott_tree, coords = c("long", "lat"), crs = 4326, na.fail = FALSE, remove = FALSE)

## Final Dataset 
tree_cleaning("Ottawa", ott_tree, ott_park, ott_hood, can_bound, can_road)
