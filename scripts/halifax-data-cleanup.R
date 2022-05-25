halifax_data_cleanup <- c(
  
  tar_target(
    hal_park,
    hal_park_raw %>%
      select(c("PARK_NAME", "geometry")) %>%
      rename("park" = "PARK_NAME")
  ),
  
  tar_target(
    hal_tree_s,
    hal_tree_raw %>% 
      filter(ASSETSTAT == "INS") %>%
      select(c("X", "Y", "TREEID", "SP_SCIEN", "DBH")) %>%
      rename("id" = "TREEID") %>%
      rename("dbh" = "DBH") %>% 
      drop_na(hal_tree, c(X,Y)) %>%
      st_as_sf(coords = c("X", "Y"), crs = 4326)
    
  ),
  
  tar_target(
    hal_tree_sp,
    assign_sp_hal(hal_tree_s, hal_tree_spcode, hal_tree_dbhcode)
  ),
  
  tar_target(
    hal_tree,
    tree_cleaning("Halifax", hal_tree_sp, hal_park, hal_hood, mun_bound, mun_road)
  )
  
)