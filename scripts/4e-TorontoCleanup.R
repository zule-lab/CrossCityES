#### Toronto public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Toronto public tree inventory

#### PACKAGES #### 
# load packages 
p <- c("sf", "dplyr", "tidyr", "readr", "stringr")
lapply(p, library, character.only = T)

#### FUNCTIONS ####
source("scripts/function-TreeCleaning.R")

#### DATA ####
# load data downloaded in 1-DataDownload.R
# tree inventory
tor_tree_raw <- read_csv("large/trees/tor_tree_raw.csv")
# species codes 
tor_tree_spcode <- read_csv("input/tor_tree_spcode.csv")
# parks
tor_park_raw <- st_read(file.path("/vsizip", "large/parks/tor_park_raw.zip"))
# neighbourhoods
tor_hood <- readRDS("large/neighbourhoods/TorontoNeighbourhoodsCleaned.rds")
# municipal boundaries 
can_bound <- readRDS("large/national/MunicipalBoundariesCleaned.rds")
# roads
can_road <- readRDS("large/national/RoadsCleaned.rds")

#### CLEANING ####
## Parks
# select relevant columns and rename 
tor_park <- tor_park_raw %>%
  select(c("OBJECTID", "geometry")) %>%
  rename("park" = "OBJECTID")

## Trees
# Check for dupes
unique(duplicated(tor_tree_raw$STRUCTID))
# select the required columns and rename
tor_tree <- tor_tree_raw %>%
  select(c("STRUCTID","DBH_TRUNK","COMMON_NAME", "STREETNAME","geometry")) %>%
  rename("id" = "STRUCTID",
         "street" = "STREETNAME",
         "dbh" = "DBH_TRUNK")
tor_tree$street <- str_to_title(tor_tree$street)
# sorting species name into genus, species, and cultivar columns
tor_tree$BOTANICAL_NAME <- tor_tree_spcode$BOTANICAL_NAME[match(as.character(tor_tree$COMMON_NAME), as.character(tor_tree_spcode$COMMON_NAME))]
tor_tree <- select(tor_tree, -"COMMON_NAME")
tor_tree <- tor_tree %>% separate(BOTANICAL_NAME, c("genus","species","var","cultivar", "cultivar2"))
tor_tree$species[tor_tree$species == "sp"] <- "sp."
tor_tree$species[tor_tree$species == "X"] <- "x"
tor_tree$var[tor_tree$var == "var"] <- NA
tor_treecul <- tor_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar", "cultivar2"), na.rm = TRUE, sep = " ")%>%
  mutate(cultivar = na_if(cultivar, ""))
tor_treesp <- tor_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ") %>% unite(cultivar, c("cultivar", "cultivar2"), na.rm = TRUE, sep = " ")%>%
  mutate(cultivar = na_if(cultivar, ""))
tor_tree <- rbind(tor_treecul, tor_treesp)
# data is formatted as GeoJSON
tor_tree$geometry <- substr(tor_tree$geometry,38,nchar(tor_tree$geometry)-2)
tor_tree <- separate(data = tor_tree, col = geometry, into = c("long", "lat"), sep = "\\, ")
# drop any rows that have NA lat/long
tor_tree <- drop_na(tor_tree, c(lat,long))
tor_tree <- st_as_sf(x = tor_tree, coords = c("long", "lat"), crs = 4326, na.fail = FALSE, remove = FALSE)

## Final Dataset
tree_cleaning("Toronto", tor_tree, tor_park, tor_hood, can_bound, can_road)
