download_tif <- function(url, dest){
  
  temp <- tempfile()
  
  download.file(url, dest, mode = "wb")
  
  shp <- read_stars(file.path(dest))
  
  return(shp)
  
}