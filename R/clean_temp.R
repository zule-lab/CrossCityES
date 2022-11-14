clean_temp <- function(df){

  # remove system:index and geo columns because they are not in useable format
  df <- df %>% select(-c('system.index', '.geo'))
  
}