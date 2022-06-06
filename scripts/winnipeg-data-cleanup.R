winnipeg_data_cleanup <- c(
  
  tar_target(
    win_park,
    win_park_raw %>%
      select(c("park_name", "geometry")) %>%
      rename("park" = "park_name")
  ),
  
  tar_target(
    win_tree_s,
    win_tree_raw %>%
      select(c("the_geom","tree_id","botanical","dbh","park","street")) %>%
      rename("id" = "tree_id") %>%
      mutate(the_geom = substr(the_geom,8,nchar(the_geom)-1)) %>%
      separate(col = the_geom, into = c("lat", "long"), sep = "\\ ") %>%
      drop_na(c(lat,long)) %>%
      st_as_sf(coords = c("lat", "long"), crs = 4326, na.fail = FALSE, remove = FALSE)
  ),
  
  tar_target(
    win_tree_sp,
    assign_sp_win(win_tree_s)
  ),
  
  tar_target(
    win_tree,
    tree_cleaning("Winnipeg", win_tree_sp, win_park, win_hood, mun_bound, mun_road)
  )
  
)