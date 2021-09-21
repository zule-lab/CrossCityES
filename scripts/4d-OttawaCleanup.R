#### Ottawa public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Ottawa public tree inventory

#### PACKAGES #### 
# load packages 
p <- c("sf", "dplyr", "tidyr", "readr")
lapply(p, library, character.only = T)

#### FUNCTIONS ####
source("scripts/function-TreeCleaning.R")

#### DATA ####
# tree inventory
ott_tree_raw <- read_csv("large/trees/ott_tree_raw.csv")
# tree species codes 
ott_tree_spcode <- read_csv("input/ott_tree_spcode.csv")
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
  rename("dbh" = "DBH")
# match scientific names using species codes
ott_tree$SPECIES <- ott_tree_spcode$SPECIES_LATIN[match(as.character(ott_tree$SPECIES), as.character(ott_tree_spcode$SPECIES_COMMON))]
# rename problematic species 
ott_tree$SPECIES[ott_tree$SPECIES == "Hedge Start"] <- "Hedge sp."
ott_tree$SPECIES[ott_tree$SPECIES == "Hedge End"] <- "Hedge sp."
ott_tree$SPECIES[ott_tree$SPECIES == "Other - See Notes"] <- "Unknown sp."
# sorting species name into genus, species, and cultivar columns
ott_tree <- ott_tree %>% separate(SPECIES, c("genus","species","var","cultivar", "cultivar2"))
ott_tree$species[ott_tree$species == "species"] <- "sp."
ott_tree$species[ott_tree$species == "Species"] <- "sp."
ott_tree$species[ott_tree$species == "sp"] <- "sp."
ott_tree$species[ott_tree$species == "X"] <- "x"
ott_tree$species[ott_tree$species == "crabapple"] <- "sp."
ott_tree$species[ott_tree$species == "apple"] <- "sp."
ott_tree$cultivar[ott_tree$cultivar == "Species"] <- NA
ott_tree$var[ott_tree$var == "var"] <- NA
ott_treecul <- ott_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar", "cultivar2"), na.rm = TRUE, sep = " ")%>%
  mutate(cultivar = na_if(cultivar, ""))
ott_treesp <- ott_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ") %>% unite(cultivar, c("cultivar", "cultivar2"), na.rm = TRUE, sep = " ")%>%
  mutate(cultivar = na_if(cultivar, ""))
ott_tree <- rbind(ott_treecul, ott_treesp)
# drop any rows that have NA lat/long
ott_tree <- drop_na(ott_tree, c(lat,long))
# adding geometry column and specify projection outlined in City of Ottawa metadata 
ott_tree <- st_as_sf(x = ott_tree, coords = c("long", "lat"), crs = 4326, na.fail = FALSE, remove = FALSE)

## Final Dataset 
tree_cleaning("Ottawa", ott_tree, ott_park, ott_hood, can_bound, can_road)
