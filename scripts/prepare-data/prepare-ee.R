targets_prepare_ee <- c(
  
  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      clean_ee(dl_link, dl_path, file_ext)
    ),
    values = values_ee
  )
  
  
  
)