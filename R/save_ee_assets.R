save_ee_assets <- function(mun_bound_trees,
               neighbourhood_bound_trees,
               road_bound_trees){
  
  write_sf(mun_bound_trees, 'ee/cities.shp')
  write_sf(neighbourhood_bound_trees, 'ee/neighbourhoods.shp')
  write_sf(road_bound_trees, 'ee/roads.shp')
  
  
}