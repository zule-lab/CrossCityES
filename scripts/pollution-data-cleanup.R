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
  )
)