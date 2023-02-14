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
    cbind(cities_CO, cities_NO2[,-'CMANAME'], cities_O3[,-'CMANAME'], cities_SO2[,-'CMANAME'], cities_UV[,-'CMANAME'])
  ),
  
  # combine pollution for neighbourhood level
  tar_target(
    neighbourhoods_pollution,
    cbind(neighbourhoods_CO, neighbourhoods_NO2[,-c('city', 'hood', 'hood_area', 'hood_id')], neighbourhoods_O3[,-c('city', 'hood', 'hood_area', 'hood_id')], neighbourhoods_SO2[,-c('city', 'hood', 'hood_area', 'hood_id')], neighbourhoods_UV[,-c('city', 'hood', 'hood_area', 'hood_id')])
  )
  
  
  
)