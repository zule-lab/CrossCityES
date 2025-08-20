plot_pdp <- function(final_model, name, df_train, vi){

  df_train <- df_train[1]$train  
  
  model_explainer <- explain_tidymodels(
    final_model[[1]],
    data = df_train,
    y = as.integer(df_train$value),
    verbose = FALSE
  )
  
  
  vip <- vi %>% 
    mutate(Variable = as.factor(Variable),
           model_name = paste0(Scale, '_', Model),
           model_name = str_replace_all(model_name, c('City' = 'cities',
                                                      'Neighbourhood' = 'neighbourhoods',
                                                      'Street' = 'streets',
                                                      'Temperature' = 'temp',
                                                      'Carbon Monoxide' = 'CO',
                                                      'Nitrogen Dioxide' = 'NO2',
                                                      'Ozone' = 'O3',
                                                      'UV Aerosols' = 'UV',
                                                      'Sulfur Dioxide' = 'SO2'))) %>%
    filter(model_name == name) %>% 
    droplevels()
  
  vars <- levels(as.factor(vip$Variable))
  
  
  pdp_time <- model_profile(
     model_explainer,
     variables = vars,
     N = NULL,
     groups = "city"
   )
  
  
   pdp <- as_tibble(pdp_time$agr_profiles) %>%
     mutate(across(`_vname_`, ~factor(., levels=vars))) %>%
     ggplot(aes(`_x_`, `_yhat_`, color = `_groups_`)) +
     scale_color_met_d(name = 'Demuth') + 
     geom_line(linewidth = 1.2, alpha = 0.9) + 
     facet_wrap(`_vname_` ~ ., scales = "free") + 
     theme_classic()
  
   ggsave(paste0('graphics/', name, '_pdp.png'), pdp)
 
   saveRDS(pdp, paste0('output/', name, '_pdp.rds'))


   return(pdp)
  
  
}
