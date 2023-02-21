tree_richness <- function(){
  
  # TODO: talk to Kayleigh/Carly about cultivars 
  
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
  
  #  Individual‐based abundance data (datatype="abundance"): Input data for each assemblage/site
  #  include species abundances in an empirical sample of n individuals (“reference sample”). When
  #  there are N assemblages, input data consist of an S by N abundance matrix, or N lists of species
  #  abundances
  #  
  #  tar_target(
  #    city_inext, 
  #    iNEXT(city_matrix, datatype = "abundance", q = 0)
  #  ),
  #  
  #  tar_target(
  #    hood_inext,
  #    iNEXT(hood_matrix, datatype = "abundance", q = 0)
  #  )
  
  
  
  
  
}