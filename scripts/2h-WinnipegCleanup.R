#### Winnipeg public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Winnipeg public tree inventory
# Winnipeg dataset has neighbourhood, streett and park/street column

#### Packages #### 
# load packages 
easypackages::packages("sf", "tidyverse")

#### Data ####
# load data downloaded in 1-DataDownload.R
# tree inventory
win_tree_raw <-read.csv("large/win_tree_raw.csv")

#### Data Cleaning ####
## Trees
# check for dupes
unique(duplicated(win_tree_raw$tree_id))
# add city column
win_tree_raw$city <- c("Winnipeg")
# select the required columns and rename 
win_tree <- win_tree_raw %>%
  select(c("the_geom","tree_id","botanical","dbh","nbhd","park","street","city")) %>%
  rename("id" = "tree_id") %>%
  rename("hood" = "nbhd")
# add streetid column to match other cities
win_tree$streetid <- c(NA)
# sorting species name into genus, species, and cultivar columns
win_tree <- win_tree %>% separate(botanical, c("genus","species","var","cultivar"))
# assign blanks and NAs in species column to "sp."
win_tree$species[win_tree$species %in% c("", NA,"spp")]<-"sp."
win_tree$var[win_tree$var == "var"] <- NA
win_treesp <- win_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ") %>%
  mutate(cultivar = na_if(cultivar, ""))
win_treecul <- win_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ") %>%
  mutate(cultivar = na_if(cultivar, ""))
win_tree <- rbind(win_treecul, win_treesp)
# changing case of hood column
win_tree$hood <- str_to_title(win_tree$hood)
# identifying whether trees are street trees or park trees
win_tree$park <- ifelse(win_tree$park == "Not In Park","no","yes")
## extract coordinates from the_geom column
win_tree$the_geom <- substr(win_tree$the_geom,8,nchar(win_tree$the_geom)-1)
win_tree <- separate(data = win_tree, col = the_geom, into = c("lat", "long"), sep = "\\ ")
# drop any rows that have NA lat/long
win_tree <- drop_na(win_tree, c(lat,long))
# convert to sf object 
win_tree <- st_as_sf(win_tree, coords = c("lat", "long"), crs = 4326)
# transform
win_tree <- st_transform(win_tree, crs = 6624)

#### Remove park trees ####
win_tree <- win_tree %>% filter(park == "no")

#### Save ####
# reorder columns
win_tree <- win_tree[,c("city","id","genus","species","cultivar","geometry","hood","streetid","street","park","dbh")]
# save cleaned Winnipeg tree dataset as rds and shapefile
saveRDS(win_tree, "large/WinnipegTreesCleaned.rds")
st_write(win_tree, "large/WinnipegTreesCleaned.shp")
