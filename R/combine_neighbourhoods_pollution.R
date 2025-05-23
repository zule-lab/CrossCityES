combine_neighbourhoods_pollution <- function(neighbourhoods_pollution, neighbourhood_bound_trees, census_neighbourhood,
                                             neighbourhood_treedensity, neighbourhood_treerichness, neighbourhood_treesize, 
                                             build_dens_neighbourhood, neighbourhoods_bldhgt, neighbourhood_roadclass, neighbourhoods_ndvi_ndbi){
  
  
  # filter images -----------------------------------------------------------
  
  # count_temp indicates the number of cells used for each image 
  # we need to filter so that each image must meet a threshold for inclusion 
  
  filt <- neighbourhoods_pollution %>% 
    mutate(pollutant = str_extract(variable, "[^_]+$"),
           variable = str_replace(variable, "_[^_]+$", "")) %>%
    pivot_wider(names_from = variable, values_from = value, values_fn = first) %>%
    inner_join(., neighbourhood_bound_trees) %>% 
    # resolution is 1113.2 m
    mutate(coverage = round((count_neighbourhoods*1239214.24)/(drop_units(st_area(geometry)))*100, 3)) %>%
    # image covers minimum 100% of the neighbourhood area
    filter(coverage >= 100) %>% 
    pivot_longer(ends_with('_neighbourhoods'), names_to = "variable") %>%
    filter(str_detect(variable, 'mean_')) %>% 
    unite('variable', c('variable', 'pollutant'), sep = '_') %>% 
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
    left_join(., neighbourhoods_bldhgt, by = c("city", "hood")) %>%
    left_join(., build_dens_neighbourhood %>% st_drop_geometry(), by = c("city", "hood")) %>%
    left_join(., neighbourhood_roadclass %>% st_drop_geometry(), by = c("city", "hood")) %>%
    left_join(., census_neighbourhood %>% st_drop_geometry() %>% select(-da), by = c("city", "hood")) %>%
    full_join(., filt_ndvi %>% rename(date_ndvi = date), by = c("city", "hood")) %>%
    rename(ba_per_m2 = ba_per_m2.x) %>% 
    select(-c(hood_area.x, hood_id.x, id.x, id.y, hood_id.y, ba_per_m2.y)) %>% 
    separate(date, c('date', 'time'), sep = 'T') %>% 
    separate(date_ndvi, c("date_ndvi", "time_ndvi"), sep = "T") %>% 
    mutate(date = as.Date(date),
           time = format(strptime(time, "%H:%M:%S"),"%H:%M:%S"),
           date_ndvi = as.Date(date_ndvi),
           time_ndvi = format(strptime(time_ndvi, "%H:%M:%S"),"%H:%M:%S"),
           diff = abs(date - date_ndvi)) %>% 
    group_by(city, hood, date) %>%
    # select for ndvi image that is closest to lst image
    filter(diff == min(diff)) %>% 
    ungroup()
  
  
  return(join)
  
}