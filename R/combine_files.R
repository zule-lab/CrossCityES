combine_files <- function(x, n, o){
  
  l <- as.character(unzip(x, list = T)$Name)
  
  l <- l[1:n]
  
  data <- lapply(l, function(y) read.csv((unzip(x, y, exdir = o)))) %>%
    bind_rows()
  
  return(data)
  
  
}