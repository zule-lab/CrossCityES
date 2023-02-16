targets_prepare_ee <- c(
  
  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      clean_ee(dl_link, dl_path, file_ext)
    ),
    values = values_ee
  ),
  
  # combine pollution for city level
  tar_target(
    cities_pollution,
    bind_cols(cities_CO, 
              cities_NO2 %>% select(-CMANAME), 
              cities_O3 %>% select(-CMANAME),
              cities_SO2 %>% select(-CMANAME),
              cities_UV %>% select(-CMANAME)) %>%
      rename(city = CMANAME)
    ),
  
  # combine pollution for neighbourhood level
  tar_target(
    neighbourhoods_pollution,
    bind_cols(neighbourhoods_CO %>% select(-c('id')),
              neighbourhoods_NO2 %>% select(-c('id', 'city', 'hood', 'hood_area', 'hood_id')),
              neighbourhoods_O3 %>% select(-c('id', 'city', 'hood', 'hood_area', 'hood_id')),
              neighbourhoods_SO2 %>% select(-c('id', 'city', 'hood', 'hood_area', 'hood_id')),
              neighbourhoods_UV %>% select(-c('id', 'city', 'hood', 'hood_area', 'hood_id')))
    )
  
)
