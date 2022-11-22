richness_data_city_neighbourhood_road <- c(
  
  tar_target(
    city_matrix, 
    all_tree %>% 
      na.omit(species) %>%
      group_by(city) %>% 
      mutate(n = n()) %>%
      select(c(city, fullname, n)) %>% 
      st_set_geometry(NULL) %>%
      pivot_wider(names_from = 'fullname', values_from = 'n', values_fill = 0, values_fn = first) %>%
      mutate_if(is.numeric, ~1 * (. != 0)) %>%
      column_to_rownames("city") 
  )
  
#  
#  tar_target(
#    hood_matrix,
#   all_tree %>% 
#     group_by(CMANAME, hood_id) %>% 
#     group_map(~ group_by(.x, SpCode) %>% 
#                 tally() %>% 
#                 pivot_wider(id_cols = SpCode, names_from = hood_id, values_from = n, values_fill = 0) %>%
#                 mutate_if(is.numeric, ~1 * (. != 0)) %>%
#                 column_to_rownames("SpCode")) %>%
#     setNames(unique(all_tree$hood_id))
#  )
#  
  

  
)