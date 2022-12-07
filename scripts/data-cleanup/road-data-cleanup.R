targets_road_cleanup <- c(
  
  tar_target(
    mun_bound,
    mun_bound_raw %>%
      group_by(CMANAME) %>%
      summarise() %>%
      mutate(CMANAME = replace(CMANAME, CMANAME == "Ottawa - Gatineau (Ontario part / partie de l'Ontario)", "Ottawa"),
             CMANAME = replace(CMANAME, CMANAME == "Montréal", "Montreal")) %>%
      filter(CMANAME == "Vancouver" |
               CMANAME == "Calgary" |
               CMANAME == "Winnipeg" | 
               CMANAME == "Toronto" |
               CMANAME == "Ottawa" |
               CMANAME == "Montreal" |
               CMANAME == "Halifax")
  ),
  
  tar_target(
    mun_road,
    clean_roads(mun_bound, road_raw)
  ),

  tar_target(
  )

)