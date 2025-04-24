combine_roads_lst <- function(streets_lst, road_bound_trees, census_road, 
                              road_treedensity, road_treerichness, road_treesize, 
                              build_dens_road, streets_ndvi_ndbi){
  

# classify roads ----------------------------------------------------------

  # need to assign classifications to individual roads based on numerical class 
  # highways: 10, 11, 12, 13, 25, 80 
  # regular roads: 20, 21, 22, 23, 24, 29
  # everything else: other
  
  road_bound_trees <- road_bound_trees %>% 
    mutate(road_class = case_when(class == 10 | class == 11 | class == 12 | class == 13 | class == 25 | class == 80 ~ 'highway',
                                  class == 20 | class == 21 | class == 22 | class == 23 | class == 24 | class == 29 ~ 'street',
                                  .default = 'other'))
  
  
# filter images -----------------------------------------------------------
  
  # count_temp indicates the number of cells used for each image 
  # we need to filter so that each image must meet a threshold for inclusion 
  
  filt <- streets_lst %>% 
    mutate(streetid = as.character(streetid)) %>% 
    inner_join(., road_bound_trees, by = 'streetid') %>% 
    mutate(coverage = round((count_temp*900)/(drop_units(st_area(geometry)))*100, 3)) %>% 
    # image covers minimum 100% of the street 
    filter(coverage > 100) %>% 
    select(-geometry)
  
  filt_ndvi <- streets_ndvi_ndbi %>% 
    mutate(streetid = as.character(streetid)) %>% 
    inner_join(., road_bound_trees, by = 'streetid') %>% 
    mutate(coverage = round((NDBI_count_*100)/(drop_units(st_area(geometry)))*100, 3)) %>% 
    # image covers minimum 100% of the street 
    filter(coverage > 100) %>% 
    select(-c(geometry, coverage))
  
  
# join data ---------------------------------------------------------------
  
  join <- filt %>%
    left_join(., road_treedensity, by = c("streetid")) %>%
    left_join(., road_treerichness, by = join_by("streetid" == "road")) %>% 
    left_join(., road_treesize, by = c("streetid")) %>%
    left_join(., build_dens_road %>% st_set_geometry(NULL), by = c("streetid")) %>%
    left_join(., census_road %>% mutate(id = as.character(id)), by = "streetid") %>%
    full_join(., filt_ndvi %>% rename(date_ndvi = date), by = c("streetid")) %>%
    rename(class = class.x.x,
           street = street.x,
           road_class = road_class.x,
           ba_per_m2 = ba_per_m2.x,
           city = city.x) %>%
    select(-c(CMANAME, CMANAME.x.x, CMANAME.x.y, CMANAME.y.y, CMANAME.y.x, 
              class.x.y, class.y.x, class.y.y, id.x, id.y, 
              street.y, street.x.x, street.y.y, 
              streettype.x, streettype.y, streetdir.x, streetdir.y,  
              road_class.y, ba_per_m2.y, city.y, rank, geometry)) %>% 
    separate(date, c('date', 'time'), sep = 'T') %>% 
    separate(date_ndvi, c("date_ndvi", "time_ndvi"), sep = "T") %>% 
    mutate(date = as.Date(date),
           time = format(strptime(time, "%H:%M:%S"),"%H:%M:%S"),
           date_ndvi = as.Date(date_ndvi),
           time_ndvi = format(strptime(time_ndvi, "%H:%M:%S"),"%H:%M:%S"),
           diff = abs(date - date_ndvi)) %>% 
    group_by(streetid, date) %>%
    # select for ndvi image that is closest to lst image
    filter(diff == min(diff)) %>% 
    ungroup()
  
  
  return(join)
  
  
  
  
  
}