targets_prepare_neighbourhoods <- c(
  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      download_file(dl_link, dl_path, file_ext)
    ),
    values = values_hood
  ),
  
  # Clean
  tar_eval(
    tar_target(
      cleaned_name_sym,
      clean_neighbourhoods(file_name_sym)
    ),
    values = values_hood
  ),
  
  # Combine
  tar_target(
    can_hood,
    rbind(van_hood_clean, cal_hood_clean, win_hood_clean,
          tor_hood_clean, ott_hood_clean, hal_hood_clean)
  )
  
#  # EE
#  tar_target(
#    can_hood_ee,
#    can_hood %>%
#      sf_as_ee(x = .,
#               overwrite = TRUE,
#               assetId = sprintf("%s/%s", ee_get_assethome(), 'mun_road'),
#               bucket = 'rgee_dev',
#               monitoring = FALSE,
#               via = 'gcs_to_asset')
#  )
)