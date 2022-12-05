targets_ndvi_ndbi_cleanup <- c(
  
    tar_file_read(
      ndi_city_raw,
      file.path("large/ndvi_ndbi", "NDVI_NDBI_cities.csv"),
      read.csv(!!.x)
    ),
    
    tar_file_read(
      ndi_hood_raw,
      file.path("large/ndvi_ndbi", "NDVI_NDBI_neighbourhoods.csv"),
      read.csv(!!.x)
    ),
    
    tar_file_read(
      ndi_street_raw,
      file.path("large/ndvi_ndbi", "NDVI_NDBI_streets.csv"),
      read.csv(!!.x)
    ),
    
    tar_target(
      ndi_city,
      clean_sat(ndi_city_raw, "")
    ),
    
    tar_target(
      ndi_hood,
      clean_sat(ndi_hood_raw, "")
    ),
    
    tar_target(
      ndi_street,
      clean_sat(ndi_street_raw, "")
    )
  
)