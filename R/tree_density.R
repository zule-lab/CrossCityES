tree_density <- function(can_trees, scale, treesize, builddens, road_bound_trees = NULL){
  
  if (scale == 'city'){
    
    treedensity_city <- can_trees %>% 
      group_by(city) %>%
      st_set_geometry(NULL) %>%
      summarize(nTrees = n()) %>%
      inner_join(., as.data.frame(treesize), by = "city") %>% 
      inner_join(., as.data.frame(builddens), by = "city") %>%
      summarize(city = city,
                nTrees = nTrees,
                ba_per_m2 = ba_per_m2, # m2/m2
                cityarea = city_area, # km2
                stemdens = nTrees/cityarea, # trees/km2
                stemdens_acre = stemdens/247.105) 
    
    return(treedensity_city)
    
  }
  
  else if (scale == 'neighbourhood'){
    
    treedensity_neighbourhood <- can_trees %>% 
      group_by(city, hood) %>%
      st_set_geometry(NULL) %>%
      summarize(nTrees = n()) %>%
      filter(nTrees > 50) %>%
      inner_join(., as.data.frame(builddens), by = c("city", "hood")) %>% 
      inner_join(., as.data.frame(treesize), by = c("city" , "hood")) %>%
      summarize(city = city,
                hood = hood,
                nTrees = nTrees,
                ba_per_m2 = ba_per_m2,
                hoodarea = hood_area,
                stemdens = nTrees/hoodarea,
                stemdens_acre = stemdens/247.105)
    
    return(treedensity_neighbourhood)
    
  }
  
  else if (scale == 'road'){
    
    can_trees_i <- st_intersection(can_trees, road_bound_trees)
    
    
    treesize$streetid <- as.character(treesize$streetid)
    builddens$streetid <- as.character(builddens$streetid)
    
    treedensity_road <- can_trees_i %>% 
      group_by(streetid) %>%
      summarize(nTrees = n()) %>%
      filter(nTrees > 1) %>%
      mutate(streetid = as.character(streetid)) %>%
      inner_join(., as.data.frame(treesize), by = c("streetid"), suffix = c("", ".x")) %>% 
      inner_join(., as.data.frame(builddens), by = c("streetid"), suffix = c("", ".y")) %>%
      group_by(streetid) %>%
      summarize(city = first(city),
                streetid = streetid,
                nTrees = nTrees,
                ba_per_m2 = ba_per_m2,
                roadarea = road_area,
                stemdens = nTrees/roadarea,
                stemdens_acre = stemdens/247.105)
    
  }
  
  else {
    print("error: none of the scales matched")
  }
  
}