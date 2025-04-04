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
    rbind(cities_CO %>% pivot_longer(cols = -c(CMANAME, date), names_to = "variable"), 
              cities_NO2 %>% pivot_longer(cols = -c(CMANAME, date), names_to = "variable"), 
              cities_O3 %>% pivot_longer(cols = -c(CMANAME, date), names_to = "variable"),
              cities_SO2 %>% pivot_longer(cols = -c(CMANAME, date), names_to = "variable"),
              cities_UV %>% pivot_longer(cols = -c(CMANAME, date), names_to = "variable")) %>%
      rename(city = CMANAME)
  ),
  
  # combine pollution for neighbourhood level
  tar_target(
    neighbourhoods_pollution,
    rbind(neighbourhoods_CO %>% pivot_longer(cols = -c(city, hood, hood_id, date), names_to = "variable"),
              neighbourhoods_NO2 %>% pivot_longer(cols = -c(city, hood, hood_id, date), names_to = "variable"),
              neighbourhoods_O3 %>% pivot_longer(cols = -c(city, hood, hood_id, date), names_to = "variable"),
              neighbourhoods_SO2 %>% pivot_longer(cols = -c(city, hood, hood_id, date), names_to = "variable"),
              neighbourhoods_UV %>% pivot_longer(cols = -c(city, hood, hood_id, date), names_to = "variable"))
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
  ),



# full datasets -----------------------------------------------------------

  tar_target(
    cities_lst_full, 
    combine_cities_lst(cities_lst, mun_bound_trees, census_city,
                       cities_treedensity, cities_treerichness, cities_treesize, 
                       build_dens_city, cities_roadclass, cities_ndvi_ndbi) 
  ),

tar_target(
  cities_pollution_full, 
  combine_cities_pollution(cities_pollution, mun_bound_trees, census_city,
                           cities_treedensity, cities_treerichness, cities_treesize, 
                           build_dens_city, cities_roadclass, cities_ndvi_ndbi)
  ),

# some tree neighbourhoods not matching 

  tar_target(
    neighbourhoods_lst_full, 
    combine_neighbourhoods_lst(neighbourhoods_lst, neighbourhood_bound_trees, census_neighbourhood,
                               neighbourhood_treedensity, neighbourhood_treerichness, neighbourhood_treesize, 
                               build_dens_neighbourhood, neighbourhood_roadclass, neighbourhoods_ndvi_ndbi)
  ),

  tar_target(
    neighbourhoods_pollution_full, 
    combine_neighbourhoods_pollution(neighbourhoods_pollution, neighbourhood_bound_trees, census_neighbourhood,
                                     neighbourhood_treedensity, neighbourhood_treerichness, neighbourhood_treesize, 
                                     build_dens_neighbourhood, neighbourhood_roadclass, neighbourhoods_ndvi_ndbi)
  )
    
  
)
