# Script to calculate building densities of neighbourhoods of all 7 cities
# Author: Nicole Yu & Isabella Richmond

#### Packages ####
easypackages::packages("tidyverse", "sf", "units")

#### Data ####
# all city building footprints
can_build <- readRDS("large/AllBuildingFootprintsCleaned.rds")
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
can_build <- st_join(can_build, can_hood)
# filter NAs
can_build <- can_build %>% filter(!is.na(hood))
# set units as km^2
units(can_build$build_area) <- make_units(km^2)
units(can_build$hood_area) <- make_units(km^2)
# group by neighbourhood ids and calculate building densities
group_by(hood_id) %>%
  mutate(city = city.x,
         centroids=n(), 
         build_area = sum(build_area),
         centroid_den = as.numeric(centroids/hood_area),
         area_den = as.numeric(build_area/hood_area)) %>%
  distinct(hood, .keep_all = TRUE) %>%
  select(city, hood, hood_id, hood_area, centroids, build_area, centroid_den, area_den)

# save
saveRDS(can_build_hoodsum, "large/HalifaxBuildingDensity.rds")
