targets_census <- c(
  
  tar_target(
    census_city,
    geo_census(mun_bound_trees, census_da_clean, 'city')
    
  ),
  
  tar_target(
    census_neighbourhood,
    geo_census(neighbourhood_bound_trees, census_da_clean, 'neighbourhood')
  ),
  
  tar_target(
    census_road,
    geo_census(road_bound_trees, census_da_clean, 'road')
  )
  
  
)