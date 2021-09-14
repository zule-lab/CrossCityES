#### Calgary public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Calgary public tree inventory

#### PACKAGES #### 
# load packages 
p <- c("sf", "dplyr", "tidyr", "readr")
lapply(p, library, character.only = T)

#### FUNCTIONS ####
source("scripts/function-TreeCleaning.R")

#### DATA ####
# load data downloaded in 1-DataDownload.R
# tree inventory
cal_tree_raw <- read_csv("large/trees/cal_tree_raw.csv")
# parks
cal_park_raw <- read_csv("large/parks/cal_park_raw.csv")
# neighbourhoods 
cal_hood <- readRDS("large/neighbourhoods/CalgaryNeighbourhoodsCleaned.rds")
# municipal boundaries 
can_bound <- readRDS("large/national/MunicipalBoundariesCleaned.rds")
# roads
can_road <- readRDS("large/national/RoadsCleaned.rds")

#### CLEANING ####
## Parks
# select relevant columns and rename 
cal_park <- cal_park_raw %>%
  select(c("SITE_NAME", "the_geom")) %>%
  rename("park" = "SITE_NAME") %>%
  rename("geometry" = "the_geom")
# convert to sf object 
cal_park <- st_as_sf(cal_park, wkt = "geometry", crs = 4326)

## Trees
# check for dupes
unique(duplicated(cal_tree_raw$WAM_ID))
# select the required columns and rename 
cal_tree <- cal_tree_raw %>%
  select(c("GENUS", "SPECIES", "CULTIVAR", "DBH_CM", "WAM_ID", "latitude", "longitude")) %>%
  rename("genus" = "GENUS") %>% 
  rename("species" = "SPECIES") %>%
  rename("cultivar" = "CULTIVAR") %>%
  rename("dbh" = "DBH_CM") %>%
  rename("id" = "WAM_ID")
# assign blanks and NAs in species column to "sp."
cal_tree$species[cal_tree$species %in% c("",NA)]<-"sp."
# remove quotations from cultivar names 
cal_tree$cultivar <- substr(cal_tree$cultivar,2,nchar(cal_tree$cultivar)-1)
# drop geometry NAs
cal_tree <- drop_na(cal_tree, c(latitude,longitude))
# convert to sf object 
cal_tree <- st_as_sf(cal_tree, coords = c("longitude", "latitude"), crs = 4326)

## Final Dataset
t <- tree_cleaning("Calgary", cal_tree, cal_park, cal_hood, can_bound, can_road)

