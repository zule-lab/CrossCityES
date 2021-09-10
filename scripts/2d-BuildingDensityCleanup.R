# Script to download public tree inventories
# Authors: Nicole Yu & Isabella Richmond

#### PACKAGES ####
p <- c("sf", "dplyr", "geojsonio")
lapply(p, library, character.only = T)

#### FUNCTION ####
building_cleanup <- function(geo, city, boundary, dest){
  p <- c("sf", "dplyr")
  lapply(p, library, character.only = T)
  geo <- st_as_sfc(geo, GeoJson = TRUE)
  geo <- st_as_sf(geo)
  geo <- st_transform(geo, crs = 3347)
  geo <- geo %>% mutate(city = c(city))
  geo_build <- geo[boundary,]
  saveRDS(geo_build, dest)
  readRDS(dest)
  
}

#### DATA ####
# Alberta
unzip("large/national/Alberta_building_density.zip", exdir = "large/national/ABBuildings")
alb_json <- geojson_read("large/national/ABBuildings/Alberta.geojson", what = "sp")
# Nova Scotia
unzip("large/national/NovaScotia_building_density.zip", exdir = "large/national/NSBuildings")
nov_json <- geojson_read("large/national/NSBuildings/NovaScotia.geojson", what = "sp")
# Quebec
unzip("large/national/Quebec_building_density.zip", exdir = "large/national/QCBuildings")
que_json <- geojson_read("large/national/QCBuildings/Quebec.geojson", what = "sp")
# Ontario
unzip("large/national/Ontario_building_density.zip", exdir = "large/national/ONBuildings")
ont_json <- geojson_read("large/national/ONBuildings/Ontario.geojson", what = "sp")
# British Columbia
unzip("large/national/BritishColumbia_building_density.zip", exdir = "large/national/BCBuildings")
bco_json <- geojson_read("large/national/BCBuildings/BritishColumbia.geojson", what = "sp")
# Manitoba
unzip("large/national/Manitoba_building_density.zip", exdir = "large/national/MBBuildings")
man_json <- geojson_read("large/national/MBBuildings/Manitoba.geojson", what = "sp")
# municipal boundaries
can_bound <- readRDS("large/national/MunicipalBoundariesCleaned.rds")

#### CLEANUP ####
# Calgary
cal_build <- building_cleanup(alb_json, "Calgary", can_bound, "large/national/CalgaryBuildings.rds")
# Halifax 
hal_build <- building_cleanup(nov_json, "Halifax", can_bound, "large/national/HalifaxBuildings.rds")
# Montreal 
mon_build <- building_cleanup(que_json, "Montreal", can_bound, "large/national/MontrealBuildings.rds")
# Vancouver
van_build <- building_cleanup(bco_json, "Vancouver", can_bound, "large/national/VancouverBuildings.rds")
# Winnipeg 
win_build <- building_cleanup(man_json, "Winnipeg", can_bound, "large/national/WinnipegBuildings.rds")
# Ottawa 
ont_sfc <- st_as_sfc(ont_json, GeoJson = TRUE)
ont_sf <- st_as_sf(ont_sfc)
ont_sf <- st_transform(ont_sf, crs = 3347)
ont_build <- st_join(ont_sf, can_bound)
ont_build <- ont_build %>% 
  rename(city = bound, x = geometry)
ott_build <- ont_build %>% filter(city %in% "Ottawa")
saveRDS(ott_build, "large/national/OttawaBuildings.rds")
# Toronto
tor_build <- ont_build %>% filter(city %in% "Toronto")
saveRDS(tor_build, "large/national/TorontoBuildings.rds")

#### COMBINE ####
can_build <- rbind(cal_build, hal_build, mon_build, ott_build, tor_build, van_build, win_build)
saveRDS(can_build, "large/national/AllBuildingsCleaned.rds")
