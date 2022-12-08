targets_prepare_boundaries <- c(
  
  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      download_shp(dl_link, dl_path)
    ),
    values = values_bounds
  ),
  
  # Clean
  tar_target(
    mun_bound_clean,
    mun_bound_raw %>%
      group_by(CMANAME) %>%
      summarise() %>%
      mutate(CMANAME = replace(CMANAME, CMANAME == "Ottawa - Gatineau (Ontario part / partie de l'Ontario)", "Ottawa"),
             CMANAME = replace(CMANAME, CMANAME == "Montréal", "Montreal")) %>%
      filter(CMANAME == "Vancouver" |
               CMANAME == "Calgary" |
               CMANAME == "Winnipeg" | 
               CMANAME == "Toronto" |
               CMANAME == "Ottawa" |
               CMANAME == "Montreal" |
               CMANAME == "Halifax")
  ),
  
  tar_target(
    mun_road_clean,
    clean_roads(mun_bound, road_raw)
  ),
  
  tar_target(
    da_bound_clean,
    clean_da_bound(dsa_bound_raw, mun_bound_clean) 
  )
  
  
  # EE
  #  tar_target(
  #  mun_bound_ee,
  #  mun_bound %>%
  #    sf_as_ee(x = .,
  #             overwrite = TRUE,
  #             assetId = sprintf("%s/%s", ee_get_assethome(), 'mun_city'),
  #             via = 'getInfo_to_asset')
  #  ),
  #  
  #  tar_target(
  #    mun_road_ee,
  #    mun_road %>%
  #      sf_as_ee(x = .,
  #               overwrite = TRUE,
  #               assetId = sprintf("%s/%s", ee_get_assethome(), 'mun_road'),
  #               bucket = 'rgee_dev',
  #               monitoring = FALSE,
  #               via = 'gcs_to_asset')
  #  )
  
  
)
