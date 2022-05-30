building_data_cleanup <- c(
  
  tar_target(
    build_unzip,
    unzip_build()
  ),
  
  tar_file_read(
    alb_json,
    file.path("large/national/ABBuildings", "Alberta.geojson"),
    geojson_read(!!.x, what = "sp")
  ),
  
  tar_file_read(
    nov_json,
    file.path("large/national/NSBuildings", "NovaScotia.geojson"),
    geojson_read(!!.x, what = "sp")
  ),
  
  tar_file_read(
    que_json,
    file.path("large/national/QCBuildings", "Quebec.geojson"),
    geojson_read(!!.x, what = "sp")
  ),
  
  tar_file_read(
    ont_json,
    file.path("large/national/ONBuildings", "Ontario.geojson"),
    geojson_read(!!.x, what = "sp")
  ),
  
  tar_file_read(
    bco_json,
    file.path("large/national/BCBuildings", "BritishColumbia.geojson"),
    geojson_read(!!.x, what = "sp")
  ),
  
  tar_file_read(
    man_json,
    file.path("large/national/MBBuildings", "Manitoba.geojson"),
    geojson_read(!!.x, what = "sp")
  ),

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
      rename(city = CMANAME)
  ),
  
  tar_target(
    ott_build,
    ont_build %>% 
      filter(city %in% "Ottawa - Gatineau (Ontario part / partie de l'Ontario)") %>%
      select(c(geometry, city)) %>%
      rename(x = geometry) %>% 
      mutate(city = replace(city, city == "Ottawa - Gatineau (Ontario part / partie de l'Ontario)", "Ottawa"))
  ),
  
  tar_target(
    tor_build,
    ont_build %>% 
      filter(city %in% "Toronto") %>%
      select(c(geometry, city)) %>%
      rename(x = geometry)
  ),
  
  tar_target(
    can_build,
    rbind(cal_build, hal_build, mon_build, ott_build, tor_build, van_build, win_build)
  )
  
)