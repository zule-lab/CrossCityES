calc_cen <- function(can_build){
  
  can_build$centroid <- substr(can_build$centroid,3,nchar(can_build$centroid)-1)
  can_build <- separate(data = can_build, col = centroid, into = c("lat", "long"), sep = "\\, ")
  can_build <- st_as_sf(x = can_build, coords = c("lat","long"), crs = 3347, na.fail = FALSE, remove = TRUE)
  
  return(can_build)
  
}