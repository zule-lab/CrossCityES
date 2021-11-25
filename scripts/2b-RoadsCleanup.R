# Script to cleanup Canada roads and city boundary raw data
# Author: Nicole Yu & Isabella Richmond

#### Packages ####
p <- c("sf", "dplyr")
lapply(p, library, character.only = T)

#### Data ####
# Canadian municipal boundaries derived from neighbourhoods
can_bound_raw <- readRDS("large/neighbourhoods/AllNeighbourhoodsCleaned.rds")
# Canadian roads
can_road_raw <- st_read(file.path("/vsizip", "large/national/can_road_raw.zip"))

#### Cleanup ####
## MUNICIPAL BOUNDARIES ##
# select relevant columns and rename 
can_bound <- can_bound_raw %>% 
  group_by(city) %>% 
  summarise()
# save cleaned version
saveRDS(can_bound, "large/national/MunicipalBoundariesCleaned.rds")

## ROADS ##
# select relevant columns 
can_road <- can_road_raw[,c("NAME", "TYPE", "DIR", "NGD_UID", "geometry")]
can_road <- can_road %>%
  rename(street = NAME) %>%
  rename(streettype = TYPE) %>%
  rename(streetdir = DIR) %>%
  rename(streetid = NGD_UID)
# transform
can_road <- st_transform(can_road, crs = 3347)
# intersect with municipal boundaries
can_road <- can_road[can_bound,]
# add city label
can_road <- st_join(can_road, can_bound)
# save cleaned roads 
saveRDS(can_road, "large/national/RoadsCleaned.rds")
