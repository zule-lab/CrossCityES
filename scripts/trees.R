targets_trees <- c(


# richness ----------------------------------------------------------------


  tar_target(
    func_groups, 
    create_func_groups(can_trees, TTTF_1.3, seed_mass, TTTF_newlit, ZULE_traits)
  ),

  tar_target(
    cities_treerichness,
    tree_richness(can_trees, 'city', func_groups)
  ),
  
  tar_target(
    neighbourhood_treerichness,
    tree_richness(can_trees, 'neighbourhood', func_groups)
  ),
  
  tar_target(
    road_treerichness,
    tree_richness(can_trees, 'road', func_groups, road_bound_trees)
  ),


# size --------------------------------------------------------------------

  
  tar_target(
    cities_treesize,
    tree_size(can_trees, mun_bound_trees, 'city')
  ),
  
  tar_target(
    neighbourhood_treesize,
    tree_size(can_trees, neighbourhood_bound_trees, 'neighbourhood')
  ),
  
  tar_target(
    road_treesize,
    tree_size(can_trees, road_bound_trees, 'road')
  ),
  
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
  )
  
)