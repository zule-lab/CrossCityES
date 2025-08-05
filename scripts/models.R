targets_models <- c(
  
  
  tar_target(
    model_data, 
    list(cities_lst_full %>% dplyr::rename(value = mean_temp),
         cities_pollution_full %>% filter(variable == 'mean_UV_city') %>% select(-variable),
         cities_pollution_full %>% filter(variable == 'mean_CO_city') %>% select(-variable),
         cities_pollution_full %>% filter(variable == 'mean_NO2_city') %>% select(-variable),
         cities_pollution_full %>% filter(variable == 'mean_O3_city') %>% select(-variable),
         cities_pollution_full %>% filter(variable == 'mean_SO2_city') %>% select(-variable),
         neighbourhoods_lst_full %>% dplyr::rename(value = mean_temp),
         neighbourhoods_pollution_full %>% filter(variable == 'mean_UV_neighbourhood') %>% select(-variable),
         neighbourhoods_pollution_full %>% filter(variable == 'mean_CO_neighbourhood') %>% select(-variable),
         neighbourhoods_pollution_full %>% filter(variable == 'mean_NO2_neighbourhood') %>% select(-variable),
         neighbourhoods_pollution_full %>% filter(variable == 'mean_O3_neighbourhood') %>% select(-variable),
         neighbourhoods_pollution_full %>% filter(variable == 'mean_SO2_neighbourhood') %>% select(-variable),
         roads_lst_full %>% 
           dplyr::rename(value = mean_temp) %>% 
           group_by(city) %>% 
           sample_n(1000) %>%
           select(-c(streetdir, streettype)) ) %>% 
      setNames(., c('cities_temp', 'cities_UV', 'cities_CO', 'cities_NO2', 'cities_O3', 'cities_SO2',
               'neighbourhoods_temp', 'neighbourhoods_UV', 'neighbourhoods_CO', 'neighbourhoods_NO2', 'neighbourhoods_O3', 'neighbourhoods_SO2',
               'streets_temp'))
    
  ),
  
  tar_target(
    dataset_split,
    split_dataset(model_data),
    pattern = map(model_data),
    iteration = 'list'
  ),
  
  tar_target(
    model_workflow,
    rf_wf(dataset_split$train),
    pattern = map(dataset_split),
    iteration = 'list'
  ),
  
  tar_target(
    dataset_folds, 
    vfold_cv(dataset_split$train),
    pattern = map(dataset_split),
    iteration = 'list'
  ),
  
  tar_target(
    all_models,
    list(model_tune_Fold01, model_tune_Fold02, model_tune_Fold03, model_tune_Fold04, model_tune_Fold05, model_tune_Fold06,
         model_tune_Fold07, model_tune_Fold08, model_tune_Fold09, model_tune_Fold10) %>% 
      setNames(c('Fold01', 'Fold02', 'Fold03', 'Fold04', 'Fold05', 'Fold06', 'Fold07', 'Fold08', 'Fold09', 'Fold10'))
  ),
  
  tar_target(
    model_tune_list_formatted,
    list(model_tune_list_1, model_tune_list_2, model_tune_list_3, model_tune_list_4, model_tune_list_5, 
         model_tune_list_6, model_tune_list_7, model_tune_list_8, model_tune_list_9, model_tune_list_10,
         model_tune_list_11, model_tune_list_12, model_tune_list_13) %>%
      setNames(names(model_data))
  ),
  
  tar_target(
    final_models_unnamed,
    select_model(model_tune_list_formatted, names(model_tune_list_formatted), model_workflow, model_data),
    pattern = map(model_tune_list_formatted, model_workflow, dataset_split, model_data),
    iteration = 'list'
  ),
  
  tar_target(
    final_models,
    final_models_unnamed %>% setNames(names(model_data))
  ),
  
  tar_target(
    pdp,
    plot_pdp(final_models, names(final_models), dataset_split$train),
    pattern = map(final_models, dataset_split),
    iteration = 'list'
  )
  
  
)

targets_models_map <- tar_map(
  
  values = tibble(fold = c('Fold01', 'Fold02', 'Fold03', 'Fold04', 'Fold05', 'Fold06', 'Fold07', 'Fold08', 'Fold09', 'Fold10')),
  
  tar_target(
    model_tune, 
    rf_tune(fold, model_workflow, dataset_folds),
    pattern = map(model_workflow, dataset_folds),
    iteration = 'list'
  )
  
)

targets_tune_map <- tar_map(
  
  # should be 13 
  values = tibble(index = c(1:13)),
  
  tar_target(
    model_tune_list,
    map(all_models, index)
  )
  
  
)
