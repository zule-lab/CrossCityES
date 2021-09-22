#### Vancouver public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Vancouver public tree inventory

#### PACKAGES #### 
# load packages 
p <- c("sf", "dplyr", "tidyr", "stringr")
lapply(p, library, character.only = T)

#### FUNCTIONS ####
source("scripts/function-TreeCleaning.R")

#### DATA ####
# tree inventory
van_tree_raw <- read.csv("large/trees/van_tree_raw.csv", sep=";")
# parks
van_park_raw <- st_read(file.path("/vsizip", "large/parks/van_park_raw.zip"))
# neighbourhoods
van_hood <- readRDS("large/neighbourhoods/VancouverNeighbourhoodsCleaned.rds")
# municipal boundaries 
can_bound <- readRDS("large/national/MunicipalBoundariesCleaned.rds")
# roads
can_road <- readRDS("large/national/RoadsCleaned.rds")

#### CLEANING ####
## Parks
# select relevant columns and rename 
van_park <- van_park_raw %>%
  select(c("park_name", "geometry")) %>%
  rename("park" = "park_name")

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
# change case of characters
van_tree$street <- str_to_title(van_tree$street) 
# change "species in species" column to "sp."
van_tree$species[van_tree$species == "SPECIES"] <- "sp."
van_tree$species[van_tree$species == "XX"] <- "sp."
# convert empty as NA for cultivar
van_tree$cultivar[van_tree$cultivar == ""] <- NA
# converting dbh from inches to cm
van_tree$dbh <- van_tree$dbh*2.54
# data is formatted as GeoJSON
van_tree$Geom <- substr(van_tree$Geom,35,nchar(van_tree$Geom)-2)
van_tree <- separate(data = van_tree, col = Geom, into = c("long", "lat"), sep = "\\, ")
# drop any rows that have NA lat/long
van_tree <- drop_na(van_tree, c(lat,long))
van_tree <- st_as_sf(x = van_tree, coords = c("long", "lat"), crs = 4326, na.fail = FALSE, remove = FALSE)

## Final Dataset ## 
tree_cleaning("Vancouver", van_tree, van_park, van_hood, can_bound, can_road)
