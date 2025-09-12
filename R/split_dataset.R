split_dataset <- function(model_dataset){
  
  # drop units from all columns to turn them into numeric class
  df <- drop_units(model_dataset[[1]])
  
  # strata ensures that the random sampling is conducted within the stratification variable
  # resamples have equivalent proportions of the original dataset
  df_split <- initial_split(model_dataset[[1]], strata = city)
  df_train <- training(df_split)
  df_test <- testing(df_split)
  
  dfs <- list(df_train, df_test) %>% setNames(., c('train', 'test'))
  
  return(dfs)
  
}
