building_data_neighbourhood <- c(
  
  tar_target(
    can_build_m,
    can_build %>%
      mutate(build_area = st_area(x),
             centroid = st_centroid(x),
             x = NULL)
  ),
  
  tar_target(
    can_build_cen,
    calc_cen(can_build_m)
  ),
  
  tar_target(
    can_build_j,
    st_join(can_build_cen, can_hood) %>%
      filter(!is.na(hood))
  ),
  
  tar_target(
    can_build_km,
    convert_area(can_build_j)
  ),
  
  tar_target(
    can_build_dens,
    can_build_u %>%
      group_by(hood_id) %>%
      mutate(city = city.x,
             centroids=n(), 
             build_area = sum(build_area),
             centroid_den = as.numeric(centroids/hood_area),
             area_den = as.numeric(build_area/hood_area)) %>%
      distinct(hood, .keep_all = TRUE) %>%
      select(city, hood, hood_id, hood_area, centroids, build_area, centroid_den, area_den)
  )
)