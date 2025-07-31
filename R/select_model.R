select_model <- function(tune_list, name, tune_wf, model_data){
  
  # make data split
  df_split <- initial_split(model_data[[1]], strata = city)
  df_train <- training(df_split)
  df_test <- testing(df_split)
  
  # combine tune dfs
  df <- do.call(rbind, tune_list[[1]])
  
  # autoplot
  auto <- autoplot(df)
  ggsave(paste0('graphics/', name, '_autoplot.png'), auto)
  
  
  # select best model
  best_auc <- select_best(df, metric = "mae")
  
  # fit final model using best 
  cores <- parallel::detectCores()
  
  last_mod <-
    rand_forest(mtry = best_auc$mtry, min_n = best_auc$min_n, trees = 1000) %>%
    set_mode("regression") %>%
    set_engine("ranger", num.threads = cores, importance = "impurity")
  
  
  # the last workflow
  last_workflow <-
    tune_wf %>%
    update_model(last_mod)
  
  # the last fit
  set.seed(345)
  last_rf_fit <-
    last_workflow %>%
    last_fit(df_split,
             metrics = metric_set(mae, rsq))
  
  last_rf_model <- last_rf_fit$.workflow[[1]]
  
  
  
  # prediction vs actual values for final model
  all_predictions <- bind_rows(
    augment(last_rf_model, new_data = df_train) %>% 
      mutate(type = "train"),
    augment(last_rf_model, new_data = df_test) %>% 
      mutate(type = "test")
  )
  
  # metrics between testing and training 
  
  all_predictions %>% 
    group_by(type) %>% 
    metrics(value, .pred)
  
  # model fit between testing and training 
  
  model_fit <- all_predictions %>%
    ggplot(aes(value, .pred)) +
    geom_point() +
    geom_abline() +
    facet_wrap(~type)
  
  ggsave(paste0('graphics/', name, '_model-fit.png'), model_fit)
  
  
  # most important variables
  vip <- last_rf_fit %>%
    extract_fit_parsnip() %>%
    vip(geom = "point") +
    theme_classic()
  
  ggsave(paste0('graphics/', name, '_vip.png'), vip)
  
  
  return(last_rf_model)
  
  
  
}