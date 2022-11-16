building_data_neighbourhood <- c(
  
  tar_target(
    can_build_m,
    can_build %>%
      mutate(build_area = st_area(x),
             centroid = st_centroid(x)) %>%
      st_drop_geometry()
  ),
  
  tar_target(
    can_build_cen,
    calc_cen(can_build_m)
  ),
  
  tar_target(
    mun_bound_area,
    mun_bound %>%
      mutate(city_area = st_area(.))
  ),
  
  tar_target(
    mun_road_length,
    mun_road %>%
      mutate(road_length = st_length(.)) 
  ),
  
  tar_target(
    can_build_city,
    st_join(can_build_cen, mun_bound_area) %>%
      filter(!is.na(city))
  ),
  
  tar_target(
    can_build_hood,
    st_join(can_build_cen, can_hood) %>%
      filter(!is.na(hood))
  ),
  
  tar_target(
    can_build_road,
    st_join(can_build_cen, mun_road_length, join = st_nearest_feature)
  ),
  
  tar_target(
    can_build_city_km,
    can_build_city %>%
      mutate(build_area = set_units(build_area, km^2),
             city_area = set_units(city_area, km^2))
  ),
  
  tar_target(
    can_build_hood_km,
    can_build_hood %>%
      mutate(build_area = set_units(build_area, km^2),
             hood_area = set_units(hood_area, km^2))
  ),
  
  tar_target(
    can_build_road_km,
    can_build_road %>%
      mutate(build_area = set_units(build_area, km^2), 
             road_length = set_units(road_length, km))
  ),

  tar_target(
    can_build_city_dens,
    can_build_city_km %>%
      group_by(city) %>%
      mutate(centroids=n(), 
             build_area = sum(build_area),
             centroid_den = as.numeric(centroids/city_area),
             area_den = as.numeric(build_area/city_area)) %>%
      distinct(city, .keep_all = TRUE) %>%
      select(city, city_area, centroids, build_area, centroid_den, area_den)
  ),
  
  tar_target(
    can_build_hood_dens,
    can_build_hood_km %>%
      group_by(hood_id) %>%
      mutate(city = city.x,
             centroids=n(), 
             build_area = sum(build_area),
             centroid_den = as.numeric(centroids/hood_area),
             area_den = as.numeric(build_area/hood_area)) %>%
      distinct(hood, .keep_all = TRUE) %>%
      select(city, hood, hood_id, hood_area, centroids, build_area, centroid_den, area_den)
  ),
  
  tar_target(
    can_build_road_dens,
    can_build_road_km %>%
      group_by(streetid) %>%
      mutate(city = bound,
             centroids=n(), 
             road_length = sum(road_length),
             centroid_den = as.numeric(centroids/road_length),
             area_den = as.numeric(build_area/road_length)) %>%
      distinct(streetid, .keep_all = TRUE) %>%
      select(bound, street, streetdir, streetid, streettype, centroids, build_area, centroid_den, area_den)
  )
)