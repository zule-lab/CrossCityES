tree_density <- function(can_trees, scale, treesize, builddens){
  
  if (scale == 'city'){
    
    treedensity_city <- can_trees %>% 
      group_by(city) %>%
      st_set_geometry(NULL) %>%
      summarize(nTrees = n()) %>%
      inner_join(., as.data.frame(treesize), by = "city") %>% 
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
      group_by(city, hood) %>%
      st_set_geometry(NULL) %>%
      summarize(nTrees = n()) %>%
      filter(nTrees > 50) %>%
      inner_join(., as.data.frame(builddens), by = c("city", "hood")) %>% 
      inner_join(., as.data.frame(treesize), by = c("city" , "hood")) %>%
      summarize(city = city,
                hood = hood,
                nTrees = nTrees,
                mean_ba = mean_ba,
                hoodarea = hood_area,
                stemdens = nTrees/hoodarea,
                stemdens_acre = stemdens/247.105,
                basaldens = mean_ba*stemdens_acre)
    
    return(treedensity_neighbourhood)
    
  }
  
  else if (scale == 'road'){
    
    road_bound_trees <- tar_read(road_bound_trees)
    
    can_trees_i <- st_intersection(can_trees, road_bound_trees)
    
    
    treesize$streetid <- as.character(treesize$streetid)
    builddens$streetid <- as.character(builddens$streetid)
    
    treedensity_road <- can_trees_i %>% 
      group_by(city, hood, streetid) %>%
      summarize(nTrees = n()) %>%
      filter(nTrees > 1) %>%
      mutate(streetid = as.character(streetid)) %>%
      inner_join(., as.data.frame(treesize), by = c("city", "hood", "streetid"), suffix = c("", ".x")) %>% 
      inner_join(., as.data.frame(builddens), by = c("city", "streetid"), suffix = c("", ".y")) %>%
      group_by(city, hood, streetid) %>%
      summarize(city = city,
                hood = hood,
                streetid = streetid,
                nTrees = nTrees,
                mean_ba = mean_ba,
                roadarea = road_area,
                stemdens = nTrees/roadarea,
                stemdens_acre = stemdens/247.105,
                basaldens = mean_ba*stemdens_acre)
    
  }
  
  else {
    print("error: none of the scales matched")
  }
  
}