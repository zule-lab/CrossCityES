trees_mun_bounds <- function(da_bound_clean, can_trees, mun_bound){
  
  bounds <- da_bound_clean %>%
    mutate(id = row_number()) %>%
    filter(id %in% unlist(st_intersects(can_trees, da_bound_clean))) %>% 
    st_intersection(., mun_bound) %>%
    select(CMANAME) %>%
    group_by(CMANAME) %>%
    summarize(geometry = st_union(geometry),
              CMANAME = first(CMANAME))
  
  # export as shapefiles so they can be uploaded to EE as assets
  write_sf(bounds, "large/ee_assets/MunicipalBoundaries.shp")
  
  return(bounds)
  
}