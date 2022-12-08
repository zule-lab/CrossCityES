targets_prepare_census <- c(
  
  # Download 
  tar_eval(
    tar_target(
      file_name_sym,
      download_shp(dl_link, dl_path)
    ),
    values = values_census
  ),
  
  # Clean
  tar_target(
    census_da_clean,
    clean_census_da("large/national/cen_da_raw.zip", 5, "large/national/cen_da_raw", da_bound_clean)
  )
  
  # TODO: municipal level census with DAs that intersect with tree data
)