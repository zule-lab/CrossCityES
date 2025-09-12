targets_figures <- c(
  
  tar_target(
    study_map,
    create_study_map(mun_bound_clean, da_bound_clean, mun_road_clean, can_hood, can_trees,
                     mun_bound_trees, neighbourhood_bound_trees, road_bound_trees)
    
  ),
  
  tar_render(
    supplementary,
    'output/raw-data-report.qmd'
  ),
  
  tar_render(
    model_report,
    'output/random-forest-results.qmd'
  )
  
  
)