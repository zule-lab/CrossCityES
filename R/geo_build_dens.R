geo_build_dens <- function(mun_bound, can_build_cen, scale){
  
  if (scale == 'city'){
    
    mun_bound_area <- mun_bound %>%
      mutate(city_area = st_area(.))
    
    can_build_city <- st_join(can_build_cen, mun_bound_area) %>%
      filter(!is.na(city))
    
    can_build_city_km <-  can_build_city %>%
      mutate(build_area = set_units(build_area, km^2),
             city_area = set_units(city_area, km^2))
    
    
    can_build_city_dens <- can_build_city_km %>%
      group_by(city) %>%
      mutate(centroids=n(), 
             build_area = sum(build_area),
             centroid_den = as.numeric(centroids/city_area),
             area_den = as.numeric(build_area/city_area)) %>%
      distinct(city, .keep_all = TRUE) %>%
      select(city, city_area, centroids, build_area, centroid_den, area_den)
    
    return(can_build_city_dens)

    
  }
  
  else if (scale == 'neighbourhood'){
    
    can_build_hood <- st_join(can_build_cen, mun_bound) %>%
      filter(!is.na(hood))
    
    can_build_hood_km <-  can_build_hood %>%
      mutate(build_area = set_units(build_area, km^2),
             hood_area = set_units(hood_area, km^2))
    
    can_build_hood_dens <- can_build_hood_km %>%
      group_by(hood_id) %>%
      mutate(city = city.x,
             centroids=n(), 
             build_area = sum(build_area),
             centroid_den = as.numeric(centroids/hood_area),
             area_den = as.numeric(build_area/hood_area)) %>%
      distinct(hood, .keep_all = TRUE) %>%
      select(city, hood, hood_id, hood_area, centroids, build_area, centroid_den, area_den)
    
  }
  
  else if (scale == 'road'){
    
    road_bound_area <- mun_bound %>%
      mutate(road_area = st_area(.))
    
    can_build_road <- st_join(can_build_cen, road_bound_area) %>%
      filter(!is.na(CMANAME))
    
    can_build_road_km <-  can_build_road %>%
      mutate(build_area = set_units(build_area, km^2),
             road_area = set_units(road_area, km^2))
    
    can_build_road_dens <- can_build_road_km %>%
      group_by(streetid) %>%
      mutate(centroids=n(), 
             build_area = sum(build_area),
             centroid_den = as.numeric(centroids/road_area),
             area_den = as.numeric(build_area/road_area)) %>%
      distinct(streetid, .keep_all = TRUE) %>%
      select(city, street, streettype, streetdir, streetid, centroids, build_area, road_area, centroid_den, area_den)
    
    }
  
  else {
    print("error: none of the boundary names matched")
  }


  
  
}
