combine_cities_lst <- function(cities_lst, mun_bound_trees, cities_treedensity, cities_treerichness, 
                               cities_treesize, build_dens_city, cities_roadclass, census_city, cities_ndvi_ndbi){
  

# filter images -----------------------------------------------------------

  # count_temp indicates the number of cells used for each image 
  # we need to filter so that each image must meet a threshold for inclusion 
  
  filt <- cities_lst %>% 
    inner_join(., mun_bound_trees) %>% 
    mutate(coverage = round((count_temp*900)/(drop_units(st_area(geometry)))*100, 3)) %>% 
    # image covers minimum 50% of the city area
    filter(coverage > 50) %>% 
    select(-geometry)
  
  filt_ndvi <- cities_ndvi_ndbi %>% 
    inner_join(., mun_bound_trees) %>% 
    mutate(coverage = round((NDBI_count_*100)/(drop_units(st_area(geometry)))*100, 3)) %>% 
    # image covers minimum 50% of the city area
    filter(coverage > 50) %>% 
    select(-c(geometry, coverage))
  

# join data ---------------------------------------------------------------
  
  join <- filt %>%
    rename(city = CMANAME) %>%
    left_join(., cities_treedensity, by = "city") %>%
    left_join(., cities_treerichness, by = "city") %>%
    left_join(., cities_treesize %>% st_set_geometry(NULL), by = "city") %>%
    left_join(., build_dens_city %>% st_set_geometry(NULL), by = "city") %>% 
    left_join(., cities_roadclass %>% st_set_geometry(NULL), by = "city") %>%
    left_join(., census_city %>% st_set_geometry(NULL), by = "city") %>%
    full_join(., filt_ndvi %>% rename(date_ndvi = date, city = CMANAME), by = "city") %>%
    rename(mean_ba = mean_ba.x) %>% 
    select(-c(city_area.x, city_area.y, CMANAME, mean_ba.y)) %>% 
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
  
  return(join)
  
  
}
