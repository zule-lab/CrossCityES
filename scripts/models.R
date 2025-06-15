targets_models <- c(
  

  tar_target(
    cities_temp_tune,
    rf_tune(cities_lst_full %>% rename(value = mean_temp))
  ),
  
  tar_target(
    cities_uv_tune, 
    rf_tune(cities_pollution_full %>% filter(variable == 'mean_UV_city') %>% select(-variable))
  ),
  
  tar_target(
    cities_co_tune,
    rf_tune(cities_pollution_full %>% filter(variable == 'mean_CO_city') %>% select(-variable))
  ),
  
  tar_target(
    cities_no2_tune,
    rf_tune(cities_pollution_full %>% filter(variable == 'mean_NO2_city') %>% select(-variable))
  ),
  
  tar_target(
    cities_o3_tune,
    rf_tune(cities_pollution_full %>% filter(variable == 'mean_O3_city') %>% select(-variable))
  ),
  
  tar_target(
    cities_so2_tune,
    rf_tune(cities_pollution_full %>% filter(variable == 'mean_SO2_city') %>% select(-variable))
  ),
  
  
  tar_target(
    neighbourhoods_temp_tune,
    rf_tune(neighbourhoods_lst_full %>% rename(value = mean_temp))
  ),
  
  tar_target(
    neighbourhoods_uv_tune, 
    rf_tune(neighbourhoods_pollution_full %>% filter(variable == 'mean_neighbourhoods_UV') %>% select(-variable))
  ),
  
  tar_target(
    neighbourhoods_co_tune,
    rf_tune(neighbourhoods_pollution_full %>% filter(variable == 'mean_neighbourhoods_CO') %>% select(-variable))
  ),
  
  tar_target(
    neighbourhoods_no2_tune,
    rf_tune(neighbourhoods_pollution_full %>% filter(variable == 'mean_neighbourhoods_NO2') %>% select(-variable))
  ),
  
  tar_target(
    neighbourhoods_o3_tune,
    rf_tune(neighbourhoods_pollution_full %>% filter(variable == 'mean_neighbourhoods_O3') %>% select(-variable))
  ),
  
  tar_target(
    neighbourhoods_so2_tune,
    rf_tune(neighbourhoods_pollution_full %>% filter(variable == 'mean_neighbourhoods_SO2') %>% select(-variable))
  ),
  
  tar_target(
    streets_temp_tune, 
    # model a subset because dataset is too large (1000 street segments / city)
    rf_tune(roads_lst_full %>% rename(value = mean_temp) %>% 
              group_by(city) %>% sample_n(1000))
  )
  
  
  
)