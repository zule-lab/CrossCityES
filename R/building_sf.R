building_sf <- function(dl_path, mun_bound_trees){

  unzip(dl_path, exdir = sans_ext(dl_path))
  
  path <- unzip(dl_path, exdir = sans_ext(dl_path))
  
  gjson <- geojson_read(file.path(path), what = "sp")
  
  geo_sf <- building_cleanup(dl_path, gjson, mun_bound_trees)
  
  return(geo_sf)
  
}


building_cleanup <- function(p, g, mun_bound_trees){
  
  if (p == "large/national/BritishColumbia_Buildings.zip"){
    geo <- st_as_sfc(g, GeoJson = TRUE)
    geo_sf <- st_as_sf(geo)
    geo_t <- st_transform(geo_sf, crs = 3347)
    geo_c <- geo_t %>% mutate(city = c("Vancouver"))
    geo_build <- geo_c[mun_bound_trees,]
    
    return(geo_build)
  }
  
  else if (p == "large/national/Alberta_Buildings.zip"){
    geo <- st_as_sfc(g, GeoJson = TRUE)
    geo_sf <- st_as_sf(geo)
    geo_t <- st_transform(geo_sf, crs = 3347)
    geo_c <- geo_t %>% mutate(city = c("Calgary"))
    geo_build <- geo_c[mun_bound_trees,]
    
    return(geo_build)
   
  }
  
  else if (p == "large/national/Manitoba_Buildings.zip"){
    geo <- st_as_sfc(g, GeoJson = TRUE)
    geo_sf <- st_as_sf(geo)
    geo_t <- st_transform(geo_sf, crs = 3347)
    geo_c <- geo_t %>% mutate(city = c("Winnipeg"))
    geo_build <- geo_c[mun_bound_trees,]
    
    return(geo_build)
   
  }
  
  else if (p == "large/national/Ontario_Buildings.zip"){
      
    geo <- st_as_sfc(g, GeoJson = TRUE) %>% 
        st_as_sf() %>%
        st_transform(crs = 3347) %>%
        st_intersection(., mun_bound_trees) %>% 
        rename(city = CMANAME) %>%
        select(c(x, city))
    
      return(geo)
    
  }
  
  
  else if (p == "large/national/Quebec_Buildings.zip"){
    geo <- st_as_sfc(g, GeoJson = TRUE)
    geo_sf <- st_as_sf(geo)
    geo_t <- st_transform(geo_sf, crs = 3347)
    geo_c <- geo_t %>% mutate(city = c("Montreal"))
    geo_build <- geo_c[mun_bound_trees,]
    
    return(geo_build)

  }
  
  else if (p == "large/national/NovaScotia_Buildings.zip"){
    geo <- st_as_sfc(g, GeoJson = TRUE)
    geo_sf <- st_as_sf(geo)
    geo_t <- st_transform(geo_sf, crs = 3347)
    geo_c <- geo_t %>% mutate(city = c("Halifax"))
    geo_build <- geo_c[mun_bound_trees,]
    
    return(geo_build)

  } 
  
  else{
    print("error: none of the province names matched")
  }
}
