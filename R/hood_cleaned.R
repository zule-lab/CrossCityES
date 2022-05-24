hood_cleaned <- function(df, prefix){

  df <- df %>% mutate(hood_id = paste0(prefix, seq.int(nrow(df)))) # add hood id
  
  df$hood <- str_to_title(df$hood)   # change case of hood names
  
  df <- st_transform(df, crs = 3347) # transform
  
  df$hood_area <- st_area(df) # add area column
  
  return(df)
  
}