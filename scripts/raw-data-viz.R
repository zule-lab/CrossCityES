raw_data_viz <- c(
  
  tar_target(
    city_data, 
    temp_city %>%
      inner_join(., pollution_city, by = "city") %>%
      inner_join(., treesize_city, by = "city") %>% 
      inner_join(., treedensity_city, by = "city") %>%
      inner_join(., can_build_city_dens, by = "city") %>%
      inner_join(., ndi_city, by = "city") %>%
      inner_join(., city_height, by = "city") %>%
      inner_join(., city_road_prop, by = "city") %>%
      inner_join(., census_cma, by = "city") %>% 
      select(-c(geometry.x, geometry.x.x, geometry.y, geometry.y.y, mean_ba.y, CMANAME)) %>%
      rename(mean_ba = mean_ba.x,
             mean_buildhgt = mean, 
             median_buildhgt = median, 
             sd_buildhgt = sd)
  ),
  
  tar_target(
    neighbourhood_data, 
    temp_hood %>%
      inner_join(., pollution_hood, by = "hood_id") %>%
      inner_join(., treesize_hood, by = "hood_id") %>% 
      inner_join(., treedensity_hood, by = "hood_id") %>%
      inner_join(., can_build_hood_dens, by = "hood_id") %>%
      inner_join(., ndi_hood, by = "hood_id") %>%
      inner_join(., hood_height, by = "hood_id") %>%
      inner_join(., hood_road_prop, by = "hood_id") %>%
      left_join(., hood_cen, by = "hood_id") %>%
      select(-c(geometry, geometry.x, geometry.x.x, geometry.y, geometry.y.y, city.y, hood.y, hood_area.y, mean_ba.y,
                city, city.x.x, hood.x.x, hood_area.x.x, city.y.y, hood.y.y, hood_area.y.y,
                city.x.x.x, hood.x.x.x,city.y.y.y, hood.y.y.y, city.x.x.x.x, city.y.y.y.y,)) %>%
      rename(city = city.x,
             hood = hood.x, 
             hood_area = hood_area.x,
             mean_ba = mean_ba.x,
             mean_buildhgt = mean, 
             median_buildhgt = median,
             sd_buildhgt = sd)
  )
  
  
)