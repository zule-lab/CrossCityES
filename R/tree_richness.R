tree_richness <- function(can_trees, scale){
  
  # format data for vegan
  matrix <- format_vegan(can_trees, scale)
  
  # use vegan to calculate species richness and Shannon diversity
  sr <- as_tibble(specnumber(matrix), rownames = scale) %>%
    rename(SpeciesRichness = value) %>%
    mutate(Shannon = diversity(matrix))
  
  return(sr)
  
}

format_vegan <- function(can_trees, scale){
  
  if (scale == 'city'){
    
    matrix <- can_trees %>% 
      drop_na(species) %>%
      group_by(city, fullname) %>% 
      mutate(n = n()) %>%
      select(c(city, fullname, n)) %>% 
      st_set_geometry(NULL) %>%
      pivot_wider(names_from = 'fullname', values_from = 'n', values_fill = 0, values_fn = first) %>%
      column_to_rownames(var='city')
    
    return(matrix)
    
  }
  
  else if (scale == 'neighbourhood'){
    
    cutoff <- can_trees %>%
      group_by(city, hood) %>% 
      mutate(nTrees = n()) %>% 
      filter(nTrees > 50)
    
    matrix <- cutoff %>% 
      drop_na(species) %>%
      group_by(city, hood, fullname) %>% 
      mutate(n = n(),
             city_hood = paste0(city, "_", hood)) %>%
      select(c(city_hood, fullname, n)) %>% 
      st_set_geometry(NULL) %>%
      pivot_wider(names_from = 'fullname', values_from = 'n', values_fill = 0, values_fn = first) %>%
      column_to_rownames(var='city_hood')
    
    return(matrix)
    
  }
  
  else if (scale == 'road') {
    
    road_bound_trees <- tar_read(road_bound_trees)
    can_trees_i <- st_intersection(can_trees, road_bound_trees)
    
    # include streets that have more than 1 tree
    cutoff <- can_trees_i %>%
      group_by(city, hood, streetid) %>% 
      mutate(nTrees = n()) %>% 
      filter(nTrees > 1)
    
    
    matrix <- cutoff %>% 
      drop_na(species) %>%
      group_by(city, hood, streetid, fullname) %>%
      mutate(n = n(),
             hood_streetid = paste0(city, "_", hood, "_", streetid)) %>%
      select(c(hood_streetid, fullname, n)) %>% 
      st_set_geometry(NULL) %>%
      pivot_wider(names_from = 'fullname', values_from = 'n', values_fill = 0, values_fn = first) %>%
      column_to_rownames(var='hood_streetid')
    
    return(matrix)
    
  }
  
  else { print("error: no scales matched") }
  
}