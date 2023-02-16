targets_raw_data_viz <- c(
  
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
    neighbourhood_pca(neighbourhood_response_vars, c("mean_temp", "mean_CO", "mean_NO2", "mean_O3", "mean_SO2", "mean_UV"))
  ),
  
  tar_target(
    neighbourhood_tree_pca, 
    neighbourhood_pca(neighbourhood_tree_vars, c("mean_ba", "mean_dbh", "stemdens", "basaldens"))
  ),
  
  tar_target(
    neighbourhood_build_pca, 
    neighbourhood_pca(neighbourhood_build_vars, c("centroid_den", "area_den", "NDBI_mean", "NDVI_mean", "mean_buildhgt", "PropHighway", "PropMajRoads", "PropStreets", "RoadDens"))
  ),
  
  tar_target(
    neighbourhood_census_pca,
    neighbourhood_pca(neighbourhood_census_vars, -c(1:3))
  ),
  
  tar_render(
    raw_data_report,
    "raw-data-report.qmd"
  )
  
    
)