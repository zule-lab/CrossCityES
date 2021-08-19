

#### Packages ####
easypackages::packages("tidyverse", "sf")

#### Data ####
# Calgary building footprint
cal_build <- readRDS("large/CalgaryBuildingFootprintsCleaned.rds")
# Calgary neighbourhoods
cal_hood <- readRDS("large/CalgaryNeighbourhoodsCleaned.rds")
# Halifax building footprint
hal_build <- readRDS("large/HalifaxBuildingFootprintsCleaned.rds")
# Halifax neighbourhoods
hal_hood <- readRDS("large/HalifaxNeighbourhoodsCleaned.rds")
# Montreal building footprint
mon_build <- readRDS("large/MontrealBuildingFootprintsCleaned.rds")
# Montreal neighbourhoods
mon_hood <- readRDS("large/MontrealNeighbourhoodsCleaned.rds")
# Ottawa building footprint
ott_build <- readRDS("large/OttawaBuildingFootprintsCleaned.rds")
# Ottawa neighbourhoods
ott_hood <- readRDS("large/OttawaNeighbourhoodsCleaned.rds")
# Toronto building footprint
tor_build <- readRDS("large/TorontoBuildingFootprintsCleaned.rds")
# Toronto neighbourhoods
tor_hood <- readRDS("large/TorontoNeighbourhoodsCleaned.rds")
# Vancouver building footprint
van_build <- readRDS("large/VancouverBuildingFootprintsCleaned.rds")
# Vancouver neighbourhoods
van_hood <- readRDS("large/VancouverNeighbourhoodsCleaned.rds")
# Winnipeg building footprint
win_build <- readRDS("large/WinnipegBuildingFootprintsCleaned.rds")
# Winnipeg neighbourhoods
win_hood <- readRDS("large/WinnipegNeighbourhoodsCleaned.rds")

#### Data ####
# all city building footprints
can_build <- ("large/AllBuildingFootprintsCleaned.rds")
# all city neighbourhoods
can_hood <- readRDS("large/AllNeighbourhoodsCleaned.rds")

#### Data cleanup ####
# calculate building footprint area
can_build$build_area <- st_area(can_build$x)
# find building centroid
can_build$centroid <- st_centroid(can_build$x)
# remove original building polygons
can_build$x <- NULL
# Set centroids geometry of sf
can_build$centroid <- substr(can_build$centroid,3,nchar(can_build$centroid)-1)
can_build <- separate(data = can_build, col = centroid, into = c("lat", "long"), sep = "\\, ")
can_build <- st_as_sf(x = can_build, coords = c("lat","long"), crs = 6624, na.fail = FALSE, remove = TRUE)
# join building centroids with neighborhoods
can_build <- st_join(can_build, hal_hood)
# select only those in Halifax peninsula
can_build <- can_build %>% filter(hood !%in% NA)

# Group hoods
# define hood areas
# geometry represents all centroids of buildings
can_build_hoodsum <- can_build %>% 
  summarise(centroid_den = as.numeric(n()/17.89),
            area_den = as.numeric(sum(build_area*0.000001)/17.89)) %>%
  select(city, hood, centroid_den, area_den, geometry)
# save
saveRDS(can_build_hoodsum, "large/HalifaxBuildingDensity.rds")



# Roads
cal_road <- readRDS("large/CalgaryRoadsCleaned.rds")
hal_road <- readRDS("large/HalifaxRoadsCleaned.rds")
mon_road <- readRDS("large/MontrealRoadsCleaned.rds")
ott_road <- readRDS("large/OttawaRoadsCleaned.rds")
tor_road <- readRDS("large/TorontoRoadsCleaned.rds")
van_road <- readRDS("large/VancouverRoadsCleaned.rds")
win_road <- readRDS("large/WinnipegRoadsCleaned.rds")

## Roads building density
# Join building centroids with roads
can_build$street <- st_nearest_feature(can_build, hal_road)

