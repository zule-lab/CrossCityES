targets_tree_richness <- c(
  
  tar_target(
    cities_treerichness,
    tree_richness(can_trees, 'city')
  ),
  
  tar_target(
    neighbourhood_treerichness,
    tree_richness(can_trees, 'neighbourhood')
  )
  
  # road scale tree richness?
  
)