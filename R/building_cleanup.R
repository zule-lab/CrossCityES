building_cleanup <- function(geo, city, boundary){
  
  geo <- st_as_sfc(geo, GeoJson = TRUE)
  geo <- st_as_sf(geo)
  geo <- st_transform(geo, crs = 3347)
  geo <- geo %>% mutate(city = c(city))
  geo_build <- geo[boundary,]
  saveRDS(geo_build, dest)
  readRDS(dest)
  
}