tree_richness <- function(can_trees, scale){
  
  #  Individual‐based abundance data (datatype="abundance"): Input data for each assemblage/site
  #  include species abundances in an empirical sample of n individuals (“reference sample”). When
  #  there are N assemblages, input data consist of an S by N abundance matrix, or N lists of species
  #  abundances
  
  # format data for iNEXT
  matrix <- format_inext(can_trees, scale)
  
  if (scale == 'city'){
    # use iNEXT to get Hill number
    inext <- iNEXT(matrix, datatype = "abundance", q = 0)
    return(inext)
  } 
  
  else if (scale == 'neighbourhood'){
    # use iNEXT to get Hill number
    inext <- iNEXT(matrix, datatype = "abundance", q = 0)
    return(inext)
  } 
  
  else if (scale == 'road'){
    inext <- iNEXT(matrix, datatype = "incidence_raw", q=0)
    return(inext)
    
  }
  else{ print('inext error')}
  
  # extract minimum sampling coverage
  cov <- min(inext$DataInfo$SC)
  
  # estimate rarified diversity at minimum sampling coverage
  rarediv <- estimateD(matrix, datatype = "abundance", base = "coverage", 
                       level= cov, conf=0.95)
  
  
  rarediv_w <- pivot_wider(rarediv, id_cols = Assemblage, names_from = Order.q,
                           names_sep = ".", values_from = c(Method, SC, qD))
  rarediv_w <- rarediv_w %>% 
    select(-c(Method.1, Method.2, SC.1, SC.2)) %>% 
    rename(city = Assemblage, 
           method = Method.0, 
           minsampcov = SC.0, 
           SpeciesRichness = qD.0, 
           Shannon = qD.1, 
           Simpson = qD.2)
  
  return(rarediv_w)
  
  
  
}

format_inext <- function(can_trees, scale){
  
  if (scale == 'city'){
    
    matrix <- can_trees %>% 
      drop_na(species) %>%
      group_by(city, fullname) %>% 
      mutate(n = n()) %>%
      select(c(city, fullname, n)) %>% 
      st_set_geometry(NULL) %>%
      pivot_wider(names_from = 'city', values_from = 'n', values_fill = 0, values_fn = first) %>%
      column_to_rownames(var='fullname')
    
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
      pivot_wider(names_from = 'city_hood', values_from = 'n', values_fill = 0, values_fn = first) %>%
      column_to_rownames(var='fullname')
    
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
      group_by(city) %>%
      group_map(~ group_by(.x, hood, streetid, fullname) %>%
                  mutate(n = n(),
                         hood_streetid = paste0(hood, "_", streetid)) %>%
                  st_set_geometry(NULL) %>%
                  pivot_wider(id_cols = fullname, names_from = hood_streetid, values_from = n, values_fill = 0, values_fn = first) %>%
                  mutate_if(is.numeric, ~1 * (. != 0)) %>%
                  column_to_rownames("fullname")) %>%
      setNames(unique(can_trees_i$city))
    
    return(matrix)
    
  }
  
  else { print("error: no scales matched") }
  
}