plot_pdp <- function(final_model, name, df_train){
  
  
  model_explainer <- explain_tidymodels(
    final_model[[1]],
    data = df_train,
    y = as.integer(df_train$value),
    verbose = FALSE
  )
  
  
  vip <- final_model[[1]] %>%
    extract_fit_parsnip() %>%
    vip(geom = "point") +
    theme_classic()
  
  vars <- vip[["data"]]$Variable
  
  
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
    #geom_point(data = df_train, aes(x = stemdens, y = mean_temp, colour = city)) + 
    geom_line(linewidth = 1.2, alpha = 0.9) +
    labs(
      title = "10 Most Important Variables at City Scale",
      y = "Predicted mean temp",
      colour = "",
      x = ""
    ) + 
    facet_wrap(`_vname_` ~ ., scales = "free") + 
    theme_classic()
  
  ggsave(paste0('graphics/', name, '_pdp.png'), pdp)
  
  return(pdp)
  
  
}
