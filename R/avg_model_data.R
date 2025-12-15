avg_model_data <- function(model_data, roads_lst_full){
  
  neighbourhoods <- model_data %>% 
    keep(str_detect(names(model_data), 'neighbourhoods')) %>% 
    map(\(x) x %>% group_by(city_hood) %>% summarize(value = mean(value),
                                                NDBI_mean_ = mean(NDBI_mean_),
                                                NDVI_mean_ = mean(NDVI_mean_),
                                                city = first(city),
                                                ba_per_m2 = first(ba_per_m2), 
                                                hoodarea = first(hoodarea), 
                                                stemdens = first(stemdens), 
                                                SpeciesRichness = first(SpeciesRichness), 
                                                Shannon = first(Shannon), 
                                                FG_richness = first(FG_richness),
                                                FG_shannon = first(FG_shannon), 
                                                mean_dbh = first(mean_dbh), 
                                                sd_dbh = first(sd_dbh), 
                                                centroid_den = first(centroid_den), 
                                                area_den = first(area_den),
                                                prop_highway = first(prop_highway), 
                                                road_dens = first(road_dens),
                                                popdens = first(popdens), 
                                                sidehop = first(sidehop), 
                                                aptfivep = first(aptfivp), 
                                                semhoup = first(semhoup), 
                                                rowhoup = first(rowhoup), 
                                                aptdupp = first(aptdupp), 
                                                aptbuip = first(aptbuip), 
                                                mvdwelp = first(mvdwelp), 
                                                medinc = first(medinc), 
                                                recimmp = first(recimmp), 
                                                indigp = first(indigp), 
                                                visminp = first(visminp), 
                                                popwithin = first(popwithin),
                                                edubacp = first(edubacp), 
                                                lowincp = first(lowincp), 
                                                mean_bldhgt = first(mean_bldhgt), 
                                                stdDev_bldhgt = first(stdDev_bldhgt), 
                                                lon = first(lon),
                                                lat = first(lat)))
  
  
  
  streets <- list(roads_lst_full %>% 
    rename(value = mean_temp) %>% 
    select(-c(streetdir, streettype)) %>%
    group_by(streetid) %>% 
    summarize(value = mean(value),
              NDBI_mean_ = mean(NDBI_mean_),
              NDVI_mean_ = mean(NDVI_mean_),
              city = first(city),
              road_class = first(road_class),
              ba_per_m2 = first(ba_per_m2),
              stemdens = first(stemdens), 
              SpeciesRichness = first(SpeciesRichness), 
              Shannon = first(Shannon), 
              FG_richness = first(FG_richness),
              FG_shannon = first(FG_shannon), 
              mean_dbh = first(mean_dbh), 
              sd_dbh = first(sd_dbh), 
              centroid_den = first(centroid_den), 
              area_den = first(area_den),
              popdens = first(popdens), 
              sidehop = first(sidehop), 
              aptfivep = first(aptfivp), 
              semhoup = first(semhoup), 
              rowhoup = first(rowhoup), 
              aptdupp = first(aptdupp), 
              aptbuip = first(aptbuip), 
              mvdwelp = first(mvdwelp), 
              medinc = first(medinc), 
              recimmp = first(recimmp), 
              indigp = first(indigp), 
              visminp = first(visminp), 
              edubacp = first(edubacp), 
              popwithin = first(popwithin),
              lowincp = first(lowincp), 
              mean_bldhgt = first(mean_bldhgt), 
              stdDev_bldhgt = first(stdDev_bldhgt), 
              lon = first(lon),
              lat = first(lat))) %>% 
    group_by(city) %>% 
    sample_n(1000) %>%
  
  list <-c(neighbourhoods, streets) %>% 
    setNames(., c('neighbourhoods_temp', 'neighbourhoods_UV', 'neighbourhoods_CO', 'neighbourhoods_NO2', 'neighbourhoods_O3', 'neighbourhoods_SO2',
                  'streets_temp'))
  
  return(list)
  
  
}
