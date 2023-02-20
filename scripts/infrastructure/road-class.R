targets_road_class <- c(
  
    tar_target(
      cities_roadclass,
      road_class(mun_road_clean, mun_bound_trees, 'city')
    ),
    
    tar_target(
      neighbourhood_roadclass,
      road_class(mun_road_clean, neighbourhood_bound_trees, 'neighbourhood')
    )
    
)