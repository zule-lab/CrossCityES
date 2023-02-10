trees_neighbourhood_bounds <- function(can_hood, can_trees){
  
  bounds <- can_hood %>%
    mutate(id = row_number()) %>%
    filter(id %in% unlist(st_intersects(can_trees, can_hood))) 
  
  # export as shapefiles so they can be uploaded to EE as assets
  write_sf(bounds, "large/ee_assets/NeighbourhhoodBoundaries.shp")
  
  return(bounds)
  
}