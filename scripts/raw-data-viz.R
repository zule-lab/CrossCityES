raw_data_viz <- c(
  
  tar_target(
    city_response_facet, 
      city_plot(city_response_vars)
  ),
  
  tar_target(
    city_tree_facet, 
    city_plot(city_tree_vars)
  ),
  
  tar_target(
    city_build_facet, 
    city_plot(city_build_vars)
  ),
  
  tar_target(
    city_census_facet, 
    city_plot(city_census_vars)
  ),
  
  tar_target(
    neighbourhood_response_facet, 
    neighbourhood_plot(neighbourhood_response_vars)
  ),
  
  tar_target(
    neighbourhood_tree_facet, 
    neighbourhood_plot(neighbourhood_tree_vars)
  ),
  
  tar_target(
    neighbourhood_build_facet, 
    neighbourhood_plot(neighbourhood_build_vars)
  ),
  
  tar_target(
    neighbourhood_census_facet,
    neighbourhood_plot(neighbourhood_census_vars)
  ),
  
  tar_target(
    neighbourhood_response_pca, 
    neighbourhood_pca(neighbourhood_response_vars)
  ),
  
  tar_target(
    neighbourhood_tree_pca, 
    neighbourhood_pca(neighbourhood_tree_vars)
  ),
  
  tar_target(
    neighbourhood_build_pca, 
    neighbourhood_pca(neighbourhood_build_vars)
  ),
  
  tar_target(
    neighbourhood_census_pca,
    neighbourhood_pca(neighbourhood_census_vars)
  )
  
    
)