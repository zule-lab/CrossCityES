targets_prepare_datasets <- c(
  
  tar_target(
    city_data, 
    temp_city %>%
      inner_join(., pollution_city, by = "city") %>%
      inner_join(., treesize_city, by = "city") %>% 
      inner_join(., treedensity_city, by = "city") %>%
      inner_join(., can_build_city_dens, by = "city") %>%
      inner_join(., ndi_city, by = "city") %>%
      inner_join(., city_height, by = "city") %>%
      inner_join(., city_road_prop, by = "city") %>%
      inner_join(., census_cma, by = "city") %>% 
      select(-c(geometry.x, geometry.x.x, geometry.y, geometry.y.y, mean_ba.y, CMANAME)) %>%
      rename(mean_ba = mean_ba.x,
             mean_buildhgt = mean, 
             median_buildhgt = median, 
             sd_buildhgt = sd)
  ),
  
  tar_target(
    neighbourhood_data, 
    temp_hood %>%
      inner_join(., pollution_hood, by = "hood_id") %>%
      inner_join(., treesize_hood, by = "hood_id") %>% 
      inner_join(., treedensity_hood, by = "hood_id") %>%
      inner_join(., can_build_hood_dens, by = "hood_id") %>%
      inner_join(., ndi_hood, by = "hood_id") %>%
      inner_join(., hood_height, by = "hood_id") %>%
      inner_join(., hood_road_prop, by = "hood_id") %>%
      left_join(., hood_cen, by = "hood_id") %>%
      select(-c(geometry, geometry.x, geometry.x.x, geometry.y, geometry.y.y, city.y, hood.y, hood_area.y, mean_ba.y,
                city, city.x.x, hood.x.x, hood_area.x.x, city.y.y, hood.y.y, hood_area.y.y,
                city.x.x.x, hood.x.x.x,city.y.y.y, hood.y.y.y, city.x.x.x.x, city.y.y.y.y,)) %>%
      rename(city = city.x,
             hood = hood.x, 
             hood_area = hood_area.x,
             mean_ba = mean_ba.x,
             mean_buildhgt = mean, 
             median_buildhgt = median,
             sd_buildhgt = sd)
  ),
  
  tar_target(
    city_response_vars, 
    city_data %>%
      select(c(city, max_temp, mean_temp, median_temp, min_temp, stdDev_temp, max_CO, mean_CO, median_CO, min_CO, stdDev_CO,
               max_NO2, mean_NO2, median_NO2, min_NO2, stdDev_NO2,max_O3, mean_O3, median_O3, min_O3, stdDev_O3,
               max_SO2, mean_SO2, median_SO2, min_SO2, stdDev_SO2, max_UV, mean_UV, median_UV, min_UV, stdDev_UV))
  ),
  
  tar_target(
    city_tree_vars,
    city_data %>%
      select(c(city, mean_ba, sd_ba, mean_dbh, sd_dbh, stemdens, basaldens))
  ),
  
  tar_target(
    city_build_vars,
    city_data %>%
      select(c(city, centroid_den, area_den, NDBI_max, NDBI_mean, NDBI_median, NDBI_min, NDBI_stdDev,
               NDVI_max, NDVI_mean, NDVI_median, NDVI_min, NDVI_stdDev, mean_buildhgt, median_buildhgt, sd_buildhgt,
               PropHighway, PropMajRoads, PropStreets, RoadDens))
  ),
  
  tar_target(
    city_census_vars, 
    city_data %>% 
      select(c(city, totpop, popdens, sidehop, semhoup, rowhoup, aptdupp, aptbuip, aptfivp, otsihop, mvdwelp, medinc, lowinc,
               aborigp, recimmp, visminp))
  ),
  
  tar_target(
    neighbourhood_response_vars, 
    neighbourhood_data %>%
      select(c(city, hood, hood_id, max_temp, mean_temp, median_temp, min_temp, stdDev_temp,  max_CO, mean_CO, median_CO, min_CO, stdDev_CO,
               max_NO2, mean_NO2, median_NO2, min_NO2, stdDev_NO2, max_O3, mean_O3, median_O3, min_O3, stdDev_O3,
               max_SO2, mean_SO2, median_SO2, min_SO2, stdDev_SO2, max_UV, mean_UV, median_UV, min_UV, stdDev_UV))
  ),
  
  tar_target(
    neighbourhood_tree_vars,
    neighbourhood_data %>%
      select(c(city, hood, hood_id, mean_ba, sd_ba, mean_dbh, sd_dbh, stemdens, basaldens))
  ),
  
  tar_target(
    neighbourhood_build_vars,
    neighbourhood_data %>%
      select(c(city, hood, hood_id, centroid_den, area_den, NDBI_max, NDBI_mean, NDBI_median, NDBI_min, NDBI_stdDev,
               NDVI_max, NDVI_mean, NDVI_median, NDVI_min, NDVI_stdDev, mean_buildhgt, median_buildhgt, sd_buildhgt,
               PropHighway, PropMajRoads, PropStreets, RoadDens))
  ),
  
  tar_target(
    neighbourhood_census_vars, 
    neighbourhood_data %>% 
      select(c(city, hood, hood_id, totpop, popdens, sidehop, semhoup, rowhoup, aptdupp, aptbuip, aptfivp, otsihop, mvdwelp, medinc, lowinc,
               aborigp, recimmp, visminp))
  )
  
)