# Script to cleanup Canada roads and city boundary raw data
# Author: Nicole Yu & Isabella Richmond

#### Packages ####
easypackages::packages("tidyverse","sf")

#### Data ####
can_bound_raw <- read_sf("large/can_bound_raw/lcma000b16a_e.shp")
can_road <- read_sf("large/can_road/lrnf000r20a_e.shp")

#### Cleanup ####
## Municipal Boundaries
# select relevant columns and rename 
can_bound <- can_bound_raw %>%
  select(c("CMANAME", "geometry")) %>%
  rename("bound" = "CMANAME")
# select only the cities we are using 
can_bound <- subset(can_bound, bound == "Calgary" | 
                      bound == "Halifax" | 
                      bound == "Montréal" | 
                      bound == "Ottawa - Gatineau (Ontario part / partie de l'Ontario)" | 
                      bound == "Toronto" | 
                      bound == "Vancouver" |
                      bound == "Winnipeg")
# rename Montreal and Ottawa 
can_bound$bound[can_bound$bound == "Montréal"] <- "Montreal"
can_bound$bound[can_bound$bound == "Ottawa - Gatineau (Ontario part / partie de l'Ontario)"] <- "Ottawa"
# transform
can_bound <- st_transform(can_bound, crs = 6624)
# save cleaned version
saveRDS(can_bound, "large/MunicipalBoundariesCleaned.rds")

### Roads ###
# select relevant columns 
can_road <- can_road %>% select(can_road, c(NAME, TYPE, DIR, NGD_UID, geometry)) %>%
  rename(street = NAME) %>%
  rename(streettype = TYPE) %>%
  rename(streetdir = DIR) %>%
  rename(streetid = NGD_UID)
# transform
can_road <- st_transform(can_road, crs = 6624)
# intersect with municipal boundaries
can_road <- can_road[can_bound,]
# add city label
can_road <- st_join(can_road, can_bound)
# save cleaned roads 
saveRDS(can_road, "large/RoadsCleaned.rds")
