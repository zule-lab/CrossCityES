combine_neighbourhoods_lst <- function(neighbourhoods_lst, neighbourhood_bound_trees, census_neighbourhood,
                                       neighbourhood_treedensity, neighbourhood_treerichness, neighbourhood_treesize, 
                                       build_dens_neighbourhood, neighbourhoods_bldhgt, neighbourhood_roadclass, neighbourhoods_ndvi_ndbi){
  

# filter images -----------------------------------------------------------
  
  # count_temp indicates the number of cells used for each image 
  # we need to filter so that each image must meet a threshold for inclusion 
  
  filt <- neighbourhoods_lst %>% 
    inner_join(., neighbourhood_bound_trees) %>% 
    mutate(coverage = round((count_temp*900)/(drop_units(st_area(geometry)))*100, 3)) %>% 
    # image covers minimum 50% of the city area
    filter(coverage > 50) %>% 
    select(-geometry)
  
  filt_ndvi <- neighbourhoods_ndvi_ndbi %>% 
    inner_join(., neighbourhood_bound_trees) %>% 
    mutate(coverage = round((NDBI_count_*100)/(drop_units(st_area(geometry)))*100, 3)) %>% 
    # image covers minimum 50% of the city area
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
  
  final <- join %>%
    inner_join(neighbourhood_bound_trees %>% select(c(city, hood, geometry))) %>%
    st_as_sf() %>%
    st_centroid() %>% 
    mutate(lon = st_coordinates(.)[,1],
           lat = st_coordinates(.)[,2]) %>% 
    st_drop_geometry() %>%
    mutate(city_hood = paste0(city, "_", hood)) %>%
    select(-c(time, hood,
              count_temp, median_temp, max_temp, min_temp,
              stdDev_temp, coverage, nTrees, stemdens_acre,
              total_ba, hood_area.y, hood_id.x.x,
              centroids, build_area, prop_strts, road_length,
              neighbourhood_area, area, DSAcount, lowinc,
              date_ndvi, time_ndvi, NDBI_count_,
              NDBI_median_, NDBI_max_, NDBI_min_, NDBI_stdDev_,
              NDVI_count_, NDVI_median_, NDVI_max_, NDVI_min_, 
              NDVI_stdDev_, diff)) %>% 
    mutate_if(is.character, factor) %>%
    mutate(doy = yday(date)) %>% 
    select(-date)
  
  
  return(final)
  
}