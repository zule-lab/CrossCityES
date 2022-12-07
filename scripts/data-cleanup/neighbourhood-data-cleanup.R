targets_neighbourhood_cleanup <- c(
  
  tar_target(
    van_hood_i,
    van_hood_raw %>% 
      select(c("name","geometry"))%>%
      rename(hood = "name") %>%
      mutate(city = c("Vancouver"))
  ),
  
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
    win_hood_i,
    win_hood_raw %>% 
      select(c("name","geometry")) %>%
      rename(hood = "name") %>%
      mutate(city = c("Winnipeg"))
  ),
  
  tar_target(
    tor_hood_i,
    tor_hood_raw %>% 
      select(c("FIELD_8", "geometry")) %>% 
      rename("hood" = "FIELD_8")%>%
      mutate(city = c("Toronto"))
  ),
  
  tar_target(
    ott_hood_i,
    ott_hood_raw %>% 
      select(c("Name", "geometry")) %>% 
      rename("hood" = "Name") %>%
      mutate(city = c("Ottawa"))
  ),
  
  tar_target(
    mon_hood_i, 
    mon_hood_raw %>% 
      select(c("NOM","geometry")) %>%
      rename("hood" = "NOM") %>%
      mutate(city = c("Montreal"))
  ),
  
  tar_target(
    hal_hood_i,
    hal_hood_raw %>% 
      select(c("GSA_NAME", "geometry")) %>% 
      rename("hood" = "GSA_NAME") %>% 
      mutate(city = c("Halifax")) 
  ),
  
  tar_eval(
    tar_target(
      name,
      hood_cleaned(tar, substr(name, 1, 3))),
    values = list(name = lapply(c('van_hood', 'cal_hood', 'win_hood', 'tor_hood', 'ott_hood', 'mon_hood', 'hal_hood'), as.symbol),
                  file = list(van_hood_i, cal_hood_i, win_hood_i, tor_hood_i, ott_hood_i, mon_hood_i, hal_hood_i))
  ),
  
  tar_target(
    can_hood,
    rbind(cal_hood, hal_hood, mon_hood, ott_hood, tor_hood, van_hood, win_hood)
  ),
  
  tar_target(
    can_hood_ee,
    can_hood %>% 
      sf_as_ee(x = .,
             overwrite = TRUE,
             assetId = sprintf("%s/%s", ee_get_assethome(), 'mun_road'),
             bucket = 'rgee_dev',
             monitoring = FALSE,
             via = 'gcs_to_asset')
  )

)