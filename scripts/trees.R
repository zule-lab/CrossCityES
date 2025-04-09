targets_trees <- c(
  

# density -----------------------------------------------------------------

  
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
    tree_density(can_trees, 'road', road_treesize, build_dens_road, road_bound_trees)
  ),
  

# richness ----------------------------------------------------------------

  tar_target(
    cities_treerichness,
    tree_richness(can_trees, 'city')
  ),
  
  tar_target(
    neighbourhood_treerichness,
    tree_richness(can_trees, 'neighbourhood')
  ),
  
  tar_target(
    road_treerichness,
    tree_richness(can_trees, 'road', road_bound_trees)
  ),

  tar_target(
    func_groups, 
    create_func_groups(TTTF_1.3, seed_mass, TTTF_newlit, ZULE_traits)
  ),


# size --------------------------------------------------------------------

  
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
    tree_size(can_trees, 'road', road_bound_trees)
  )
  
  
  
)