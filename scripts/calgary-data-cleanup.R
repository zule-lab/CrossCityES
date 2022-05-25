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
    cal_tree_s,
    cal_tree_raw %>%
      select(c("GENUS", "SPECIES", "CULTIVAR", "DBH_CM", "WAM_ID", "POINT")) %>%
      rename("genus" = "GENUS",
             "species" = "SPECIES",
             "cultivar" = "CULTIVAR",
             "dbh" = "DBH_CM",
             "id" = "WAM_ID",
             "geometry" = "POINT") %>% 
      drop_na(geometry) %>%
      st_as_sf(wkt = "geometry", crs = 4326)
  ),
  
  tar_target(
    cal_tree_sp,
    assign_sp_cal(cal_tree_s)
  ),
  
  tar_target(
    cal_tree,
    tree_cleaning("Calgary", cal_tree_s, cal_park, cal_hood, mun_bound, mun_road)
  )
  
)