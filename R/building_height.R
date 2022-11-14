building_height <- function(r1, ..., buildings){ 
  
  # combine rasters (or ignore if only 1 - Halifax)
  if(missing(...)) {
    r <- r1
  } else {
    r <- st_mosaic(r1, ...)
  }
  
  # calculate building centroids
  cent <- st_centroid(buildings)
  
  # transform centroids to match raster
  cent_t <- st_transform(cent, crs = st_crs(r))
  
  # extract height at the centroids
  #h <- st_extract(r, cent_t)
  
  # back transform and return heights
  #h_t <- st_transform(h, cent)
  #return(h_t)
  
  }