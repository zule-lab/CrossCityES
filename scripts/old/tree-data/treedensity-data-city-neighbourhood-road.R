targets_treedensity_city_neighbourhood_road <- c(
  
  tar_target(
    treedensity_city, 
    all_tree %>% 
      group_by(city) %>%
      st_set_geometry(NULL) %>%
      summarize(nTrees = n()) %>%
      inner_join(., as.data.frame(treesize_city), by = "city") %>% 
      inner_join(., as.data.frame(can_build_city_dens), by = "city") %>%
      summarize(city = city,
                nTrees = nTrees,
                mean_ba = mean_ba, # sq ft
                cityarea = city_area, # km2
                stemdens = nTrees/cityarea, # trees/km2
                stemdens_acre = stemdens/247.105, # conversion from num trees/km2 to num trees/acre
                basaldens = mean_ba*stemdens_acre) # sq ft/acre
  ),
  
  tar_target(
    treedensity_hood, 
    all_tree %>% 
      group_by(city, hood_id) %>%
      st_set_geometry(NULL) %>%
      summarize(nTrees = n()) %>%
      inner_join(., as.data.frame(treesize_hood), by = "hood_id") %>% 
      inner_join(., as.data.frame(can_build_hood_dens), by = "hood_id") %>%
      summarize(city = city,
                hood_id = hood_id,
                nTrees = nTrees,
                mean_ba = mean_ba,
                hoodarea = hood_area,
                stemdens = nTrees/hoodarea,
                stemdens_acre = stemdens/247.105,
                basaldens = mean_ba*stemdens_acre)
  ),
  
  tar_target(
    treedensity_road, # SOMETHING WEIRD IS HAPPENING
    all_tree %>% 
      group_by(city, hood_id, streetid) %>%
      summarize(nTrees = n()) %>%
      mutate(streetid = as.character(streetid)) %>%
      inner_join(., as.data.frame(treesize_road), by = "streetid") %>% 
      inner_join(., as.data.frame(can_build_road_dens), by = "streetid") %>%
      summarize(city = city,
                hood_id = hood_id.x,
                streetid = streetid,
                nTrees = nTrees,
                mean_ba = mean_ba,
                roadlength = road_length,
                stemdens = nTrees/roadlength,
                stemdens_acre = stemdens/247.105,
                basaldens = mean_ba*stemdens_acre)
  )
  
  
)