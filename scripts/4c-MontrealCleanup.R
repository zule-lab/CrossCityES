#### Montreal public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Montreal public tree inventory

#### PACKAGES #### 
# load packages 
p <- c("sf", "dplyr", "tidyr", "data.table")
lapply(p, library, character.only = T)

#### FUNCTIONS ####
source("scripts/function-TreeCleaning.R")

#### DATA ####
# tree inventory
mon_tree_raw <- fread("large/trees/mon_tree_raw.csv", encoding = "UTF-8", na.strings = c("",NA))
# parks 
mon_park_raw <- st_read(file.path("/vsizip", "large/parks/mon_park_raw.zip"))
# neighbourhoods
mon_hood <- readRDS("large/neighbourhoods/MontrealNeighbourhoodsCleaned.rds")
# municipal boundaries 
can_bound <- readRDS("large/national/MunicipalBoundariesCleaned.rds")
# roads
can_road <- readRDS("large/national/RoadsCleaned.rds")

#### CLEANING ####
## Parks
# select relevant columns and rename 
mon_park <- mon_park_raw %>%
  select(c("Nom", "geometry")) %>%
  rename("park" = "Nom")

## Trees
# NOTE: only common name for species, requires further sorting
# Check for dupes
unique(duplicated(mon_tree_raw))
# select the required columns and rename
mon_tree <- mon_tree_raw %>%
  select(c("Essence_latin","DHP", "Rue", "NOM_PARC","Longitude","Latitude")) %>%
  rename("dbh" = "DHP",
         "park" = "NOM_PARC",
         "street" = "Rue")
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
# Converting dbh from mm to cm
mon_tree$dbh <- mon_tree$dbh/10
# drop any rows that have NA lat/long
mon_tree <- drop_na(mon_tree, c(Latitude,Longitude))
# adding geometry column and specify projection outlined in City of Montreal metadata 
mon_tree <- st_as_sf(x = mon_tree, coords = c("Longitude", "Latitude"), crs = 4326, na.fail = FALSE, remove = FALSE)

## Final dataset 
tree_cleaning("Montreal", mon_tree, mon_park, mon_hood, can_bound, can_road)
