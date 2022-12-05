targets_tree_richness <- c(
  
  tar_target(
    city_matrix, 
    all_tree %>% 
      drop_na(species) %>%
      group_by(city) %>% 
      mutate(n = n()) %>%
      select(c(city, fullname, n)) %>% 
      st_set_geometry(NULL) %>%
      group_map(~ pivot_wider(data = .x, names_from = 'fullname', values_from = 'n', values_fill = 0, values_fn = first) %>%
                  mutate_if(is.numeric, ~1 * (. != 0))) %>% 
      setNames(unique(all_tree$city))
  ),
  
  tar_target(
   hood_matrix, 
   all_tree %>% 
     group_by(hood_id) %>% 
     mutate(n = n()) %>%
     select(c(hood_id, fullname, n)) %>% 
     st_set_geometry(NULL) %>%
     group_map(~ pivot_wider(data = .x, names_from = 'fullname', values_from = 'n', values_fill = 0, values_fn = first) %>%
                 mutate_if(is.numeric, ~1 * (. != 0))) %>% 
     setNames(unique(all_tree$hood_id))
  )
  
#  tar_target(
#    city_inext, 
#    iNEXT(city_matrix, datatype = "incidence_raw", q = 0)
#  ),
#  
#  tar_target(
#    hood_inext,
#    iNEXT(hood_matrix, datatype = "incidence_raw", q = 0)
#  )
  
  

  
)