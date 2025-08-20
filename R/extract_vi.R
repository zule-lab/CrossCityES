extract_vi <- function(final_models){
  
  # Temperature
  
  city_temp <- standard_vi(final_models$cities_temp, 
                           'Temperature',
                           'City') %>% 
    slice_head(n = 4) %>% 
    mutate(Relationship = case_when(Variable == "NDVI_mean_" ~ 'negative',
                                             Variable == "NDBI_mean_" ~ 'positive',
                                             Variable == "recimmp" ~ 'postive',
                                             Variable == "visminp" ~ 'positive')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  nhood_temp <- standard_vi(final_models$neighbourhoods_temp, 
                           'Temperature',
                           'Neighbourhood') %>% 
    slice_head(n = 5) %>% 
    mutate(Relationship = case_when(Variable == "semhoup" ~ 'mixed',
                                    Variable == "rowhoup" ~ 'mixed',
                                    Variable == "edubacp" ~ 'negative',
                                    Variable == "medinc" ~ 'mixed',
                                    Variable == "popwithin" ~ 'mixed')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  
  street_temp <- standard_vi(final_models$streets_temp, 
                            'Temperature',
                            'Street') %>% 
    slice_head(n = 3) %>% 
    mutate(Relationship = case_when(Variable == "FG_shannon" ~ 'mixed',
                                    Variable == "sidehop" ~ 'negative',
                                    Variable == "Shannon" ~ 'negative')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  temp_table <- rbind(city_temp, nhood_temp, street_temp) %>% 
    mutate(Variable_Formatted = case_when(Variable == "NDVI_mean_" ~ 'NDVI',
                                Variable == "NDBI_mean_" ~ 'NDBI',
                                Variable == "recimmp" ~ 'Recent Immigrants (%)',
                                Variable == "visminp" ~ 'Visible Minorities (%)',
                                Variable == "semhoup" ~ 'Semi-Detached Home (%)',
                                Variable == "rowhoup" ~ 'Row-House (%)',
                                Variable == "edubacp" ~ 'Highly Educated (%)',
                                Variable == "medinc" ~ 'Median Income ($)',
                                Variable == "popwithin" ~ 'Population',
                                Variable == "FG_shannon" ~ 'Functional Group Shannon',
                                Variable == "sidehop" ~ 'Single Detached Home (%)',
                                Variable == "Shannon" ~ 'Shannon',
                                .default = Variable),
           Importance = round(Importance, 2))
  write.csv(temp_table, 'output/temperature_variable-importance.csv')
  
  
  # Air Pollution
  
  city_co <- standard_vi(final_models$cities_CO, 
                           'Carbon Monoxide',
                           'City') %>% 
    slice_head(n = 1) %>% 
    mutate(Relationship = case_when(Variable == "doy" ~ 'positive')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  nhood_co <- standard_vi(final_models$neighbourhoods_CO, 
                         'Carbon Monoxide',
                         'Neighbourhood') %>% 
    slice_head(n = 1) %>% 
    mutate(Relationship = case_when(Variable == "doy" ~ '')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  
  city_no2 <- standard_vi(final_models$cities_NO2, 
                         'Nitrogen Dioxide',
                         'City') %>% 
    slice_head(n = 4) %>% 
    mutate(Relationship = case_when(Variable == "mvdwelp" ~ "negative",
                                    Variable == "sidehop" ~ "negative",
                                    Variable == "indigp" ~ "negative",
                                    Variable == "doy" ~ 'mixed')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  nhood_no2 <- standard_vi(final_models$neighbourhoods_NO2, 
                          'Nitrogen Dioxide',
                          'Neighbourhood') %>% 
    slice_head(n = 2) %>% 
    mutate(Relationship = case_when(Variable == "lat" ~ "",
                                    Variable == "doy" ~ '')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  city_o3 <- standard_vi(final_models$cities_O3, 
                          'Ozone',
                          'City') %>% 
    slice_head(n = 1) %>% 
    mutate(Relationship = case_when(Variable == "doy" ~ 'negative')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  nhood_o3 <- standard_vi(final_models$neighbourhoods_O3, 
                           'Ozone',
                           'Neighbourhood') %>% 
    slice_head(n = 6) %>% 
    mutate(Relationship = case_when(Variable == "ba_per_m2" ~ '',
                                    Variable == "hoodarea" ~ '',
                                    Variable == "stemdens" ~ '',
                                    Variable == "sd_dbh" ~ '',
                                    Variable == "Shannon" ~ '',
                                    Variable == "mean_dbh" ~ '')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  city_so2 <- standard_vi(final_models$cities_SO2, 
                         'Sulfur Dioxide',
                         'City') %>% 
    slice_head(n = 5) %>% 
    mutate(Relationship = case_when(Variable == "aptdupp" ~ '',
                                    Variable == "lat" ~ '',
                                    Variable == "prop_highway" ~ '',
                                    Variable == "mean_bldhgt" ~ '',
                                    Variable == "mvdwelp" ~ '')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  nhood_so2 <- standard_vi(final_models$neighbourhoods_SO2, 
                          'Sulfur Dioxide',
                          'Neighbourhood') %>% 
    slice_head(n = 1) %>% 
    mutate(Relationship = case_when(Variable == "stemdens" ~ '')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  
  city_uv <- standard_vi(final_models$cities_UV, 
                         'UV Aerosols',
                         'City') %>% 
    slice_head(n = 1) %>% 
    mutate(Relationship = case_when(Variable == "doy" ~ 'positive')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
  
  nhood_uv <- standard_vi(final_models$neighbourhoods_UV, 
                          'UV Aerosols',
                          'Neighbourhood') %>% 
    slice_head(n = 1) %>% 
    mutate(Relationship = case_when(Variable == "doy" ~ '')) %>% 
    select(c(Model, Scale, Variable, Importance, Relationship))
 
  
  pollution_table <- rbind(city_co, nhood_co, city_no2, nhood_no2,
                           city_o3, nhood_o3, city_so2, nhood_so2, city_uv, nhood_uv) %>% 
    mutate(Variable_Formatted = case_when(Variable == "mvdwelp" ~ "Moving Dwellings (%)",
                                Variable == "sidehop" ~ "Single Detached Homes (%)",
                                Variable == "indigp" ~ "Indigenous People (%)",
                                Variable == "doy" ~ 'Day of Year',
                                Variable == "lat" ~ 'Latitude',
                                Variable == "ba_per_m2" ~ 'Tree Basal Area (m2/m2)',
                                Variable == "hoodarea" ~ 'Neighbourhood Area (m2)',
                                Variable == "stemdens" ~ 'Tree Stem Density (stems/m2)',
                                Variable == "sd_dbh" ~ 'Standard Deviation DBH (cm)',
                                Variable == "Shannon" ~ 'Shannon',
                                Variable == "mean_dbh" ~ 'Mean DBH (cm)',
                                Variable == "aptdupp" ~ 'Duplex Apartments (%)',
                                Variable == "prop_highway" ~ 'Proportion Highway',
                                Variable == "mean_bldhgt" ~ 'Mean Building Height (m)',
                                .default = Variable),
           Importance = round(Importance, 2))
  write.csv(pollution_table, 'output/pollution_variable-importance.csv')
  
  final <- rbind(temp_table, pollution_table)
  
  
   
}

standard_vi <- function(model, model_name, scale){
  
  vi_table <- model %>% 
    extract_fit_parsnip() %>% 
    vi() %>%
    mutate(Model = model_name,
           Scale = scale)
  
}
