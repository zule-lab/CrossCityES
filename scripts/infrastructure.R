targets_infrastructure <- c(
  

# building density --------------------------------------------------------

  tar_target(
    build_dens,
    dens_build(can_build)
  ),
  
  tar_target(
    build_dens_city,
    geo_build_dens(mun_bound_trees, build_dens, 'city')
  ),
  
  tar_target(
    build_dens_neighbourhood,
    geo_build_dens(neighbourhood_bound_trees, build_dens, 'neighbourhood')
  ),
  
  tar_target(
    build_dens_road,
    geo_build_dens(road_bound_trees, build_dens, 'road')
  ),


# road class --------------------------------------------------------------

  tar_target(
    cities_roadclass,
    road_class(mun_road_clean, mun_bound_trees, 'city')
  ),
  
  tar_target(
    neighbourhood_roadclass,
    road_class(mun_road_clean, neighbourhood_bound_trees, 'neighbourhood')
  )

)