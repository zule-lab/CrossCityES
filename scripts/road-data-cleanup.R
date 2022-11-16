road_data_cleanup <- c(
  
  tar_target(
    mun_bound,
    mun_bound_raw %>%
      group_by(CMANAME) %>%
      summarise() %>%
      mutate(CMANAME = replace(CMANAME, CMANAME == "Ottawa - Gatineau (Ontario part / partie de l'Ontario)", "Ottawa")) %>%
      filter(CMANAME == "Vancouver" |
               CMANAME == "Calgary" |
               CMANAME == "Winnipeg" | 
               CMANAME == "Toronto" |
               CMANAME == "Ottawa" |
               CMANAME == "Montréal" |
               CMANAME == "Halifax")
  ),
  
  tar_target(
    road_raw_s,
    road_raw[,c("NAME", "TYPE", "DIR", "NGD_UID", "RANK", "CLASS", "geometry")]
  ),
  
  tar_target(
    road_raw_r,
    road_raw_s %>%
      rename(street = NAME,
             streettype = TYPE,
             streetdir = DIR,
             streetid = NGD_UID,
             rank = RANK,
             class = CLASS) %>%
      st_transform(crs = 3347)
  ),
  
  tar_target(
    mun_road_i,
    road_raw_r[mun_bound,]
  ),
  
  tar_target(
    mun_road,
    st_join(mun_road_i, mun_bound)
  )

)