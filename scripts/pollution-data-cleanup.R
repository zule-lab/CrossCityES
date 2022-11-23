pollution_data_cleanup <- c(
  
  tar_file_read(
    CO_city_raw,
    file.path("large/pollution", "CO_city.csv"),
    fread(!!.x)
  ),
  
  tar_file_read(
    CO_hood_raw,
    file.path("large/pollution", "CO_neighbourhood.csv"),
    fread(!!.x)
  ),
  
  tar_file_read(
    NO2_city_raw,
    file.path("large/pollution", "NO2_city.csv"),
    fread(!!.x)
  ),
  
  tar_file_read(
    NO2_hood_raw,
    file.path("large/pollution", "NO2_neighbourhood.csv"),
    fread(!!.x)
  ),
  
  tar_file_read(
    O3_city_raw,
    file.path("large/pollution", "O3_city.csv"),
    fread(!!.x)
  ),
  
  tar_file_read(
    O3_hood_raw,
    file.path("large/pollution", "O3_neighbourhood.csv"),
    fread(!!.x)
  ),
  
#  tar_file_read(
#    O3trop_city_raw,
#    file.path("large/pollution", "O3trop_city.csv"),
#    fread(!!.x)
#  ),
#  
#  tar_file_read(
#    O3trop_hood_raw,
#    file.path("large/pollution", "O3trop_neighbourhood.csv"),
#    fread(!!.x)
#  ),
 
  tar_file_read(
    SO2_city_raw,
    file.path("large/pollution", "SO2_city.csv"),
    fread(!!.x)
  ),
  
  tar_file_read(
    SO2_hood_raw,
    file.path("large/pollution", "SO2_neighbourhood.csv"),
    fread(!!.x)
  ),
  
  tar_file_read(
    UV_city_raw,
    file.path("large/pollution", "UV_city.csv"),
    fread(!!.x)
  ),
  
  tar_file_read(
    UV_hood_raw,
    file.path("large/pollution", "UV_neighbourhood.csv"),
    fread(!!.x)
  ),

  tar_target(
    CO_city,
    clean_sat(CO_city_raw, "CO")
  ),

  tar_target(
    CO_hood,
    clean_sat(CO_hood_raw, "CO")
  ),

  tar_target(
    NO2_city,
    clean_sat(NO2_city_raw, "NO2")
  ),
  
  tar_target(
    NO2_hood,
    clean_sat(NO2_hood_raw, "NO2")
  ),

  tar_target(
    O3_city,
    clean_sat(O3_city_raw, "O3")
  ),
  
  tar_target(
    O3_hood,
    clean_sat(O3_hood_raw, "O3")
  ),

  tar_target(
    SO2_city,
    clean_sat(SO2_city_raw, "SO2")
  ),
  
  tar_target(
    SO2_hood,
    clean_sat(SO2_hood_raw, "SO2")
  ),

  tar_target(
    UV_city,
    clean_sat(UV_city_raw, "UV")
  ),
  
  tar_target(
    UV_hood,
    clean_sat(UV_hood_raw, "UV")
  )
)