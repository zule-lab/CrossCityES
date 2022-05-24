neighbourhood_data_cleanup <- c(
  
  tar_target(
    cal_hood_i,
    cal_hood_raw %>% 
      select(c("NAME", "MULTIPOLYGON")) %>% 
      rename("hood" = "NAME") %>% 
      rename("geometry" = "MULTIPOLYGON") %>%
      mutate(city = c("Calgary")) %>%
      st_as_sf(wkt = "geometry", crs = 4326)
  ),
  
  tar_target(
    cal_hood,
    hood_cleaned(cal_hood_i, "cal")
  ),
  
  tar_target(
    hal_hood_i,
    hal_hood_raw %>% 
      select(c("GSA_NAME", "geometry")) %>% 
      rename("hood" = "GSA_NAME") %>% 
      filter(hood == "HALIFAX") %>% # Halifax peninsula is considered to be one neighbourhood as per correspondence with city officials
      mutate(city = c("Halifax")) 
  ),
  
  tar_target(
    hal_hood,
    hood_cleaned(hal_hood_i, "hal")
  ),
  
  tar_target(
    mon_hood_i, 
    mon_hood_raw %>% 
      select(c("NOM","geometry")) %>%
      rename("hood" = "NOM") %>%
      mutate(city = c("Montreal"))
  ),
  
  tar_target(
    mon_hood,
    hood_cleaned(mon_hood_i, "mon")
  ),
  
  tar_target(
    ott_hood_i,
    ott_hood_raw %>% 
      select(c("Name", "geometry")) %>% 
      rename("hood" = "Name") %>%
      mutate(city = c("Ottawa"))
  ),
  
  tar_target(
    ott_hood,
    hood_cleaned(ott_hood_i, "ott")
  ),
  
  tar_target(
    tor_hood_i,
    tor_hood_raw %>% 
      select(c("FIELD_8", "geometry")) %>% 
      rename("hood" = "FIELD_8")%>%
      mutate(city = c("Toronto"))
  ),
  
  tar_target(
    tor_hood,
    hood_cleaned(tor_hood_i, "tor")
  ),
  
  tar_target(
    van_hood_i,
    van_hood_raw %>% 
      select(c("name","geometry"))%>%
      rename(hood = "name") %>%
      mutate(city = c("Vancouver"))
  ),
  
  tar_target(
    van_hood,
    hood_cleaned(van_hood_i, "van")
  ),
  
  tar_target(
    win_hood_i,
    win_hood_raw %>% 
      select(c("name","geometry")) %>%
      rename(hood = "name") %>%
      mutate(city = c("Winnipeg"))
  ),
  
  tar_target(
    win_hood,
    hood_cleaned(win_hood_i, "win")
  ),
  
  tar_target(
    can_hood,
    rbind(cal_hood, hal_hood, mon_hood, ott_hood, tor_hood, van_hood, win_hood)
  )

)