clean_temp <- function(df, label){
  
  # remove system:index and geo columns because they are not in useable format
  df <- df %>% select(-c('system.index', '.geo')) %>%
    rename_with(., ~ paste0(.x, "_", label), .cols = all_of(c("mean", "median", "max", "min", "count", "stdDev")))

  
  return(df)
  
}