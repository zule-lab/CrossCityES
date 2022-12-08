targets_neighbourhood_cleanup <- c(
  
  tar_eval(
    tar_target(
      as.symbol(paste0('clean_', substr(file_name, 1, 8))),
      clean_neighbourhoods(tar_load(file_name))
    ),
    values = filter(values_trib, grepl('hood_raw', file_name))
  ),
  
  tar_target(
    can_hood,
    rbind(clean_van_hood, clean_cal_hood, clean_win_hood, clean_tor_hood, clean_ott_hood, clean_hal_hood)
  ),
  
  tar_target(
    can_hood_ee,
    can_hood %>%
      sf_as_ee(x = .,
               overwrite = TRUE,
               assetId = sprintf("%s/%s", ee_get_assethome(), 'mun_road'),
               bucket = 'rgee_dev',
               monitoring = FALSE,
               via = 'gcs_to_asset')
  )
)