targets_prepare_dems <- c(
  
  # Download 
  tar_eval(
    tar_target(
      file_name_sym,
      download_file(dl_link, dl_path,  file_ext)
    ),
    values = values_dems
  )
  
  # Clean

)