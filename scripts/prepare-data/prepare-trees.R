targets_prepare_trees <- c(
  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      download_file(dl_link, dl_path, file_ext)
    ),
    values = values_parks
  ),
  
  tar_eval(
    tar_target(
      file_name_sym,
      download_file(dl_link, dl_path, file_ext)
    ),
    values = values_trees
  ),
  
  # Clean
  tar_sub(
    tar_target(
      tree_names_clean,
      tree_cleaning(
        tree_names_raw,
        parks_names_raw,
        hood_names_clean,
        mun_bound_clean, 
        mun_road_clean)
    ),
    values = symbol_values
  ),
  
  # Combine
  tar_target(
    can_trees,
    rbind(van_tree_clean, cal_tree_clean, win_tree_clean,
          tor_tree_clean, ott_tree_clean, hal_tree_clean)
  )
)
