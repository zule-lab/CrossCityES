targets_prepare_data <- c(

# supplementary data files ------------------------------------------------

  # extracted from tree data metadata accessible from 
  # http://hrm.maps.arcgis.com/sharing/rest/content/items/87d562e852a44e64ae268609e2cdc0d2/data
  tar_file_read(
    hal_tree_spcode,
    'input/hal_tree_spcode.csv',
    read.csv(!!.x)
  ),
  
  # 9 categories, matched with dataset viewed in ARCGIS Viewer from 
  # https://www.arcgis.com/home/webmap/viewer.html?panel=gallery&layers=33a4e9b6c7e9439abcd2b20ac50c5a4d
  tar_file_read(
    hal_tree_dbhcode,
    'input/hal_tree_dbhcode.csv',
    read.csv(!!.x, row.names = NULL)
  ),
  
  # 9 categories, matched with dataset viewed in ARCGIS Viewer from 
  # https://www.arcgis.com/home/webmap/viewer.html?panel=gallery&layers=33a4e9b6c7e9439abcd2b20ac50c5a4d
  tar_file_read(
    mon_tree_hoodcode,
    'input/mon_tree_hoodcode.csv',
    read.csv(!!.x, row.names = NULL)
  ),
  
  # Toronto tree species codes (obtained by emailing opendata@toronto.com)
  tar_file_read(
    tor_tree_spcode,
    'input/tor_tree_spcode.csv',
    read.csv(!!.x)
  ),
  
  # Ottawa tree species codes (obtained by emailing City of Ottawa)
  tar_file_read(
    ott_tree_spcode,
    'input/ott_tree_spcode.csv', 
    read.csv(!!.x)
  ),
  
  
# boundaries --------------------------------------------------------------

  
  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      download_file(dl_link, dl_path,  file_ext)
    ),
    values = values_bounds
  ),
  
  # Clean
  tar_target(
    mun_bound_clean,
    can_bound_raw %>%
      group_by(CMANAME) %>%
      summarise() %>%
      mutate(CMANAME = replace(CMANAME, CMANAME == "Ottawa - Gatineau (Ontario part / partie de l'Ontario)", "Ottawa"),
             CMANAME = replace(CMANAME, CMANAME == "Montréal", "Montreal")) %>%
      filter(CMANAME == "Vancouver" |
               CMANAME == "Calgary" |
               CMANAME == "Winnipeg" | 
               CMANAME == "Toronto" |
               CMANAME == "Ottawa" |
               CMANAME == "Montreal" |
               CMANAME == "Halifax")
  ),
  
  tar_target(
    mun_road_clean,
    clean_roads(mun_bound_clean, can_road_raw)
  ),
  
  tar_target(
    da_bound_clean,
    clean_da_bound(dsa_bound_raw, mun_bound_clean) 
  ),


# buildings ---------------------------------------------------------------

  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      building_sf(dl_link, dl_path, file_ext, mun_bound_trees)
    ),
    values = values_buildings
  ),
  
  # bind
  tar_target(
    can_build,
    rbind(BritishColumbia_Buildings, Alberta_Buildings, Manitoba_Buildings, Ontario_Buildings, Quebec_Buildings, NovaScotia_Buildings)
  ),


# census ------------------------------------------------------------------
  
  # Download 
  tar_eval(
    tar_target(
      file_name_sym,
      download_file(dl_link, dl_path, file_ext)
    ),
    values = values_census
  ),
  
  # Clean
  tar_target(
    census_da_clean,
    clean_census_da("large/national/cen_da_raw.zip", 5, "large/national/cen_da_raw", da_bound_clean)
  ),


# ee ----------------------------------------------------------------------

  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      clean_ee(dl_link, dl_path, file_ext)
    ),
    values = values_ee
  ),
  
  # combine pollution for city level
  tar_target(
    cities_pollution,
    bind_cols(cities_CO, 
              cities_NO2 %>% select(-CMANAME), 
              cities_O3 %>% select(-CMANAME),
              cities_SO2 %>% select(-CMANAME),
              cities_UV %>% select(-CMANAME)) %>%
      rename(city = CMANAME)
  ),
  
  # combine pollution for neighbourhood level
  tar_target(
    neighbourhoods_pollution,
    bind_cols(neighbourhoods_CO %>% select(-c('id')),
              neighbourhoods_NO2 %>% select(-c('id', 'city', 'hood', 'hood_area', 'hood_id')),
              neighbourhoods_O3 %>% select(-c('id', 'city', 'hood', 'hood_area', 'hood_id')),
              neighbourhoods_SO2 %>% select(-c('id', 'city', 'hood', 'hood_area', 'hood_id')),
              neighbourhoods_UV %>% select(-c('id', 'city', 'hood', 'hood_area', 'hood_id')))
  ),


# neighbourhoods ----------------------------------------------------------

  # Download
  tar_eval(
    tar_target(
      file_name_sym,
      download_file(dl_link, dl_path, file_ext)
    ),
    values = values_hood
  ),
  
  # Clean
  tar_eval(
    tar_target(
      cleaned_name_sym,
      clean_neighbourhoods(file_name_sym)
    ),
    values = values_hood
  ),
  
  # Combine
  tar_target(
    can_hood,
    rbind(van_hood_clean, cal_hood_clean, win_hood_clean,
          tor_hood_clean, ott_hood_clean, mon_hood_clean, hal_hood_clean)
  ),

# trees -------------------------------------------------------------------

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
  tar_eval(
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
  
  # Combine and clean species names
  tar_target(
    can_trees,
    assign_sp_all(van_tree_clean, cal_tree_clean, win_tree_clean, tor_tree_clean, ott_tree_clean, mon_tree_clean, hal_tree_clean)
  ),


# scales ------------------------------------------------------------------

  # select DAs that intersect with tree data and then merge to create the "city" boundaries
  tar_target(
    mun_bound_trees,
    trees_mun_bounds(da_bound_clean, can_trees, mun_bound_clean)
  ),
  
  # subset neighbourhoods to ones that intersect with tree data
  tar_target(
    neighbourhood_bound_trees,
    trees_neighbourhood_bounds(can_hood, can_trees)
  ),
  
  # create 25 m buffer surrounding roads and select roads that intersect with tree data
  tar_target(
    road_bound_trees,
    trees_roads_bounds(mun_road_clean, can_trees)
  )




# full datasets -----------------------------------------------------------

#  tar_target(
#    city_data, 
#    temp_city %>%
#      inner_join(., pollution_city, by = "city") %>%
#      inner_join(., treesize_city, by = "city") %>% 
#      inner_join(., treedensity_city, by = "city") %>%
#      inner_join(., can_build_city_dens, by = "city") %>%
#      inner_join(., ndi_city, by = "city") %>%
#      inner_join(., city_height, by = "city") %>%
#      inner_join(., city_road_prop, by = "city") %>%
#      inner_join(., census_cma, by = "city") %>% 
#      select(-c(geometry.x, geometry.x.x, geometry.y, geometry.y.y, mean_ba.y, CMANAME)) %>%
#      rename(mean_ba = mean_ba.x,
#             mean_buildhgt = mean, 
#             median_buildhgt = median, 
#             sd_buildhgt = sd)
#  ),
#  
#  tar_target(
#    neighbourhood_data, 
#    temp_hood %>%
#      inner_join(., pollution_hood, by = "hood_id") %>%
#      inner_join(., treesize_hood, by = "hood_id") %>% 
#      inner_join(., treedensity_hood, by = "hood_id") %>%
#      inner_join(., can_build_hood_dens, by = "hood_id") %>%
#      inner_join(., ndi_hood, by = "hood_id") %>%
#      inner_join(., hood_height, by = "hood_id") %>%
#      inner_join(., hood_road_prop, by = "hood_id") %>%
#      left_join(., hood_cen, by = "hood_id") %>%
#      select(-c(geometry, geometry.x, geometry.x.x, geometry.y, geometry.y.y, city.y, hood.y, hood_area.y, mean_ba.y,
#                city, city.x.x, hood.x.x, hood_area.x.x, city.y.y, hood.y.y, hood_area.y.y,
#                city.x.x.x, hood.x.x.x,city.y.y.y, hood.y.y.y, city.x.x.x.x, city.y.y.y.y,)) %>%
#      rename(city = city.x,
#             hood = hood.x, 
#             hood_area = hood_area.x,
#             mean_ba = mean_ba.x,
#             mean_buildhgt = mean, 
#             median_buildhgt = median,
#             sd_buildhgt = sd)
#  ),
#  
#  tar_target(
#    city_response_vars, 
#    city_data %>%
#      select(c(city, max_temp, mean_temp, median_temp, min_temp, stdDev_temp, max_CO, mean_CO, median_CO, min_CO, stdDev_CO,
#               max_NO2, mean_NO2, median_NO2, min_NO2, stdDev_NO2,max_O3, mean_O3, median_O3, min_O3, stdDev_O3,
#               max_SO2, mean_SO2, median_SO2, min_SO2, stdDev_SO2, max_UV, mean_UV, median_UV, min_UV, stdDev_UV))
#  ),
#  
#  tar_target(
#    city_tree_vars,
#    city_data %>%
#      select(c(city, mean_ba, sd_ba, mean_dbh, sd_dbh, stemdens, basaldens))
#  ),
#  
#  tar_target(
#    city_build_vars,
#    city_data %>%
#      select(c(city, centroid_den, area_den, NDBI_max, NDBI_mean, NDBI_median, NDBI_min, NDBI_stdDev,
#               NDVI_max, NDVI_mean, NDVI_median, NDVI_min, NDVI_stdDev, mean_buildhgt, median_buildhgt, sd_buildhgt,
#               PropHighway, PropMajRoads, PropStreets, RoadDens))
#  ),
#  
#  tar_target(
#    city_census_vars, 
#    city_data %>% 
#      select(c(city, totpop, popdens, sidehop, semhoup, rowhoup, aptdupp, aptbuip, aptfivp, otsihop, mvdwelp, medinc, lowinc,
#               aborigp, recimmp, visminp))
#  ),
#  
#  tar_target(
#    neighbourhood_response_vars, 
#    neighbourhood_data %>%
#      select(c(city, hood, hood_id, max_temp, mean_temp, median_temp, min_temp, stdDev_temp,  max_CO, mean_CO, median_CO, min_CO, stdDev_CO,
#               max_NO2, mean_NO2, median_NO2, min_NO2, stdDev_NO2, max_O3, mean_O3, median_O3, min_O3, stdDev_O3,
#               max_SO2, mean_SO2, median_SO2, min_SO2, stdDev_SO2, max_UV, mean_UV, median_UV, min_UV, stdDev_UV))
#  ),
#  
#  tar_target(
#    neighbourhood_tree_vars,
#    neighbourhood_data %>%
#      select(c(city, hood, hood_id, mean_ba, sd_ba, mean_dbh, sd_dbh, stemdens, basaldens))
#  ),
#  
#  tar_target(
#    neighbourhood_build_vars,
#    neighbourhood_data %>%
#      select(c(city, hood, hood_id, centroid_den, area_den, NDBI_max, NDBI_mean, NDBI_median, NDBI_min, NDBI_stdDev,
#               NDVI_max, NDVI_mean, NDVI_median, NDVI_min, NDVI_stdDev, mean_buildhgt, median_buildhgt, sd_buildhgt,
#               PropHighway, PropMajRoads, PropStreets, RoadDens))
#  ),
#  
#  tar_target(
#    neighbourhood_census_vars, 
#    neighbourhood_data %>% 
#      select(c(city, hood, hood_id, totpop, popdens, sidehop, semhoup, rowhoup, aptdupp, aptbuip, aptfivp, otsihop, mvdwelp, medinc, lowinc,
#               aborigp, recimmp, visminp))
#  ),
#
#

    
  
)
