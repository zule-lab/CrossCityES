targets_prepare_boundaries <- c(
  
  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      download_file(dl_link, dl_path,  file_ext)
    ),
    values = values_bounds
  ),
  
  # Clean
  tar_target(
    mun_bound_clean,
    can_bound_raw %>%
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
    clean_roads(mun_bound_clean, can_road_raw)
  ),
  
  tar_target(
    da_bound_clean,
    clean_da_bound(dsa_bound_raw, mun_bound_clean) 
  )
  
  
)
