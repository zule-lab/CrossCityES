#### Winnipeg public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Winnipeg public tree inventory

#### PACKAGES #### 
# load packages 
p <- c("sf", "dplyr", "tidyr", "readr")
lapply(p, library, character.only = T)

#### FUNCTIONS ####
source("scripts/function-TreeCleaning.R")

#### DATA ####
# tree inventory
win_tree_raw <- read_csv("large/trees/win_tree_raw.csv")
# parks 
win_park_raw <- st_read(file.path("/vsizip", "large/parks/win_park_raw.zip"))
# neighbourhoods
win_hood <- readRDS("large/neighbourhoods/WinnipegNeighbourhoodsCleaned.rds")
# municipal boundaries 
can_bound <- readRDS("large/national/MunicipalBoundariesCleaned.rds")
# roads 
can_road <- readRDS("large/national/RoadsCleaned.rds")

#### Data Cleaning ####
## Parks 
win_park <- win_park_raw %>%
  select(c("park_name", "geometry")) %>%
  rename("park" = "park_name")

## Trees
# check for dupes
unique(duplicated(win_tree_raw$tree_id))
# select the required columns and rename 
win_tree <- win_tree_raw %>%
  select(c("the_geom","tree_id","botanical","dbh","park","street")) %>%
  rename("id" = "tree_id")
# recode problematic species names 
win_tree$botanical[win_tree$botanical == "Not Available"] <- "Unknown sp."
# sorting species name into genus, species, and cultivar columns
win_tree <- win_tree %>% separate(botanical, c("genus","species","var","cultivar"))
# assign blanks and NAs in species column to "sp."
win_tree$species[win_tree$species %in% c("", NA,"spp")]<-"sp."
win_tree$species[win_tree$species == "sp"] <- "sp."
win_tree$var[win_tree$var == "var"] <- NA
win_treesp <- win_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ") %>%
  mutate(cultivar = na_if(cultivar, ""))
win_treecul <- win_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ") %>%
  mutate(cultivar = na_if(cultivar, ""))
win_tree <- rbind(win_treecul, win_treesp)
# identifying whether trees are street trees or park trees
win_tree$park <- ifelse(win_tree$park == "Not In Park","no","yes")
## extract coordinates from the_geom column
win_tree$the_geom <- substr(win_tree$the_geom,8,nchar(win_tree$the_geom)-1)
win_tree <- separate(data = win_tree, col = the_geom, into = c("lat", "long"), sep = "\\ ")
# drop any rows that have NA lat/long
win_tree <- drop_na(win_tree, c(lat,long))
# convert to sf object 
win_tree <- st_as_sf(win_tree, coords = c("lat", "long"), crs = 4326)

## Final Dataset 
tree_cleaning("Winnipeg", win_tree, win_park, win_hood, can_bound, can_road)
