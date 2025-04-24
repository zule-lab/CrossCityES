combine_neighbourhoods_pollution <- function(neighbourhoods_pollution, neighbourhood_bound_trees, census_neighbourhood,
                                             neighbourhood_treedensity, neighbourhood_treerichness, neighbourhood_treesize, 
                                             build_dens_neighbourhood, neighbourhood_roadclass, neighbourhoods_ndvi_ndbi){
  
  
  # filter images -----------------------------------------------------------
  
  # count_temp indicates the number of cells used for each image 
  # we need to filter so that each image must meet a threshold for inclusion 
  
  filt <- neighbourhoods_pollution %>% 
    filter(str_detect(variable, 'count_')) %>% 
    inner_join(., neighbourhood_bound_trees) %>% 
    # resolution is 1113.2 m
    mutate(coverage = round((value*1239214.24)/(drop_units(st_area(geometry)))*100, 3)) %>%
    # image covers minimum 100% of the neighbourhood area
    filter(coverage >= 100) %>% 
    select(-geometry)
  
  filt_ndvi <- neighbourhoods_ndvi_ndbi %>% 
    inner_join(., neighbourhood_bound_trees) %>% 
    mutate(coverage = round((NDBI_count_*100)/(drop_units(st_area(geometry)))*100, 3)) %>% 
    # image covers minimum 50% of the neighbourhood area
    filter(coverage > 50) %>% 
    select(-c(geometry, coverage))
  
  
  # join data ---------------------------------------------------------------
  
  join <- filt %>%
    left_join(., neighbourhood_treedensity, by = c("city", "hood")) %>%
    left_join(., neighbourhood_treerichness %>% separate(neighbourhood, c('city', 'hood'), sep = '_'), by = c("city", "hood")) %>%
    left_join(., neighbourhood_treesize, by = c("city", "hood")) %>%
    left_join(., build_dens_neighbourhood %>% st_set_geometry(NULL), by = c("city", "hood")) %>%
    rename(hood_id = hood_id.x) %>%
    left_join(., neighbourhood_roadclass %>% st_set_geometry(NULL), by = c("city", "hood_id")) %>%
    left_join(., census_neighbourhood %>% st_set_geometry(NULL) %>% select(-da), by = c("city", "hood_id")) %>% 
    full_join(., filt_ndvi %>% rename(date_ndvi = date), by = c("city", "hood_id")) %>%  
    rename(ba_per_m2 = ba_per_m2.x) %>% 
    select(-c(hood.x, hood_area.x, id.x, id.y, hood_id.y, ba_per_m2.y)) %>% 
    separate(date, c('date', 'time'), sep = 'T') %>% 
    separate(date_ndvi, c("date_ndvi", "time_ndvi"), sep = "T") %>% 
    mutate(date = as.Date(date),
           time = format(strptime(time, "%H:%M:%S"),"%H:%M:%S"),
           date_ndvi = as.Date(date_ndvi),
           time_ndvi = format(strptime(time_ndvi, "%H:%M:%S"),"%H:%M:%S"),
           diff = abs(date - date_ndvi)) %>% 
    group_by(city, hood_id, date) %>%
    # select for ndvi image that is closest to lst image
    filter(diff == min(diff)) %>% 
    ungroup()
  
  
  return(join)
  
}