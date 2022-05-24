building_data_cleanup <- c(
  
  tar_target(
    cal_build,
    building_cleanup(alb_json, "Calgary", mun_bound)
  ),
  
  tar_target(
    hal_build,
    building_cleanup(nov_json, "Halifax", mun_bound)
  ),
  
  tar_target(
    mon_build,
    building_cleanup(que_json, "Montreal", mun_bound)
  ),
  
  tar_target(
    van_build,
    building_cleanup(bco_json, "Vancouver", mun_bound)
  ),
  
  tar_target(
    win_build,
    building_cleanup(man_json, "Winnipeg", mun_bound)
  ),
  
  tar_target(
    ont_build,
    st_as_sfc(ont_json, GeoJson = TRUE) %>% 
      st_as_sf() %>%
      st_transform(crs = 3347) %>%
      st_join(., mun_bound) %>% 
      rename(city = bound, x = geometry)
  ),
  
  tar_target(
    ott_build,
    ont_build %>% filter(city %in% "Ottawa")
  ),

  tar_target(
    tor_build,
    ont_build %>% filter(city %in% "Toronto")
  ),
  
  tar_target(
    can_build,
    rbind(cal_build, hal_build, mon_build, ott_build, tor_build, van_build, win_build)
  )
  
)