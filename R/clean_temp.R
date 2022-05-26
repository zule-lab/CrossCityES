clean_temp <- function(df){
  # packages 
  p <- c("anytime")
  lapply(p, library, character.only = T)
  # need to extract dates from the system.index column 
  df$date <- sapply(strsplit(df$system.index, "_"), function(x) x[3])
  df$date <- anydate(df$date)
  # need to extract image id from system.index without long series of 0s at the end
  df$id <- sub("_[^_]+$", "", df$system.index) 
  # drop system.index column - no longer useful 
  df <- subset(df, select = -system.index)
  
}