road_data_cleanup <- c(
  
  tar_target(
    mun_bound,
    mun_bound_raw %>%
      group_by(CMANAME) %>%
      summarise()
  ),
  
  tar_target(
    road_raw_s,
    road_raw[,c("NAME", "TYPE", "DIR", "NGD_UID", "geometry")]
  ),
  
  tar_target(
    road_raw_r,
    road_raw_s %>%
      rename(street = NAME) %>%
      rename(streettype = TYPE) %>%
      rename(streetdir = DIR) %>%
      rename(streetid = NGD_UID) %>%
      st_transform(crs = 3347) # does this work?
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