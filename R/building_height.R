building_height <- function(dem, buildings){ 
  
  # calculate building centroids
  cent <- st_centroid(buildings)
  
  # transform centroids to match raster
  cent_t <- st_transform(cent, crs = st_crs(r))
  
  # extract height at the centroids
  h <- st_extract(r, cent_t)
  
  # back transform and return heights
  h_t <- st_transform(h, crs = st_crs(cent))
  
  return(h_t)
  
  }