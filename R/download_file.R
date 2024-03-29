download_file <- function(url, dest, extension){
  if (extension == 'csv') {
    download_csv(url, dest)
  } else if (extension == 'tif') {
    download_tif(url, dest)
  } else if (extension %in% c('shp', 'zip')) {
    download_shp(url, dest)
  }
}


download_tif <- function(url, dest){
  temp <- tempfile()
  download.file(url, dest, mode = "wb")
  star <- read_stars(file.path(dest), proxy = TRUE)
  return(star)
}


download_csv <- function(url, dest){
  download.file(url, dest, mode = "wb")
  df <- read_csv(dest)
  return(df)
}


download_shp <- function(url, dest){
  temp <- tempfile()
  download.file(url, dest, mode = "wb")
  shp <- st_read(file.path("/vsizip", dest))
  return(shp)
}