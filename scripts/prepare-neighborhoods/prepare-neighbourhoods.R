targets_prepare_neighborhoods <- c(
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
      clean_name_sym,
      clean_neighbourhoods(file_name_sym)
    ),
    values = values_hood
  ),
  
  # Combine
  # do.call with cleaned_sym
  tar_target(
    can_hood,
    rbind(clean_van_hood, clean_cal_hood, clean_win_hood, clean_tor_hood, clean_ott_hood, clean_hal_hood)
  )#,
  
  # # EE
  # tar_target(
  #   can_hood_ee,
  #   can_hood %>%
  #     sf_as_ee(x = .,
  #              overwrite = TRUE,
  #              assetId = sprintf("%s/%s", ee_get_assethome(), 'mun_road'),
  #              bucket = 'rgee_dev',
  #              monitoring = FALSE,
  #              via = 'gcs_to_asset')
  # )
)