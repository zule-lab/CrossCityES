tree_richness <- function(can_trees, scale, func_groups, road_bound_trees = NULL){
  
  # correct species names 
  species_corr <- can_trees %>% 
    filter(!str_detect(fullname, "Unknown|Unidentified|Stump")) %>%
    mutate(fullname = case_when(fullname == "Salix sepulcralis" ~ "Salix x sepulcralis",
                                fullname == "Malus x thunder" ~ "Malus sylvestris",
                                .default = fullname))
  
  
  # calculate functional diversity
  func <- func_diversity(species_corr, scale, func_groups, road_bound_trees)  
  
  
  # format data for vegan
  matrix <- format_vegan(species_corr, scale, road_bound_trees)
  
  
  # use vegan to calculate species richness and Shannon diversity
  sr <- as_tibble(specnumber(matrix), rownames = scale) %>%
    rename(SpeciesRichness = value) %>%
    mutate(Shannon = diversity(matrix))
  
  
  # combine two datasets 
  full <- inner_join(sr, func)
  
  
  return(full)
  
}

format_vegan <- function(can_trees, scale, road_bound_trees = NULL){
  
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
    
    can_trees_i <- st_intersection(can_trees, road_bound_trees)
    
    # include streets that have more than 1 tree
    cutoff <- can_trees_i %>%
      group_by(streetid) %>% 
      mutate(nTrees = n()) %>% 
      filter(nTrees > 1)
    
    
    matrix <- cutoff %>% 
      drop_na(species) %>%
      group_by(streetid, fullname) %>%
      mutate(n = n()) %>%
      select(c(streetid, fullname, n)) %>% 
      st_set_geometry(NULL) %>%
      pivot_wider(names_from = 'fullname', values_from = 'n', values_fill = 0, values_fn = first) %>%
      column_to_rownames(var='streetid')
    
    return(matrix)
    
  }
  
  else { print("error: no scales matched") }
  
  
}


func_diversity <- function(species_corr, scale, func_groups, road_bound_trees = NULL){
  
  df <- species_corr %>% 
    st_drop_geometry() %>% 
    inner_join(., func_groups, by = 'fullname') 
  
  
  if (scale == 'city'){
    
    matrix <- df %>% 
      drop_na(FG) %>%
      group_by(city, FG) %>% 
      mutate(n = n()) %>%
      select(c(city, FG, n)) %>% 
      st_drop_geometry() %>%
      pivot_wider(names_from = 'FG', values_from = 'n', values_fill = 0, values_fn = first) %>%
      column_to_rownames(var='city')
    
    sr <- as_tibble(specnumber(matrix), rownames = scale) %>%
      rename(FG_richness = value) %>%
      mutate(FG_shannon = diversity(matrix))
    
    
  }
  
  else if (scale == 'neighbourhood'){
    
    matrix <- df %>% 
      group_by(city, hood) %>% 
      mutate(nTrees = n()) %>% 
      filter(nTrees > 50) %>%
      drop_na(FG) %>%
      group_by(city, hood, FG) %>% 
      mutate(n = n()) %>%
      select(c(city, hood, FG, n)) %>%
      unite("neighbourhood", c(city, hood), sep = "_") %>% 
      st_drop_geometry() %>%
      pivot_wider(names_from = 'FG', values_from = 'n', values_fill = 0, values_fn = first) %>%
      column_to_rownames(var='neighbourhood')
    
    sr <- as_tibble(specnumber(matrix), rownames = scale) %>%
      rename(FG_richness = value) %>%
      mutate(FG_shannon = diversity(matrix))
    
  }
  
  else if (scale == 'road') {
    
    can_trees_i <- st_intersection(species_corr, road_bound_trees)
    
    # include streets that have more than 1 tree
    cutoff <- can_trees_i %>%
      group_by(streetid) %>% 
      mutate(nTrees = n()) %>% 
      filter(nTrees > 1)
    
    matrix <- cutoff %>%
      inner_join(., func_groups, by = 'fullname') %>%
      drop_na(FG) %>%
      group_by(streetid, FG) %>% 
      mutate(n = n()) %>%
      select(c(streetid, FG, n)) %>%
      st_drop_geometry() %>%
      pivot_wider(names_from = 'FG', values_from = 'n', values_fill = 0, values_fn = first) %>%
      column_to_rownames(var='streetid')
    
    sr <- as_tibble(specnumber(matrix), rownames = scale) %>%
      rename(FG_richness = value) %>%
      mutate(FG_shannon = diversity(matrix))
    
    
  }
  
  else { print("error: no scales matched") }
}
