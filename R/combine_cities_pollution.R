combine_cities_pollution <- function(cities_pollution, mun_bound_trees, census_city,
                                     cities_treedensity, cities_treerichness, cities_treesize, 
                                     build_dens_city, cities_bldhgt, cities_roadclass, cities_ndvi_ndbi){
  
  
  # filter images -----------------------------------------------------------
  
  # count_temp indicates the number of cells used for each image 
  # we need to filter so that each image must meet a threshold for inclusion 
  
  filt <- cities_pollution %>% 
    mutate(pollutant = str_extract(variable, "[^_]+$"),
           variable = str_replace(variable, "_[^_]+$", "")) %>%
    pivot_wider(names_from = variable, values_from = value, values_fn = first) %>%
    inner_join(., mun_bound_trees, by = join_by('city' == 'CMANAME')) %>% 
    # resolution is 1113.2 m
    mutate(coverage = round((count_cities*1239214.24)/(drop_units(st_area(geometry)))*100, 3)) %>%
    # image covers minimum 75% of the city area
    filter(coverage > 50) %>% 
    pivot_longer(ends_with('_cities'), names_to = "variable") %>%
    filter(str_detect(variable, 'mean_')) %>% 
    unite('variable', c('variable', 'pollutant'), sep = '_') %>% 
    select(-geometry)
  
  filt_ndvi <- cities_ndvi_ndbi %>% 
    inner_join(., mun_bound_trees) %>% 
    mutate(coverage = round((NDBI_count_*100)/(drop_units(st_area(geometry)))*100, 3)) %>% 
    # image covers minimum 50% of the city area
    filter(coverage > 50) %>% 
    select(-c(geometry, coverage))
  
  
  # join data ---------------------------------------------------------------
  
  join <- filt %>%
    left_join(., cities_treedensity, by = "city") %>%
    left_join(., cities_treerichness, by = "city") %>%
    left_join(., cities_treesize, by = "city") %>%
    left_join(., build_dens_city %>% st_set_geometry(NULL), by = "city") %>%
    left_join(., cities_roadclass %>% st_set_geometry(NULL), by = "city") %>% 
    left_join(., census_city %>% st_drop_geometry() %>% select(-da), by = "city") %>%
    left_join(., cities_bldhgt %>% rename(city = CMANAME), by = "city") %>%
    full_join(., filt_ndvi %>% rename(date_ndvi = date, city = CMANAME), by = "city") %>%
    rename(ba_per_m2 = ba_per_m2.x) %>% 
    select(-c(city_area.x, city_area.y, CMANAME, ba_per_m2.y)) %>% 
    separate(date, c('date', 'time'), sep = 'T') %>% 
    separate(date_ndvi, c("date_ndvi", "time_ndvi"), sep = "T") %>% 
    mutate(date = as.Date(date),
           time = format(strptime(time, "%H:%M:%S"),"%H:%M:%S"),
           date_ndvi = as.Date(date_ndvi),
           time_ndvi = format(strptime(time_ndvi, "%H:%M:%S"),"%H:%M:%S"),
           diff = abs(date - date_ndvi)) %>% 
    group_by(city, date) %>%
    # select for ndvi image that is closest to lst image
    filter(diff == min(diff)) %>% 
    ungroup()
  
  final <- join %>% 
    select(-c(time, coverage, nTrees, stemdens_acre, total_ba, centroids,
              build_area, road_length, area, DAcount, lowinc, date_ndvi, time_ndvi,
              NDBI_count_, NDBI_median_, NDBI_max_, NDBI_min_, NDBI_stdDev_, NDVI_count_,
              NDVI_median_, NDVI_max_, NDVI_min_, NDVI_stdDev_, diff)) %>% 
    # make character variables into factors 
    mutate_if(is.character, factor) %>% 
    # convert date into doy 
    mutate(doy = yday(date)) %>% 
    select(-date) %>% 
    # get lat lon for spatial autocorrelation
    inner_join(mun_bound_trees, by = join_by(city == CMANAME)) %>%
    st_as_sf() %>%
    st_centroid() %>% 
    mutate(lon = st_coordinates(.)[,1],
           lat = st_coordinates(.)[,2]) %>% 
    st_drop_geometry()
  
  
  return(final)
  
}