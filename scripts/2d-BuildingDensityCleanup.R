# Script to download public tree inventories
# Authors: Nicole Yu & Isabella Richmond

#### Packages ####
easypackages::packages("tidyverse", "geojsonio", "sf")

#### Data ####
# Alberta building footprint
alb_json <- geojson_read("large/Alberta_building_density/Alberta.geojson", what = "sp")
# Nova Scotia building footprint
nov_json <- geojson_read("large/NovaScotia_building_density/NovaScotia.geojson", what = "sp")
# Quebec building footprint
que_json <- geojson_read("large/Quebec_building_density/Quebec.geojson", what = "sp")
# Ontario building footprint
ont_json <- geojson_read("large/Ontario_building_density/Ontario.geojson", what = "sp")
# British Columbia building footprint
bco_json <- geojson_read("large/BritishColumbia_building_density/BritishColumbia.geojson", what = "sp")
# Manitoba building footprint
man_json <- geojson_read("large/Manitoba_building_density/Manitoba.geojson", what = "sp")
# municipal Boundaries
can_bound <- readRDS("large/MunicipalBoundariesCleaned.rds")

#### Data Cleanup ####
## Calgary
# convert to sf
alb_sfc <- st_as_sfc(alb_json, GeoJson = TRUE)
alb_sf <- st_as_sf(alb_sfc)
# transform
alb_sf <- st_transform(alb_sf, crs = 6624)
# add city column
alb_sf <- alb_sf %>% mutate(city = c("Calgary"))
# intersect with municipal boundaries
cal_build <- alb_sf[can_bound,]
# save
saveRDS(cal_build, "large/CalgaryBuildingFootprintsCleaned.rds")

## Halifax
# convert to sf
nov_sfc <- st_as_sfc(nov_json, GeoJson = TRUE)
nov_sf <- st_as_sf(nov_sfc)
# transform
nov_sf <- st_transform(nov_sf, crs = 6624)
# add city column
nov_sf <- nov_sf %>% mutate(city = c("Halifax"))
# intersect with municipal boundaries
hal_build <- nov_sf[can_bound,]
# save
saveRDS(hal_build, "large/HalifaxBuildingFootprintsCleaned.rds")

## Montreal
# convert to sf
que_sfc <- st_as_sfc(que_json, GeoJson = TRUE)
que_sf <- st_as_sf(que_sfc)
# transform
que_sf <- st_transform(que_sf, crs = 6624)
# add city column
que_sf <- que_sf %>% mutate(city = c("Montreal"))
# intersect with municipal boundaries
mon_build <- que_sf[can_bound,]
# save
saveRDS(mon_build, "large/MontrealBuildingFootprintsCleaned.rds")

## Ottawa
# convert to sf
ont_sfc <- st_as_sfc(ont_json, GeoJson = TRUE)
ont_sf <- st_as_sf(ont_sfc)
# transform
ont_sf <- st_transform(ont_sf, crs = 6624)
# join with municipal boundaries
ont_build <- st_join(ont_sf, can_bound)
# change column names
ont_build <- ont_build %>% 
  rename(city = bound, x = geometry)
# save for Ottawa
ott_build <- ont_build %>% filter(city %in% "Ottawa")
saveRDS(ott_build, "large/OttawaBuildingFootprintsCleaned.rds")
# save for Toronto
tor_build <- ont_build %>% filter(city %in% "Toronto")
saveRDS(tor_build, "large/TorontoBuildingFootprintsCleaned.rds")

## British Columbia
# convert to sf
bco_sfc <- st_as_sfc(bco_json, GeoJson = TRUE)
bco_sf <- st_as_sf(bco_sfc)
# transform
bco_sf <- st_transform(bco_sf, crs = 6624)
# add city column
bco_sf <- bco_sf %>% mutate(city = c("Vancouver"))
# intersect with municipal boundaries
van_build <- bco_sf[can_bound,]
# save
saveRDS(van_build, "large/VancouverBuildingFootprintsCleaned.rds")

## Manitoba
# convert to sf
man_sfc <- st_as_sfc(man_json, GeoJson = TRUE)
man_sf <- st_as_sf(man_sfc)
# transform
man_sf <- st_transform(man_sf, crs = 6624)
# add city column
man_sf <- man_sf %>% mutate(city = c("Winnipeg"))
# intersect with municipal boundaries
win_build <- man_sf[can_bound,]
# save
saveRDS(win_build, "large/WinnipegBuildingFootprintsCleaned.rds")

## All 7 city building densities
# combine all 7 files
can_build <- rbind(cal_build, hal_build, mon_build, ott_build, tor_build, van_build, win_build)
# save
saveRDS(can_build, "large/AllBuildingFootprintsCleaned.rds")


