download_csv <- function(url, dest){
  
  download.file(url, dest, mode = "wb")
  
  df <- read_csv(dest)
  
  return(df)
  
}