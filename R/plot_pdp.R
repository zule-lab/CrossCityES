plot_pdp <- function(final_model, name, df_train, vi){

  df_train <- df_train[1]$train  
  
  model_explainer <- explain_tidymodels(
    final_model[[1]],
    data = df_train,
    y = as.integer(df_train$value),
    verbose = FALSE
  )
  
  
  vip <- vi %>% 
    dplyr::mutate(Variable = as.factor(Variable),
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
  
  var_names <- c(
    "mvdwelp" = "Moving Dwellings (%)",
    "sidehop" = "Single Detached Homes (%)",
    "indigp" = "Indigenous People (%)",
    "doy" = 'Day of Year',
    "lat" = 'Latitude',
    "hoodarea" = 'Neighbourhood Area (m2)',
    "stemdens" = 'Tree Stem Density (stems/m2)',
    "Shannon" = 'Shannon',
    "SpeciesRichness" = 'Species Richness',
    "mean_dbh" = 'Mean DBH (cm)',
    "sd_dbh" = "Standard Deviation DBH (cm)",
    "NDVI_mean_" = 'NDVI',
    "NDBI_mean_" = 'NDBI',
    "recimmp" = 'Recent Immigrants (%)',
    "visminp" = 'Visible Minorities (%)',
    "stemdens" = 'Tree Stem Density (stems/m2)',
    "FG_richness" = 'Functional Group Richness',
    "FG_shannon" = 'Functional Group Shannon')
  
  
   pdp_df <- as_tibble(pdp_time$agr_profiles) %>%
     dplyr::mutate(across(`_vname_`, ~factor(., levels=vars)))
     
   idx <- match(pdp_df$`_vname_`, names(var_names))
   pdp_df$vars <- var_names[idx]

   pdp <- pdp_df %>% ggplot(aes(`_x_`, `_yhat_`, color = `_groups_`)) +
     scale_color_met_d(name = 'Demuth') + 
     geom_line(linewidth = 1.2, alpha = 0.9) + 
     facet_wrap(vars ~ ., scales = "free", labeller = labeller(vars = label_wrap_gen(10))) + 
     theme_classic() + 
     theme(strip.text = element_text(size = 12),
           legend.title = element_blank())
  
   ggsave(paste0('graphics/', name, '_pdp.png'), pdp)
   
   
   ale_time <- model_profile(
     model_explainer,
     variables = vars,
     type = 'accumulated',
     groups = "city"
   )
   
   
   
   ale_df <- as_tibble(ale_time$agr_profiles) %>%
     dplyr::mutate(across(`_vname_`, ~factor(., levels=vars)))

   idy <- match(ale_df$`_vname_`, names(var_names))
   ale_df$vars <- var_names[idy]

   ale <- ale_df %>%
     ggplot(aes(`_x_`, `_yhat_`, color = `_groups_`)) +
     scale_color_met_d(name = 'Demuth') + 
     geom_line(linewidth = 1.2, alpha = 0.9) +
     labs(
       y = "Average Prediction",
       colour = "",
       x = ""
     ) + 
     facet_wrap(vars ~ ., scales = "free", labeller = labeller(vars = label_wrap_gen(10))) + 
     theme_classic() + 
     theme(strip.text = element_text(size = 12))
   
   ggsave(paste0('graphics/', name, '_ale.png'), ale)
   
   
   saveRDS(ale, paste0('output/', name, '_ale.rds'))
   saveRDS(pdp, paste0('output/', name, '_pdp.rds'))


   return(list(pdp_time, ale_time))
  
  
}
