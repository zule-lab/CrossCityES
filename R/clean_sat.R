clean_sat <- function(df, ...){

  # remove system:index and geo columns because they are not in useable format
  df <- df %>% select(-c('system.index', '.geo'))
  
  if(missing(...)) {
    df <- df
  } else {
    df %>% rename_with(~paste0(.x, ...), all_of(c("mean", "median", "max", "min", "count", "stdDev")))
  }
  
  return(df)
  
}