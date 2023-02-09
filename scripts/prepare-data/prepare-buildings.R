targets_prepare_buildings <- c(
  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      building_sf(dl_link, dl_path, file_ext)
    ),
    values = values_buildings
  ),
  
  tar_target(
    can_build,
    rbind(cal_build, hal_build, mon_build, ott_build, tor_build, van_build, win_build)
  )
  
)