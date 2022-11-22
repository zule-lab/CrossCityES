treedensity_data_city_neighbourhood_road <- c(
  
  tar_target(
    treedensity_city, 
    all_tree %>% 
      group_by(city) %>%
      summarize(nTrees = n(),
                mean_ba = treesize_city$mean_ba,
                cityarea = can_build_city_dens$city_area,
                stemdens = nTrees/cityarea,
                basaldens = mean_ba/cityarea)
  ),
  
  tar_target(
    treedensity_hood, 
    all_tree %>% 
      group_by(city, hood_id) %>%
      summarize(nTrees = n(),
                mean_ba = treesize_hood$mean_ba,
                hoodarea = can_build_hood_dens$hood_area,
                stemdens = nTrees/hoodarea,
                basaldens = mean_ba/hoodarea)
  ),
  
  tar_target(
    treedensity_road, 
    all_tree %>% 
      group_by(city, hood_id, streetid) %>%
      summarize(nTrees = n(),
                mean_ba = treesize_road$mean_ba,
                roadlength = can_build_road_dens$road_length,
                stemdens = nTrees/roadlength,
                basaldens = mean_ba/roadlength)
  )
  
  
)