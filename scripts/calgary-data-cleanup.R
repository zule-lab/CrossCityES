calgary_data_cleanup <- c(
  
  tar_target(
    cal_park,
    cal_park_raw %>%
      select(c("SITE_NAME", "the_geom")) %>%
      rename("park" = "SITE_NAME") %>%
      rename("geometry" = "the_geom") %>%
      st_as_sf(wkt = "geometry", crs = 4326)
  ),
  
  tar_target(
    cal_tree_sp,
    assign_sp_cal(cal_tree_raw)
  ),
  
  tar_target(
    cal_tree_s,
    cal_tree_sp %>%
      select(c("GENUS", "SPECIES", "CULTIVAR", "DBH_CM", "WAM_ID", "latitude", "longitude")) %>%
      rename("genus" = "GENUS") %>% 
      rename("species" = "SPECIES") %>%
      rename("cultivar" = "CULTIVAR") %>%
      rename("dbh" = "DBH_CM") %>%
      rename("id" = "WAM_ID") %>%
      drop_na(c(latitude,longitude)) %>%
      st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
  ),
  
  tar_target(
    cal_tree,
    tree_cleaning("Calgary", cal_tree_s, cal_park, cal_hood, mun_bound, mun_road)
  )
  
)