toronto_data_cleanup <- c(
  
  tar_target(
    tor_park,
    tor_park_raw %>%
      select(c("OBJECTID", "geometry")) %>%
      rename("park" = "OBJECTID")
  ),
  
  tar_target(
    tor_tree_s,
    tor_tree_raw %>%
      select(c("STRUCTID","DBH_TRUNK","COMMON_NAME", "STREETNAME","geometry")) %>%
      rename("id" = "STRUCTID",
             "street" = "STREETNAME",
             "dbh" = "DBH_TRUNK") %>%
      mutate(street = str_to_title(street),
             geometry = substr(geometry,38,nchar(geometry)-2)) %>%
      separate(col = geometry, into = c("long", "lat"), sep = "\\, ") %>%
      drop_na(c(lat,long)) %>%
      st_as_sf(coords = c("long", "lat"), crs = 4326, na.fail = FALSE, remove = FALSE)
  ),
  
  tar_target(
    tor_tree_sp,
    assign_sp_tor(tor_tree_s, tor_tree_spcode)
  ),
  
  tar_target(
    tor_tree,
    tree_cleaning("Toronto", tor_tree_sp, tor_park, tor_hood, mun_bound, mun_road)
  )
  
)