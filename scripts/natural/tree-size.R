targets_tree_size <- c(
  
  tar_target(
    cities_treesize,
    tree_size(can_trees, 'city')
  ),
  
  tar_target(
    neighbourhood_treesize,
    tree_size(can_trees, 'neighbourhood')
  ),
  
  tar_target(
    road_treesize,
    tree_size(can_trees, 'road')
  )
  
  
  
)
