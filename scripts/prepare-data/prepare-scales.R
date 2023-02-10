targets_prepare_scales <- c(
  
  # select DAs that intersect with tree data and then merge to create the "city" boundaries
  tar_target(
    mun_bound_trees,
    trees_mun_bounds(da_bound_clean, can_trees, mun_bound_clean)
  ),
  
  # subset neighbourhoods to ones that intersect with tree data
  tar_target(
    neighbourhood_bound_trees,
    trees_neighbourhood_bounds(can_hood, can_trees)
  ),
  
  # create 25 m buffer surrounding roads and select roads that intersect with tree data
  tar_target(
    road_bound_trees,
    trees_roads_bounds(mun_road_clean, can_trees)
  )
  
)