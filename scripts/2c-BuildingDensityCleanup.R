easypackages::packages("tidyverse", "geojsonio", "sf", "broom", "mapproj", "mapview")

can_bound <- readRDS("large/MunicipalBoundariesCleaned.rds")
hal_hood <- readRDS("large/HalifaxNeighbourhoodsCleaned.rds")
hal_road <- readRDS("large/HalifaxRoadsCleaned.rds")

#### Downloads ####
municipality <- c("Alberta", "NovaScotia", "Quebec", "Ontario", "BritishColumbia", "Manitoba")

for (i in 1:length(municipality)){
  build_url <- paste0("https://usbuildingdata.blob.core.windows.net/canadian-buildings-v2/", municipality, ".zip")
  build_dest <- paste0("large/", municipality, "_building_density.zip")
  build_output <- paste0("large/", municipality, "_building_density")
  download.file(build_url[i], build_dest[i], mode="wb")
  unzip(zipfile = build_dest[i], exdir = build_output[i])
}

#### Reading geojson and convertinf to sf

alb_json <- geojson_read("large/Alberta_building_density/Alberta.geojson", what = "sp")
nov_json <- geojson_read("large/NovaScotia_building_density/NovaScotia.geojson", what = "sp")
que_json <- geojson_read("large/Quebec_building_density/Quebec.geojson", what = "sp")
ont_json <- geojson_read("large/Ontario_building_density/Ontario.geojson", what = "sp")
man_json <- geojson_read("large/Manitoba_building_density/BritishColumbia.geojson", what = "sp")
tor_json <- geojson_read("large/Toronto_building_density/Toronto.geojson", what = "sp")

nov_sfc <- st_as_sfc(nov_json, GeoJson = TRUE)
nov_sf <- st_as_sf(nov_sfc)
nov_sf <- st_transform(nov_sf, crs = 6624)
#### Filter those in Halifax ####
# intersect with municipal boundaries
hal_build <- nov_sf[can_bound,]
# Add city column and rename geometry column
hal_build <- hal_build %>%
  rename(geometry = x)
# find building centroid
hal_build$centroid <- st_centroid(hal_build$x)
# save so no need to go through can_bound selection again
saveRDS(hal_build, "large/HalifaxBuildingDensityCleaned.rds")
hal_build_one <- hal_build
# Set centroid  as geometry of sf
hal_build_one$centroid <- substr(hal_build_one$centroid,3,nchar(hal_build_one$centroid)-1)
hal_build_one <- separate(data = hal_build_one, col = centroid, into = c("lat", "long"), sep = "\\, ")
hal_build_one$x <- NULL
hal_build_one <- st_as_sf(x = hal_build_one, coords = c("lat","long"), crs = 6624, na.fail = FALSE, remove = FALSE)
# Join building centroids with neighborhoods
hal_build_one <- st_join(hal_build_one, hal_hood)
# Select only those in Halifax peninsula
hal_build_one <- hal_build_one %>% filter(hood %in% "Halifax")

# Join building centroids with roads
hal_build_one$street <- st_nearest_feature(hal_build_one, hal_road)

hal_build_one <- hal_build

#### save
saveRDS(hal_build_one, "large/HalifaxBuildingDensityTrial.rds")
