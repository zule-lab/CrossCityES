dens_build <- function(can_build){
  
  can_build_m <- can_build %>%
    mutate(build_area = st_area(x),
           centroid = st_centroid(x)) %>%
    st_drop_geometry()
  
  can_build_m$centroid <- substr(can_build_m$centroid,3,nchar(can_build_m$centroid)-1)
  can_build_c <- separate(data = can_build_m, col = centroid, into = c("lat", "long"), sep = "\\, ")
  can_build_d <- st_as_sf(x = can_build_c, coords = c("lat","long"), crs = 3347, na.fail = FALSE, remove = TRUE)
  
  return(can_build_d)
  
  
  
}