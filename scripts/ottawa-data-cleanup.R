ottawa_data_cleanup <- c(
  
  tar_target(
    ott_park,
    ott_park_raw %>%
      select(c("NAME", "geometry")) %>%
      rename("park" = "NAME")
  ),
  
  tar_target(
    ott_tree_s,
    ott_tree_raw %>%
      select(c("X","Y","OBJECTID","ADDSTR","SPECIES","DBH")) %>%
      rename("long" = "X") %>%
      rename("lat" = "Y") %>%
      rename("id" = "OBJECTID") %>%
      rename("street" = "ADDSTR") %>%
      rename("dbh" = "DBH")
  ),
  
  tar_target(
    ott_tree_sp,
    assign_sp_ott(ott_tree_s, ott_tree_spcode)
  ),
  
  tar_target(
    mon_tree,
    tree_cleaning("Ottawa", ott_tree_sp, ott_park, ott_hood, mun_bound, mun_road)
  )
  
)