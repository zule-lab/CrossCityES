rf_tune <- function(df){
  
  
  # drop units from all columns to turn them into numeric class
  df <- drop_units(df)
  
  set.seed(123)
  # strata ensures that the random sampling is conducted within the stratification variable
  # resamples have equivalent proportions of the original dataset
  df_split <- initial_split(df, strata = city)
  df_train <- training(df_split)
  df_test <- testing(df_split)
  
  
  # this is the model, everything in the dataset is explanatory except legal status and ID
  mod_rec <- recipe(value ~ ., data = df_train) %>%
    # normalize all continuous vars
    step_normalize(all_numeric_predictors(), -doy) %>% 
    # converts factors (nominal) into numeric binary model terms
    step_dummy(all_nominal(), -all_outcomes()) %>%
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
  
  
  set.seed(234)
  mod_folds <- vfold_cv(df_train)
  
  # need to assess across many models - use parallel processing to use 20 grid points
  future::plan(strategy = 'multisession')
  
  set.seed(345)
  # computes performance metrics for tuning parameters (set in tune_wf) for resamples (trees_folds)
  tune_res <- tune_grid(
    tune_wf,
    resamples = mod_folds,
    # data frame of tuning combinations with 25 candidate parameter sets
    grid = 25,
    control = control_grid(save_pred = T),
    metrics = metric_set(mae, rsq))
  
  return(tune_res)
  
  
}
