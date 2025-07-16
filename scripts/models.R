targets_models <- c(
  
  
  tar_target(
    model_data, 
    list(cities_lst_full %>% rename(value = mean_temp),
         cities_pollution_full %>% filter(variable == 'mean_UV_city') %>% select(-variable),
         cities_pollution_full %>% filter(variable == 'mean_CO_city') %>% select(-variable),
         cities_pollution_full %>% filter(variable == 'mean_NO2_city') %>% select(-variable),
         cities_pollution_full %>% filter(variable == 'mean_O3_city') %>% select(-variable),
         cities_pollution_full %>% filter(variable == 'mean_SO2_city') %>% select(-variable),
         neighbourhoods_lst_full %>% rename(value = mean_temp),
         neighbourhoods_pollution_full %>% filter(variable == 'mean_UV_neighbourhood') %>% select(-variable),
         neighbourhoods_pollution_full %>% filter(variable == 'mean_CO_neighbourhood') %>% select(-variable),
         neighbourhoods_pollution_full %>% filter(variable == 'mean_NO2_neighbourhood') %>% select(-variable),
         neighbourhoods_pollution_full %>% filter(variable == 'mean_O3_neighbourhood') %>% select(-variable),
         neighbourhoods_pollution_full %>% filter(variable == 'mean_SO2_neighbourhood') %>% select(-variable),
         roads_lst_full %>% rename(value = mean_temp) %>% 
           group_by(city) %>% sample_n(1000)) %>% 
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