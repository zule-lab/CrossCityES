targets_montreal_cleanup <- c(
  
  #tar_target(
  #  mon_tree_raw,
  #  fread("large/trees/mon_tree_raw.csv", encoding = "UTF-8", na.strings = c("",NA))
  #) PROBLEM

  tar_target(
    mon_park,
    mon_park_raw %>%
      select(c("Nom", "geometry")) %>%
      rename("park" = "Nom")
  ),
  
  tar_target(
    mon_tree_s,
    mon_tree_raw %>%
      select(c("Essence_latin","DHP", "Rue", "NOM_PARC","Longitude","Latitude")) %>%
      rename("dbh" = "DHP",
             "park" = "NOM_PARC",
             "street" = "Rue") %>%
      mutate(id = seq.int(nrow(.))) %>%
      drop_na(c(Latitude, Longitude))
  ),
  
  tar_target(
    mon_tree_sp,
    assign_sp_mon(mon_tree_s)
  ),
  
  tar_target(
    mon_tree,
    tree_cleaning("Montreal", mon_tree_sp, mon_park, mon_hood, mun_bound, mun_road)
  )

)