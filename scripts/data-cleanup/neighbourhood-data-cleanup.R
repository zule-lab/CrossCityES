targets_neighbourhood_cleanup <- c(
  
  tar_eval(
    tar_target(
      lapply(paste0('clean_', as.character(values_trib$file_name)), as.symbol),
      cleaned_neighbourhoods()
    ),
    values = filter(values_trib, grepl('hood_raw', file_name))
  )
  
#  
#  tar_target(
#    can_hood,
#    rbind(cal_hood, hal_hood, mon_hood, ott_hood, tor_hood, van_hood, win_hood)
#  ),
#  
#  tar_target(
#    can_hood_ee,
#    can_hood %>%
#      sf_as_ee(x = .,
#             overwrite = TRUE,
#             assetId = sprintf("%s/%s", ee_get_assethome(), 'mun_road'),
#             bucket = 'rgee_dev',
#             monitoring = FALSE,
#             via = 'gcs_to_asset')
#  )

)