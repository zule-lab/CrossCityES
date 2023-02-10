clean_ee <- function(dl_link, dl_path, file_ext){
  
  drive_download(file = dl_link, path = dl_path, type = file_ext)
  
  file <- read.csv(dl_path)
  
  #ee <- clean_sat(file, dl_path)
  
  return(file)
  
}

clean_sat <- function(file){
  
  
  
  
  
  
  
}