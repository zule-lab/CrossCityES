targets_prepare_buildings <- c(
  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      building_sf(dl_link, dl_path, file_ext, mun_bound_trees)
    ),
    values = values_buildings
  ),
  
  # bind
  tar_target(
    can_build,
    rbind(BritishColumbia_Buildings, Alberta_Buildings, Manitoba_Buildings, Ontario_Buildings, Quebec_Buildings, NovaScotia_Buildings)
  )
  
)