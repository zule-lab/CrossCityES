targets_figures <- c(
  
  tar_target(
    study_map,
    create_study_map()
    
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