tree_richness <- function(can_trees, scale){
  
  # TODO: talk to Kayleigh/Carly about cultivars, check typos, think about SR on street scale 
  
  
  #  Individual‐based abundance data (datatype="abundance"): Input data for each assemblage/site
  #  include species abundances in an empirical sample of n individuals (“reference sample”). When
  #  there are N assemblages, input data consist of an S by N abundance matrix, or N lists of species
  #  abundances
  
  # format data for iNEXT
  matrix <- format_inext(can_trees, scale)
  

  # use iNEXT to get Hill numbers
  inext <- iNEXT(matrix, datatype = "abundance", q = 0)
  
  # extract minimum sampling coverage
  cov <- min(inext$DataInfo$SC)
  
  # estimate rarified diversity at minimum sampling coverage
  rarediv <- estimateD(matrix, datatype = "abundance", base = "coverage", 
                       level= cov, conf=0.95)
  
  
  #rarediv_w <- pivot_wider(rarediv, id_cols = site, names_from = order,
  #                         names_sep = ".", values_from = c(method, SC, qD))
  #rarediv_w <- rarediv_w %>% 
  #  select(-c(method.1, method.2, SC.1, SC.2)) %>% 
  #  rename(SWP = site, 
  #         method = method.0, 
  #         sampcov = SC.0, 
  #         SpeciesRichness = qD.0, 
  #         Shannon = qD.1, 
  #         Simpson = qD.2)
  #
  
  
  
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
    
    
    matrix <- can_trees %>% 
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
  
  else { print("error: no scales matched") }
  
}