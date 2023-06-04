tree_size <- function(can_trees, scale){
  
  
  all_tree_in <- can_trees %>% 
    drop_na(dbh) %>%
    mutate(dbh_in = dbh*2.54,
           basal_area = ((dbh_in)^2 * 0.005454))
  
  if (scale == 'city'){
    
    grouped <- all_tree_in %>%
      group_by(city)
    
  }
  
  else if (scale == 'neighbourhood'){
    
    grouped <- all_tree_in %>%
      group_by(city, hood) %>%
      mutate(nTrees = n()) %>% 
      filter(nTrees > 50) %>%
      select(-nTrees)
    
  }
  
  else if (scale == 'road'){
    
    road_bound_trees <- tar_read(road_bound_trees)
    
    can_trees_i <- st_intersection(all_tree_in, road_bound_trees)
   
    grouped <- can_trees_i %>%
      group_by(city, hood, streetid) %>% 
      mutate(nTrees = n()) %>% 
      filter(nTrees > 1) %>%
      select(-nTrees)
    
  }
  
  else {
    print("error: none of the scales matched")
  }

  
  size <- grouped %>%
    summarize(mean_ba = mean(basal_area),
              sd_ba = sd(basal_area),
              mean_dbh = mean(dbh_in),
              sd_dbh = mean(dbh_in)) %>%
    mutate(mean_ba = set_units(mean_ba, "ft2"),
           sd_ba = set_units(sd_ba, "ft2"),
           mean_dbh = set_units(mean_dbh, "in"),
           sd_dbh = set_units(sd_dbh, "in"))

  return(size)
  
  
}
