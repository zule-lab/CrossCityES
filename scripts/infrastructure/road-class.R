targets_road_class <- c(
  
    tar_target(
      cities_roadclass,
      road_class(road_bound_trees, mun_bound_trees, 'city')
    ),
    
    tar_target(
      neighbourhood_roadclass,
      road_class(road_bound_trees, neighbourhood_bound_trees, 'neighbourhood')
    )
    
)