raw_data_viz <- c(
  
  tar_target(
    city_data, 
    temp_city %>%
      inner_join(., pollution_city, by = "city") %>%
      inner_join(., treesize_city, by = "city") %>% 
      inner_join(., treedensity_city, by = "city") %>%
      inner_join(., can_build_city_dens, by = "city") %>%
      inner_join(., ndi_city, by = "city") %>%
      inner_join(., city_height, by = "city", suffix = c("", "_buildhgt")) %>%
      inner_join(., city_road_prop, by = "city") %>%
      left_join(., census_cma, by = "city") # missing Montreal - encoding issue  
  ),
  
  tar_target(
    neighbourhood_data, 
    temp_city %>%
      inner_join(., pollution_hood, by = "hood_id") %>%
      inner_join(., treesize_hood, by = "hood_id") %>% 
      inner_join(., treedensity_hood, by = "hood_id") %>%
      inner_join(., can_build_hood_dens, by = "hood_id") %>%
      inner_join(., ndi_hood, by = "hood_id") %>%
      inner_join(., hood_height, by = "hood_id", suffix = c("", "_buildhgt")) %>%
      inner_join(., hood_road_prop, by = "hood_id") %>%
      left_join(., hood_cen, by = "hood_id") 
  )
  
  
)