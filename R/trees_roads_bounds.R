trees_roads_bounds <- function(mun_road_clean, can_trees){
  
  bounds <- mun_road_clean %>%
    st_buffer(., 25) %>% 
    mutate(id = row_number()) %>%
    filter(id %in% unlist(st_intersects(can_trees, .))) 
  
  write_sf(bounds, "large/ee_assets/RoadBoundaries.shp")
  
  return(bounds)
  
}