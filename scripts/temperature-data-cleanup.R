temperature_data_cleanup <- c(
  
  tar_file_read(
    temp_city_raw,
    file.path("large/temperature", "LST_cities.csv"),
    read.csv(!!.x)
  ),
  
  tar_file_read(
    temp_hood_raw,
    file.path("large/temperature", "LST_neighbourhoods.csv"),
    read.csv(!!.x)
  ),
  
  tar_file_read(
    temp_street_raw,
    file.path("large/temperature", "LST_streets.csv"),
    read.csv(!!.x)
  ),
  
  tar_target(
    temp_city,
    clean_temp(temp_city_raw, "temp")
  ),
  
  tar_target(
    temp_hood,
    clean_temp(temp_hood_raw, "temp")
  ),
  
  tar_target(
    temp_street,
    clean_temp(temp_street_raw, "temp")
  )
  
)