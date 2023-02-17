targets_tree_density <- c(
  
  tar_target(
    cities_treedensity, 
    tree_density(can_trees, 'city', cities_treesize, build_dens_city)
  ),
  
  tar_target(
    neighbourhood_treedensity, 
    tree_density(can_trees, 'neighbourhood', neighbourhood_treesize, build_dens_neighbourhood)
  ),
  
  tar_target(
    road_treedensity,
    tree_density(can_trees, 'road', road_treesize, build_dens_road)
  )
  
  
)