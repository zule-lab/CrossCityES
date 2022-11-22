richness_data_city_neighbourhood_road <- c(
  
  tar_target(
    city_matrix, 
    all_tree %>% 
      drop_na(species) %>%
      group_by(city) %>% 
      mutate(n = n()) %>%
      select(c(city, fullname, n)) %>% 
      st_set_geometry(NULL) %>%
      pivot_wider(names_from = 'fullname', values_from = 'n', values_fill = 0, values_fn = first) %>%
      mutate_if(is.numeric, ~1 * (. != 0)) %>%
      column_to_rownames("city")
  ),
  
  tar_target(
   hood_matrix, 
    all_tree %>% 
      drop_na(species) %>%
      group_by(hood_id) %>% 
      mutate(n = n()) %>%
      select(c(hood_id, fullname, n)) %>% 
      st_set_geometry(NULL) %>%
      pivot_wider(names_from = 'fullname', values_from = 'n', values_fill = 0, values_fn = first) %>%
      mutate_if(is.numeric, ~1 * (. != 0)) %>%
      column_to_rownames("hood_id")
  )
  
  

  
)