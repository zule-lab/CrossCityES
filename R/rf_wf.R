rf_wf <- function(df_train){
  
  
  # this is the model, everything in the dataset is explanatory except legal status and ID
  mod_rec <- recipe(value ~ ., data = df_train) %>%
    # normalize all continuous vars
    step_normalize(all_numeric_predictors(), -doy) %>% 
    # converts factors (nominal) into numeric binary model terms
    #step_dummy(all_nominal(), -all_outcomes()) %>%
    # set correlation threshold to 0.8
    step_corr(threshold = 0.8) %>% 
    # remove variables that have near zero variation
    step_nzv()
  
  
  # tune hyperparameters mtry and min_n
  tune_spec <- rand_forest(
    mtry = tune(), # number of predictors that will be randomly sampled at each split
    trees = 1000,
    min_n = tune() # min number of data points in a node required for the node to split further
  ) %>%
    # regression is trying to predict/fit numeric values
    set_mode("regression") %>%
    # type of computational engine -> dependent on model type
    # ranger is default and allows tuning of hyperparameters
    set_engine("ranger")
  
  # put everything together in a workflow
  tune_wf <- workflow() %>%
    add_recipe(mod_rec) %>%
    add_model(tune_spec)
  
  
  return(tune_wf)
  
  
}
