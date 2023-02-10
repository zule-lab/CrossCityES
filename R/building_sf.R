building_sf <- function(dl_link, dl_path, file_ext){
  
  download_file(dl_link, dl_path, file_ext)
  
  unzip(dl_path, exdir = sans_ext(dl_path))
  
  path <- unzip(dl_path, exdir = sans_ext(dl_path))
  
  gjson <- geojson_read(file.path(path), what = "sp")
  
  geo_sf <- building_cleanup(dl_path, gjson)
  
  
  
}


building_cleanup <- function(p, g){
  
  boundary <- tar_read(mun_bound_clean)
  
  if (p == "large/national/BritishColumbia_Buildings.zip"){
    geo <- st_as_sfc(g, GeoJson = TRUE)
    geo_sf <- st_as_sf(geo)
    geo_t <- st_transform(geo_sf, crs = 3347)
    geo_c <- geo_t %>% mutate(city = c("Vancouver"))
    geo_build <- geo_c[boundary,]
    
    return(geo_build)
  }
  
  else if (p == "large/national/Alberta_Buildings.zip"){
    geo <- st_as_sfc(g, GeoJson = TRUE)
    geo_sf <- st_as_sf(geo)
    geo_t <- st_transform(geo_sf, crs = 3347)
    geo_c <- geo_t %>% mutate(city = c("Calgary"))
    geo_build <- geo_c[boundary,]
    
    return(geo_build)
   
  }
  
  else if (p == "large/national/Manitoba_Buildings.zip"){
    geo <- st_as_sfc(g, GeoJson = TRUE)
    geo_sf <- st_as_sf(geo)
    geo_t <- st_transform(geo_sf, crs = 3347)
    geo_c <- geo_t %>% mutate(city = c("Winnipeg"))
    geo_build <- geo_c[boundary,]
    
    return(geo_build)
   
  }
  
  else if (p == "large/national/Ontario_Buildings.zip"){
      
    geo <- st_as_sfc(g, GeoJson = TRUE) %>% 
        st_as_sf() %>%
        st_transform(crs = 3347) %>%
        st_join(., boundary) %>% 
        rename(city = CMANAME)
      

      geo_build <- geo %>% 
        filter(city %in% c("Ottawa", "Toronto")) %>%
        select(c(geometry, city)) %>%
        rename(x = geometry) 
    
      return(geo_build)
    
  }
  
  
  else if (p == "large/national/Quebec_Buildings.zip"){
    geo <- st_as_sfc(g, GeoJson = TRUE)
    geo_sf <- st_as_sf(geo)
    geo_t <- st_transform(geo_sf, crs = 3347)
    geo_c <- geo_t %>% mutate(city = c("Montreal"))
    geo_build <- geo_c[boundary,]
    
    return(geo_build)

  }
  
  else if (p == "large/national/NovaScotia_Buildings.zip"){
    geo <- st_as_sfc(g, GeoJson = TRUE)
    geo_sf <- st_as_sf(geo)
    geo_t <- st_transform(geo_sf, crs = 3347)
    geo_c <- geo_t %>% mutate(city = c("Halifax"))
    geo_build <- geo_c[boundary,]
    
    return(geo_build)

  } 
  
  else{
    print("error: none of the province names matched")
  }
}
