vancouver_data_cleanup <- c(
  
  tar_target(
    van_park,
    van_park_raw %>%
      select(c("park_name", "geometry")) %>%
      rename("park" = "park_name")
  ),
  
  tar_file_read(
    van_tree_raw_c,
    file.path("large/trees", "van_tree_raw.csv"),
    read.csv(!!.x, sep = ";")# uses ; as separator
  ),
  
  tar_target(
    van_tree_s,
    van_tree_raw_c %>%
      select(c("TREE_ID","GENUS_NAME","SPECIES_NAME","CULTIVAR_NAME","ON_STREET","DIAMETER","Geom")) %>%
      rename("id" = "TREE_ID",
             "genus" = "GENUS_NAME",
             "species" = "SPECIES_NAME",
             "cultivar" = "CULTIVAR_NAME",
             "street" = "ON_STREET",
             "dbh" = "DIAMETER") %>%
      mutate(street = str_to_title(street),
             Geom = sub(".*\\[([^][]+)].*", "\\1", Geom)) %>%
      separate(col = Geom, into = c("long", "lat"), sep = "\\, ") %>%
      drop_na(c(lat,long)) %>%
      st_as_sf(coords = c("long", "lat"), crs = 4326, na.fail = FALSE, remove = FALSE)
  ),
  
  tar_target(
    van_tree_sp,
    assign_sp_van(van_tree_s)
  ),
  
  tar_target(
    van_tree,
    tree_cleaning("Vancouver", van_tree_sp, van_park, van_hood, mun_bound, mun_road)
  )
  
)
