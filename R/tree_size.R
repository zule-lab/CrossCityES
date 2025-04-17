tree_size <- function(can_trees, boundary, scale){
  
  
  all_tree_basal <- can_trees %>% 
    drop_na(dbh) %>%
    mutate(basal_area = (pi*dbh^2)/40000 ) # m2
  
  if (scale == 'city'){
    
    city_area <- boundary %>% 
      mutate(area = st_area(geometry)) %>% 
      st_drop_geometry()
    
    grouped <- all_tree_basal %>%
      group_by(city) %>% 
      left_join(., city_area, by = c('city' = 'CMANAME'))
    
  }
  
  else if (scale == 'neighbourhood'){
    
    nhood_area <- boundary %>% 
      st_drop_geometry() %>% 
      select(city, hood, hood_area) %>% 
      rename(area = hood_area)
    
    grouped <- all_tree_basal %>%
      group_by(city, hood) %>%
      mutate(nTrees = n()) %>% 
      filter(nTrees > 50) %>%
      select(-nTrees) %>% 
      left_join(., nhood_area, by = c('city', 'hood'))
    
  }
  
  else if (scale == 'road'){
    
    can_trees_i <- st_intersection(all_tree_basal, boundary %>% mutate(area = st_area(geometry)))
   
    grouped <- can_trees_i %>%
      group_by(streetid) %>% 
      mutate(nTrees = n()) %>% 
      filter(nTrees > 1) %>%
      select(-nTrees)
    
  }
  
  else {
    print("error: none of the scales matched")
  }

  
  size <- grouped %>%
    summarize(area = first(area),
              total_ba = sum(basal_area),
              mean_dbh = mean(dbh),
              sd_dbh = sd(dbh)) %>%
    mutate(ba_per_m2 = total_ba/area,
           mean_dbh = set_units(mean_dbh, "cm"),
           sd_dbh = set_units(sd_dbh, "cm")) %>% 
    st_drop_geometry() %>% 
    select(-area)

  return(size)
  
  
}
