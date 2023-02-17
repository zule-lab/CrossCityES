tree_density <- function(can_trees, scale, treesize, builddens){
  
  if (scale == 'city'){
    
    treedensity_city <- can_trees %>% 
      group_by(city) %>%
      st_set_geometry(NULL) %>%
      summarize(nTrees = n()) %>%
      inner_join(., as.data.frame(treeesize), by = "city") %>% 
      inner_join(., as.data.frame(builddens), by = "city") %>%
      summarize(city = city,
                nTrees = nTrees,
                mean_ba = mean_ba, # sq ft
                cityarea = city_area, # km2
                stemdens = nTrees/cityarea, # trees/km2
                stemdens_acre = stemdens/247.105, # conversion from num trees/km2 to num trees/acre
                basaldens = mean_ba*stemdens_acre) # sq ft/acre
    
    return(treedensity_city)
    
  }
  
  else if (scale == 'neighbourhood'){
    
    treedensity_neighbourhood <- can_trees %>% 
      group_by(city, hood_id) %>%
      st_set_geometry(NULL) %>%
      summarize(nTrees = n()) %>%
      inner_join(., as.data.frame(treesize), by = "hood_id") %>% 
      inner_join(., as.data.frame(builddens), by = "hood_id") %>%
      summarize(city = city,
                hood_id = hood_id,
                nTrees = nTrees,
                mean_ba = mean_ba,
                hoodarea = hood_area,
                stemdens = nTrees/hoodarea,
                stemdens_acre = stemdens/247.105,
                basaldens = mean_ba*stemdens_acre)
    
    return(treedensity_neighbourhood)
    
  }
  
  else if (scale == 'road'){
    
    treedensity_road <- can_trees %>% 
      group_by(city, hood_id, streetid) %>%
      summarize(nTrees = n()) %>%
      mutate(streetid = as.character(streetid)) %>%
      inner_join(., as.data.frame(treesize), by = "streetid") %>% 
      inner_join(., as.data.frame(builddens), by = "streetid") %>%
      summarize(city = city,
                hood_id = hood_id.x,
                streetid = streetid,
                nTrees = nTrees,
                mean_ba = mean_ba,
                roadlength = road_length,
                stemdens = nTrees/roadlength,
                stemdens_acre = stemdens/247.105,
                basaldens = mean_ba*stemdens_acre)
    
  }
  
  else {
    print("error: none of the scales matched")
  }
  
}