# Neighbourhoods ----------------------------------------------------------
values_hood <- tribble(
  ~dl_path, ~dl_link,

  'large/neighbourhoods/van_hood_raw.zip', 'https://opendata.vancouver.ca/explore/dataset/local-area-boundary/download/?format=shp&timezone=Asia/Shanghai&lang=enn',
  'large/neighbourhoods/cal_hood_raw.csv', 'https://data.calgary.ca/api/views/surr-xmvs/rows.csv?accessType=DOWNLOAD',
  'large/neighbourhoods/win_hood_raw.csv', 'https://data.winnipeg.ca/resource/8k6x-xxsy.csv',
  'large/neighbourhoods/tor_hood_raw.zip', 'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/neighbourhoods/resource/34b409a6-68ef-45f7-9cc8-c85153c1af62/download/Neighbourhoods%20-%204326.zip',
  'large/neighbourhoods/ott_hood_raw.zip', 'https://opendata.arcgis.com/api/v3/datasets/32fe76b71c5e424fab19fec1f180ec18_0/downloads/data?format=shp&spatialRefId=4326',
  'large/neighbourhoods/mon_hood_raw.zip', 'https://donnees.montreal.ca/dataset/9797a946-9da8-41ec-8815-f6b276dec7e9/resource/e8bea324-044c-4544-bbd1-2e0d08a24216/download/limites-administratives-agglomeration-nad83.zip',
  'large/neighbourhoods/hal_hood_raw.zip', 'https://opendata.arcgis.com/api/v3/datasets/b4088a068b794436bdb4e5c31df76fe2_0/downloads/data?format=shp&spatialRefId=4326'
) %>% 
  mutate(
    file_name = basename(sans_ext(dl_path)),
    file_name_sym = lapply(file_name, as.symbol),
    file_ext = file_ext(dl_path),
    cleaned_name = gsub('raw', 'clean', file_name),
    cleaned_name_sym = lapply(cleaned_name, as.symbol)
  )




# Parks -------------------------------------------------------------------
values_parks <- tribble(
  ~dl_path, ~dl_link,

  'large/parks/van_park_raw.zip', 'https://opendata.vancouver.ca/explore/dataset/parks-polygon-representation/download/?format=shp&timezone=Asia/Shanghai&lang=en',
  'large/parks/cal_park_raw.csv', 'https://data.calgary.ca/api/views/kami-qbfh/rows.csv?accessType=DOWNLOAD',
  'large/parks/win_park_raw.csv', 'https://data.winnipeg.ca/api/views/tx3d-pfxq/rows.csv?date=20250204&accessType=DOWNLOAD',
  'large/parks/tor_park_raw.zip', 'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/2aac8903-23ff-4072-ab72-b76cac44ad89/resource/9f53c253-a47e-497f-8a07-528f7d7aad90/download/parks-wgs84.zip',
  'large/parks/ott_park_raw.zip', 'https://opendata.arcgis.com/api/v3/datasets/cfb079e407494c33b038e86c7e05288e_24/downloads/data?format=shp&spatialRefId=4326',
  'large/parks/mon_park_raw.zip', 'https://data.montreal.ca/dataset/2e9e4d2f-173a-4c3d-a5e3-565d79baa27d/resource/c57baaf4-0fa8-4aa4-9358-61eb7457b650/download/shapefile.zip',
  'large/parks/hal_park_raw.zip', 'https://opendata.arcgis.com/api/v3/datasets/3df29a3d088a42d890f11d027ea1c0be_0/downloads/data?format=shp&spatialRefId=4326',
) %>% 
  mutate(
    file_name = basename(sans_ext(dl_path)),
    file_name_sym = lapply(file_name, as.symbol),
    file_ext = file_ext(dl_path)
  )



# Trees -------------------------------------------------------------------
values_trees <- tribble(
  ~dl_path, ~dl_link,

  'large/trees/van_tree_raw.csv', 'https://opendata.vancouver.ca/api/explore/v2.1/catalog/datasets/public-trees/exports/csv?lang=en&timezone=America%2FNew_York&use_labels=true&delimiter=%3B',
  'large/trees/cal_tree_raw.csv', 'https://data.calgary.ca/api/views/tfs4-3wwa/rows.csv?accessType=DOWNLOAD',
  'large/trees/win_tree_raw.csv', 'https://data.winnipeg.ca/api/views/h923-dxid/rows.csv?accessType=DOWNLOAD',
  'large/trees/tor_tree_raw.csv', 'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/6ac4569e-fd37-4cbc-ac63-db3624c5f6a2/resource/5930412c-408e-4ee3-b473-56a790c9dfb7/download/Alternate%20File_Street%20Tree%20Data_WGS84.csv.csv',
  'large/trees/ott_tree_raw.csv', 'https://opendata.arcgis.com/api/v3/datasets/13092822f69143b695bdb916357d421b_0/downloads/data?format=csv&spatialRefId=4326',
  'large/trees/mon_tree_raw.csv', 'https://data.montreal.ca/dataset/b89fd27d-4b49-461b-8e54-fa2b34a628c4/resource/64e28fe6-ef37-437a-972d-d1d3f1f7d891/download/arbres-publics.csv',
  'large/trees/hal_tree_raw.csv', 'https://opendata.arcgis.com/api/v3/datasets/33a4e9b6c7e9439abcd2b20ac50c5a4d_0/downloads/data?format=csv&spatialRefId=4326'
) %>% 
  mutate(
    file_name = basename(sans_ext(dl_path)),
    file_name_sym = lapply(file_name, as.symbol),
    file_ext = file_ext(dl_path),
    cleaned_name = gsub('raw', 'clean', file_name),
    cleaned_name_sym = lapply(cleaned_name, as.symbol)
  )



# StatsCan boundaries -----------------------------------------------------
values_bounds <- tribble(
  ~dl_path, ~dl_link,

  'large/national/can_bound_raw.zip', 'https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/files-fichiers/lcma000b21a_e.zip',
  'large/national/can_road_raw.zip', 'https://www12.statcan.gc.ca/census-recensement/2011/geo/RNF-FRR/files-fichiers/lrnf000r24a_e.zip',
  'large/national/dsa_bound_raw.zip', 'https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/files-fichiers/lda_000b21a_e.zip'
) %>% 
  mutate(
    file_name = basename(sans_ext(dl_path)),
    file_name_sym = lapply(file_name, as.symbol),
    file_ext = file_ext(dl_path)
  )



# Buildings ---------------------------------------------------------------
values_buildings <- tribble(
  ~dl_path, ~dl_link,
  
  'large/national/Alberta_Buildings.zip', 'https://minedbuildings.z5.web.core.windows.net/legacy/canadian-buildings-v2/Alberta.zip',
  'large/national/BritishColumbia_Buildings.zip', 'https://minedbuildings.z5.web.core.windows.net/legacy/canadian-buildings-v2/BritishColumbia.zip',
  'large/national/Manitoba_Buildings.zip', 'https://minedbuildings.z5.web.core.windows.net/legacy/canadian-buildings-v2/Manitoba.zip',
  'large/national/NovaScotia_Buildings.zip', 'https://minedbuildings.z5.web.core.windows.net/legacy/canadian-buildings-v2/NovaScotia.zip',
  'large/national/Ontario_Buildings.zip', 'https://minedbuildings.z5.web.core.windows.net/legacy/canadian-buildings-v2/Ontario.zip',
  'large/national/Quebec_Buildings.zip', 'https://minedbuildings.z5.web.core.windows.net/legacy/canadian-buildings-v2/Quebec.zip'
) %>% 
  mutate(
    file_name = basename(sans_ext(dl_path)),
    file_name_sym = lapply(file_name, as.symbol),
    file_ext = file_ext(dl_path)
  )


# Census ------------------------------------------------------------------
values_census <- tribble(
  ~dl_path, ~dl_link,
  'large/national/cen_da_raw.zip', 'https://www12.statcan.gc.ca/census-recensement/2021/dp-pd/prof/details/download-telecharger/comp/GetFile.cfm?Lang=E&FILETYPE=CSV&GEONO=006',
) %>% 
  mutate(
    file_name = basename(sans_ext(dl_path)),
    file_name_sym = lapply(file_name, as.symbol),
    file_ext = file_ext(dl_path)
  )


# Earth Engine ------------------------------------------------------------
values_ee <- tribble(
  ~dl_path, ~dl_link,
  'large/ndvi_ndbi/cities_ndvi_ndbi.csv', 'Data/Cross-City ES Project/SENTINEL_NDVI_NDBI/cities_ndvi.csv',
  'large/ndvi_ndbi/neighbourhoods_ndvi_ndbi.csv', 'Data/Cross-City ES Project/SENTINEL_NDVI_NDBI/neighbourhoods_ndvi.csv',
  'large/ndvi_ndbi/streets_ndvi_ndbi.csv', 'Data/Cross-City ES Project/SENTINEL_NDVI_NDBI/streets_ndvi.csv',
  
  'large/temperature/cities_lst.csv', 'Data/Cross-City ES Project/Landsat_Temperature/cities_lst.csv',
  'large/temperature/neighbourhoods_lst.csv', 'Data/Cross-City ES Project/Landsat_Temperature/neighbourhoods_lst.csv',
  'large/temperature/streets_lst.csv', 'Data/Cross-City ES Project/Landsat_Temperature/streets_lst.csv',
  
  'large/dem/cities_bldhgt.csv', 'Data/Cross-City ES Project/DEM/cities_dem.csv',
  'large/dem/neighbourhoods_bldhgt.csv', 'Data/Cross-City ES Project/DEM/neighbourhoods_dem.csv',
  'large/dem/streets_bldhgt.csv', 'Data/Cross-City ES Project/DEM/streets_dem.csv',
  
  'large/pollution/cities_CO.csv', 'Data/Cross-City ES Project/SENTINEL_Pollution/CO_city.csv',
  'large/pollution/neighbourhoods_CO.csv', 'Data/Cross-City ES Project/SENTINEL_Pollution/CO_neighbourhood.csv',
  'large/pollution/cities_NO2.csv', 'Data/Cross-City ES Project/SENTINEL_Pollution/NO2_city.csv',
  'large/pollution/neighbourhoods_NO2.csv', 'Data/Cross-City ES Project/SENTINEL_Pollution/NO2_neighbourhood.csv',
  'large/pollution/cities_O3.csv', 'Data/Cross-City ES Project/SENTINEL_Pollution/O3_city.csv',
  'large/pollution/neighbourhoods_O3.csv', 'Data/Cross-City ES Project/SENTINEL_Pollution/O3_neighbourhood.csv',
  'large/pollution/cities_SO2.csv', 'Data/Cross-City ES Project/SENTINEL_Pollution/SO2_city.csv',
  'large/pollution/neighbourhoods_SO2.csv', 'Data/Cross-City ES Project/SENTINEL_Pollution/SO2_neighbourhood.csv',
  'large/pollution/cities_UV.csv', 'Data/Cross-City ES Project/SENTINEL_Pollution/UV_city.csv',
  'large/pollution/neighbourhoods_UV.csv', 'Data/Cross-City ES Project/SENTINEL_Pollution/UV_neighbourhood.csv'
  
) %>% 
  mutate(
    file_name = basename(sans_ext(dl_path)),
    file_name_sym = lapply(file_name, as.symbol),
    file_ext = file_ext(dl_path)
  )


# Symbols -----------------------------------------------------------------
symbol_values <- tibble(
  hood_names_raw = values_hood$file_name_sym,
  parks_names_raw = values_parks$file_name_sym,
  tree_names_raw = values_trees$file_name_sym,
  hood_names_clean = values_hood$cleaned_name_sym,
  tree_names_clean = values_trees$cleaned_name_sym)

