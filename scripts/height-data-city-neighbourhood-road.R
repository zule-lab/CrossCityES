height_data_neighbourhood_road <- c(
  
  tar_target(
    van_city_height, 
    van_build_height %>%
      rename(height = vancouver.tif) %>%
      st_set_geometry(NULL) %>%
      filter(height > 0) %>% 
      summarize(mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    van_hood_height,
    st_join(van_hood, van_build_height) %>%
      rename(height = vancouver.tif) %>%
      filter(height > 0) %>% 
      group_by(hood_id) %>%
      summarize(city = first(city),
                hood = first(hood),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    van_road_height,
    mun_road %>% 
      filter(CMANAME == "Vancouver") %>%
      st_join(., van_build_height, join = st_nearest_feature) %>% 
      rename(height = vancouver.tif) %>%
      filter(height > 0) %>% 
      group_by(streetid) %>%
      summarize(city = first(CMANAME),
                street = first(street),
                streettype = first(streettype),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    cal_city_height, 
    cal_build_height %>%
      rename(height = calgarywest.tif) %>%
      st_set_geometry(NULL) %>%
      filter(height > 0) %>% 
      summarize(mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    cal_hood_height,
    st_join(cal_hood, cal_build_height) %>%
      rename(height = calgarywest.tif) %>%
      filter(height > 0) %>% 
      group_by(hood_id) %>%
      summarize(city = first(city),
                hood = first(hood),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    cal_road_height,
    mun_road %>% 
      filter(CMANAME == "Calgary") %>%
      st_join(., cal_build_height, join = st_nearest_feature) %>% 
      rename(height = calgarywest.tif) %>%
      filter(height > 0) %>% 
      group_by(streetid) %>%
      summarize(city = first(CMANAME),
                street = first(street),
                streettype = first(streettype),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    win_city_height, 
    win_build_height %>%
      rename(height = winnipegne.tif) %>%
      st_set_geometry(NULL) %>%
      filter(height > 0) %>% 
      summarize(mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    win_hood_height,
    st_join(win_hood, win_build_height) %>%
      rename(height = winnipegne.tif) %>%
      filter(height > 0) %>% 
      group_by(hood_id) %>%
      summarize(city = first(city),
                hood = first(hood),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    win_road_height,
    mun_road %>% 
      filter(CMANAME == "Winnipeg") %>%
      st_join(., win_build_height, join = st_nearest_feature) %>% 
      rename(height = winnipegne.tif) %>%
      filter(height > 0) %>% 
      group_by(streetid) %>%
      summarize(city = first(CMANAME),
                street = first(street),
                streettype = first(streettype),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    tor_city_height, 
    tor_build_height %>%
      rename(height = torontone.tif) %>%
      st_set_geometry(NULL) %>%
      filter(height > 0) %>% 
      summarize(mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    tor_hood_height,
    st_join(tor_hood, tor_build_height) %>%
      rename(height = torontone.tif) %>%
      filter(height > 0) %>% 
      group_by(hood_id) %>%
      summarize(city = first(city),
                hood = first(hood),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    tor_road_height,
    mun_road %>% 
      filter(CMANAME == "Toronto") %>%
      st_join(., tor_build_height, join = st_nearest_feature) %>% 
      rename(height = torontone.tif) %>%
      filter(height > 0) %>% 
      group_by(streetid) %>%
      summarize(city = first(CMANAME),
                street = first(street),
                streettype = first(streettype),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    ott_city_height, 
    ott_build_height %>%
      rename(height = ottawane.tif) %>%
      st_set_geometry(NULL) %>%
      filter(height > 0) %>% 
      summarize(mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    ott_hood_height,
    st_join(ott_hood, ott_build_height) %>%
      rename(height = ottawane.tif) %>%
      filter(height > 0) %>% 
      group_by(hood_id) %>%
      summarize(city = first(city),
                hood = first(hood),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    ott_road_height,
    mun_road %>% 
      filter(CMANAME == "Ottawa") %>%
      st_join(., ott_build_height, join = st_nearest_feature) %>% 
      rename(height = ottawane.tif) %>%
      filter(height > 0) %>% 
      group_by(streetid) %>%
      summarize(city = first(CMANAME),
                street = first(street),
                streettype = first(streettype),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    mon_city_height, 
    mon_build_height %>%
      rename(height = cotesaintluc.tif) %>%
      st_set_geometry(NULL) %>%
      filter(height > 0) %>% 
      summarize(mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    mon_hood_height,
    st_join(mon_hood, mon_build_height) %>%
      rename(height = cotesaintluc.tif) %>%
      filter(height > 0) %>% 
      group_by(hood_id) %>%
      summarize(city = first(city),
                hood = first(hood),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    mon_road_height,
    mun_road %>% 
      filter(CMANAME == "Montréal") %>%
      st_join(., mon_build_height, join = st_nearest_feature) %>% 
      rename(height = cotesaintluc.tif) %>%
      filter(height > 0) %>% 
      group_by(streetid) %>%
      summarize(city = first(CMANAME),
                street = first(street),
                streettype = first(streettype),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    hal_city_height, 
    hal_build_height %>%
      rename(height = halifax.tif) %>%
      st_set_geometry(NULL) %>%
      filter(height > 0) %>% 
      summarize(mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    hal_hood_height,
    st_join(hal_hood, hal_build_height) %>%
      rename(height = halifax.tif) %>%
      filter(height > 0) %>% 
      group_by(hood_id) %>%
      summarize(city = first(city),
                hood = first(hood),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    hal_road_height,
    mun_road %>% 
      filter(CMANAME == "Halifax") %>%
      st_join(., hal_build_height, join = st_nearest_feature) %>% 
      rename(height = halifax.tif) %>%
      filter(height > 0) %>% 
      group_by(streetid) %>%
      summarize(city = first(CMANAME),
                street = first(street),
                streettype = first(streettype),
                mean = mean(height),
                median = median(height),
                sd = sd(height))
  ),
  
  tar_target(
    city_height, 
    rbind(van_city_height, cal_city_height, win_city_height, tor_city_height, ott_city_height, mon_city_height, hal_city_height)
  ),
  
  tar_target(
    hood_height, 
    rbind(van_hood_height, cal_hood_height, win_hood_height, tor_hood_height, ott_hood_height, mon_hood_height, hal_hood_height)
  ),
  
  tar_target(
    road_height, 
    rbind(van_road_height, cal_road_height, win_road_height, tor_road_height, ott_road_height, mon_road_height, hal_road_height)
  )
  
)