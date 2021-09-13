#### Calgary public tree inventory cleanup ####
# Author: Nicole Yu

# This script is for cleaning the Calgary public tree inventory
# Still require street, neighbourhood, street, and park/street tree columns

#### PACKAGES #### 
# load packages 
p <- c("sf", "dplyr", "readr")
lapply(p, library, character.only = T)

#### FUNCTIONS ####
tree_cleaning <- function(city, trees, parks, hoods, boundaries, roads){
  p <- c("sf", "dplyr", "tidyr")
  lapply(p, library, character.only = T)
  
  parks <- st_transform(parks, crs = 3347)
  trees <- st_transform(trees, crs = 3347)
  saveRDS(parks, paste0("large/parks/", city, "ParksCleaned.rds"))
  
  city_bound <- subset(boundaries, bound == city)
  city_road <- roads[city_bound,]
  city_road <- select(city_road, c("street", "streetid", "geometry"))
  city_road <- city_road %>% mutate(index = 1:n())
  saveRDS(city_road, paste0("large/national/", city, "RoadsCleaned.rds"))
  
  trees <- st_join(trees, hoods, join = st_intersects)
  trees <- st_join(trees, parks, join = st_intersects)
  
  dup <- trees$id[duplicated(trees$id)]
  trees <- trees %>% filter(!id %in% dup)
  # replace NAs with "no" to indicate street trees 
  trees <- mutate(trees, park = replace_na(park, "no"))
  # if value is not "no", change value to "yes" so park column is binary yes/no
  trees <- mutate(trees, park = ifelse(park == "no", "no", "yes"))
  # st_nearest_feature returns the index value not the street name
  trees <- mutate(trees, streetid = st_nearest_feature(trees, city_road))
  # return unique streetid based on index values
  #trees <- mutate(trees, streetid = city_road$streetid[match(as.character(trees$streetid), as.character(city_road$index))])
  # add column with street name
  #trees <- mutate(trees, street = match(as.character(trees$streetid), as.character(city_road$streetid)))
  
  trees <- trees %>% filter(park == "no")
  
  trees <- trees[city_bound,]
  
  # reorder columns
  trees <- trees[,c("city","id","genus", "species", "cultivar", "geometry","hood","streetid","park", "street", "dbh")]# Check and make output
  
  saveRDS(trees,  paste0("large/trees/", city, "TreesCleaned.rds"))
}

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

