rf_tune <- function(folds, model_workflow, dataset_folds){
  
  fold <- dataset_folds %>% 
    filter(id == folds) 
  
  fold_format <- manual_rset(fold$splits, fold$id)
  
  tune_res <- tune_grid(
    model_workflow,
    resamples = fold_format,
    # data frame of tuning combinations with 15 candidate parameter sets
    grid = 15,
    metrics = metric_set(mae, rsq))
  
  return(fold)
  
}