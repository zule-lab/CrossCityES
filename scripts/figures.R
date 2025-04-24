targets_figures <- c(
  
  tar_target(
    study_map,
    create_study_map()
    
  ),
  
  tar_render(
    supplementary,
    'output/raw-data-report.qmd'
  )
  
  
)