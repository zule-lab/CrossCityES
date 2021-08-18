#### Packages ####
easypackages::packages("tidyverse", "geojsonio", "sf", "broom", "mapproj", "mapview")



#### Downloads ####
# Download Building Density data by municipality the cities belong to
municipality <- c("Alberta", "NovaScotia", "Quebec", "Ontario", "BritishColumbia", "Manitoba")

for (i in 1:length(municipality)){
  build_url <- paste0("https://usbuildingdata.blob.core.windows.net/canadian-buildings-v2/", municipality, ".zip")
  build_dest <- paste0("large/", municipality, "_building_density.zip")
  build_output <- paste0("large/", municipality, "_building_density")
  download.file(build_url[i], build_dest[i], mode="wb")
  unzip(zipfile = build_dest[i], exdir = build_output[i])
}

#### Data ####
## Calgary
# Alberta building footprint
alb_json <- geojson_read("large/Alberta_building_density/Alberta.geojson", what = "sp")
# neighbourhoods
cal_hood <- readRDS("large/CalgaryNeighbourhoodsCleaned.rds")
#roads
cal_road <- readRDS("large/CalgaryRoadsCleaned.rds")
## Halifax
nov_json <- geojson_read("large/NovaScotia_building_density/NovaScotia.geojson", what = "sp")
# neighbourhoods
hal_hood <- readRDS("large/HalifaxNeighbourhoodsCleaned.rds")
#roads
hal_road <- readRDS("large/HalifaxRoadsCleaned.rds")
## Quebec
que_json <- geojson_read("large/Quebec_building_density/Quebec.geojson", what = "sp")
# neighbourhoods
## Ottawa and Toronto
ont_json <- geojson_read("large/Ontario_building_density/Ontario.geojson", what = "sp")
## Vancouver
bco_json <- geojson_read("large/BritishColumbia_building_density/BritishColumbia.geojson", what = "sp")
## Winnipeg
man_json <- geojson_read("large/Manitoba_building_density/Manitoba.geojson", what = "sp")

can_bound <- readRDS("large/MunicipalBoundariesCleaned.rds")

#### Cleanup ####
## Nova Scotia
# convert to sf
nov_sfc <- st_as_sfc(nov_json, GeoJson = TRUE)
nov_sf <- st_as_sf(nov_sfc)
# transform
nov_sf <- st_transform(nov_sf, crs = 6624)
# add city column
nov_build <- nov_sf %>% mutate(city = c("Halifax"))

#### Filter those in cities ####
# intersect with municipal boundaries
hal_build <- nov_sf[can_bound,]

hal_build <- readRDS("large/HalifaxBuildingDensityCleaned.rds")

# calculate building footprint area
hal_build$build_area <- st_area(hal_build$x)
# find building centroid
hal_build$centroid <- st_centroid(hal_build$x)
# remove original building polygons
hal_build$x <- NULL
# Set centroidas geometry of sf
hal_build$centroid <- substr(hal_build$centroid,3,nchar(hal_build$centroid)-1)
hal_build <- separate(data = hal_build, col = centroid, into = c("lat", "long"), sep = "\\, ")
hal_build <- st_as_sf(x = hal_build, coords = c("lat","long"), crs = 6624, na.fail = FALSE, remove = TRUE)
# join building centroids with neighborhoods
hal_build <- st_join(hal_build, hal_hood)
# select only those in Halifax peninsula
hal_build <- hal_build %>% filter(hood %in% "Halifax")
# Group hoods
# define hood areas
# geometry represents all centroids of buildings
hal_build_hoodsum <- hal_build %>% 
  summarise(centroid_den = as.numeric(n()/17.89),
         area_den = as.numeric(sum(build_area*0.000001)/17.89)) %>%
  mutate (hood = c("Halifax"), city = c("Halifax")) %>%
  select(city, hood, centroid_den, area_den, geometry)
# save
saveRDS(hal_build_hoodsum, "large/HalifaxBuildingDensity.rds")

## Roads building density
# Join building centroids with roads
hal_build$street <- st_nearest_feature(hal_build, hal_road)




## Quebec
# convert to sf
que_sfc <- st_as_sfc(que_json, GeoJson = TRUE)
que_sf <- st_as_sf(que_sfc)
# transform
que_sf <- st_transform(que_sf, crs = 6624)

## Manitoba
# convert to sf
man_sfc <- st_as_sfc(man_json, GeoJson = TRUE)
man_sf <- st_as_sf(man_sfc)
# transform
man_sf <- st_transform(man_sf, crs = 6624)

## British Columbia
# convert to sf
bco_sfc <- st_as_sfc(bco_json, GeoJson = TRUE)
bco_sf <- st_as_sf(bco_sfc)
# transform
bco_sf <- st_transform(bco_sf, crs = 6624)
# add city column
bco_build <- bco_sf %>% mutate(city = c("Vancouver"))


