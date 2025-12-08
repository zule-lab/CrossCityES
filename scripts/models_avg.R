targets_models_avg <- c(
  
  tar_target(
    model_data_avg, 
    avg_model_data(model_data, roads_lst_full)
  ),
  
  tar_target(
    dataset_split_avg,
    split_dataset(model_data_avg),
    pattern = map(model_data_avg),
    iteration = 'list'
  ),
  
  tar_target(
    model_workflow_avg,
    rf_wf(dataset_split_avg$train),
    pattern = map(dataset_split_avg),
    iteration = 'list'
  ),
  
  tar_target(
    dataset_folds_avg, 
    vfold_cv(dataset_split_avg$train),
    pattern = map(dataset_split_avg),
    iteration = 'list'
  ),
  
  tar_target(
    all_models_avg,
    list(model_tune_avg_Fold01, model_tune_avg_Fold02, model_tune_avg_Fold03, model_tune_avg_Fold04, model_tune_avg_Fold05,
         model_tune_avg_Fold06, model_tune_avg_Fold07, model_tune_avg_Fold08, model_tune_avg_Fold09, model_tune_avg_Fold10) %>% 
      setNames(c('Fold01', 'Fold02', 'Fold03', 'Fold04', 'Fold05', 'Fold06', 'Fold07', 'Fold08', 'Fold09', 'Fold10'))
  ),
  
  tar_target(
    model_tune_list_avg_formatted,
    list(model_tune_list_avg_1, model_tune_list_avg_2, model_tune_list_avg_3, model_tune_list_avg_4, model_tune_list_avg_5, 
         model_tune_list_avg_6, model_tune_list_avg_7, model_tune_list_avg_8, model_tune_list_avg_9, model_tune_list_avg_10,
         model_tune_list_avg_11, model_tune_list_avg_12, model_tune_list_avg_13) %>%
      setNames(names(model_data))
  ),
  
  tar_target(
    final_models_avg_unnamed,
    select_model(model_tune_list_avg_formatted, names(model_tune_list_avg_formatted), model_workflow_avg, model_data_avg, "_avg"),
    pattern = map(model_tune_list_avg_formatted, model_workflow_avg, dataset_split_avg, model_data_avg),
    iteration = 'list'
  ),
  
  tar_target(
    final_models_avg,
    final_models_avg_unnamed %>% setNames(names(model_data_avg))
  ),
  
  tar_target(
    vi_avg,
    extract_vi(final_models_avg, '_avg')
  ),
  
  tar_target(
    pdp_avg,
    plot_pdp(final_models_avg, names(final_models_avg), dataset_split_avg, vi_avg, "_avg"),
    pattern = map(final_models_avg, dataset_split_avg),
    iteration = 'list'
  )
  
  
)

targets_models_map_avg <- tar_map(
  
  values = tibble(fold = c('Fold01', 'Fold02', 'Fold03', 'Fold04', 'Fold05', 'Fold06', 'Fold07', 'Fold08', 'Fold09', 'Fold10')),
  
  tar_target(
    model_tune_avg, 
    rf_tune(fold, model_workflow_avg, dataset_folds_avg),
    pattern = map(model_workflow_avg, dataset_folds_avg),
    iteration = 'list'
  )
  
)

targets_tune_map_avg <- tar_map(
  
  # should be 13 
  values = tibble(index = c(1:13)),
  
  tar_target(
    model_tune_list_avg,
    map(all_models_avg, index)
  )
  
  
)
