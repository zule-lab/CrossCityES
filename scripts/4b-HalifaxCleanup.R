#### Halifax public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Halifax public tree inventory

#### PACKAGES #### 
# load packages 
p <- c("sf", "dplyr", "tidyr", "readr")
lapply(p, library, character.only = T)

#### FUNCTIONS ####
source("scripts/function-TreeCleaning.R")

#### DATA ####
# load data downloaded in 1-DataDownload.R
# tree inventory
hal_tree_raw <- read_csv("large/trees/hal_tree_raw.csv")
# parks
hal_park_raw <- st_read(file.path("/vsizip", "large/parks/hal_park_raw.zip"))
# neighbourhoods 
hal_hood <- readRDS("large/neighbourhoods/HalifaxNeighbourhoodsCleaned.rds")
# tree species code
hal_tree_spcode <-read_csv("input/hal_tree_spcode.csv")
# tree dbh code
hal_tree_dbhcode <-read_csv("input/hal_tree_dbhcode.csv")
# municipal boundaries 
can_bound <- readRDS("large/national/MunicipalBoundariesCleaned.rds")
# roads
can_road <- readRDS("large/national/RoadsCleaned.rds")

#### CLEANING ####
## Parks
# select relevant columns and rename 
hal_park <- hal_park_raw %>%
  select(c("PARK_NAME", "geometry")) %>%
  rename("park" = "PARK_NAME")

## Trees
# check for dupes
unique(duplicated(hal_tree_raw$TREEID))
# select only trees in service, columns needed, and rename
hal_tree <- hal_tree_raw %>% 
  filter(ASSETSTAT == "INS") %>%
  select(c("X", "Y", "TREEID", "SP_SCIEN", "DBH")) %>%
  rename("id" = "TREEID") %>%
  rename("dbh" = "DBH")
# recode species from code to scientific name
hal_tree$botname <- hal_tree_spcode$botname[match(as.character(hal_tree$SP_SCIEN), as.character(hal_tree_spcode$code))]
# sorting species name into genus, species, and cultivar columns
hal_tree <- hal_tree %>% separate(botname, c("genus","species","var","cultivar"))
hal_tree$var[hal_tree$var == "var"] <- NA
hal_treecul <- hal_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ")
hal_treesp <- hal_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ")
hal_tree <- rbind(hal_treecul, hal_treesp)
hal_tree$cultivar[hal_tree$cultivar == ""] <- NA
# assign blanks and NAs in species column to "sp."
hal_tree$species[hal_tree$species %in% c("",NA)] <- "sp."
# Assign "species" column as NA for "Unknown Species"
hal_tree$species[hal_tree$species == "Species"] <- NA
# recode dbh from categories to median measurements
hal_tree$dbh <- hal_tree_dbhcode$dbh[match(as.character(hal_tree$dbh), as.character(hal_tree_dbhcode$code))]
# drop geometry NAs
hal_tree <- drop_na(hal_tree, c(X,Y))
# convert to sf object 
hal_tree <- st_as_sf(hal_tree, coords = c("X", "Y"), crs = 4326)

## Final Dataset
tree_cleaning("Halifax", hal_tree, hal_park, hal_hood, can_bound, can_road)
