data_download <- c(
  

  # Neighbourhoods ----------------------------------------------------------
  
  tar_target(
    cal_hood_raw, 
    download_csv("https://data.calgary.ca/api/views/surr-xmvs/rows.csv?accessType=DOWNLOAD", 
                 "large/neighbourhoods/cal_hood_raw.csv")
  ),
  
  tar_target(
    hal_hood_raw, 
    download_shp("https://opendata.arcgis.com/api/v3/datasets/b4088a068b794436bdb4e5c31df76fe2_0/downloads/data?format=shp&spatialRefId=4326",
                 "large/neighbourhoods/hal_hood_raw.zip")  
  ),
  
  tar_target(
    mon_hood_raw, 
    download_shp("https://data.montreal.ca/dataset/00bd85eb-23aa-4669-8f1b-ba9a000e3dd8/resource/62f7ce10-36ce-4bbd-b419-8f0a10d3b280/download/limadmin-shp.zip",
                 "large/neighbourhoods/mon_hood_raw.zip")
  ),
  
  tar_target(
    ott_hood_raw, 
    download_shp("https://opendata.arcgis.com/api/v3/datasets/32fe76b71c5e424fab19fec1f180ec18_0/downloads/data?format=shp&spatialRefId=4326",
                 "large/neighbourhoods/ott_hood_raw.zip")
  ),
  
  tar_target(
    tor_hood_raw,
    download_shp("https://ckan0.cf.opendata.inter.prod-toronto.ca/download_resource/a083c865-6d60-4d1d-b6c6-b0c8a85f9c15?format=shp&projection=4326",
                 "large/neighbourhoods/tor_hood_raw.zip")
  ), 
  
  tar_target(
    van_hood_raw, 
    download_shp("https://opendata.vancouver.ca/explore/dataset/local-area-boundary/download/?format=shp&timezone=Asia/Shanghai&lang=enn",
                 "large/neighbourhoods/van_hood_raw.zip")
  ),
  
  tar_target(
    win_hood_raw,
    download_shp("https://data.winnipeg.ca/api/geospatial/fen6-iygi?method=export&format=Shapefile",
                 "large/neighbourhoods/win_hood_raw.zip")
  ),


  # Parks -------------------------------------------------------------------
  
  tar_target(
    cal_park_raw,
    download_csv("https://data.calgary.ca/api/views/kami-qbfh/rows.csv?accessType=DOWNLOAD",
               "large/parks/cal_park_raw.csv")
  ),
  
  tar_target(
    hal_park_raw, 
    download_shp("https://opendata.arcgis.com/api/v3/datasets/3df29a3d088a42d890f11d027ea1c0be_0/downloads/data?format=shp&spatialRefId=4326",
               "large/parks/hal_park_raw.zip")
  ),
  
  tar_target(
    mon_park_raw, 
    download_shp("https://data.montreal.ca/dataset/2e9e4d2f-173a-4c3d-a5e3-565d79baa27d/resource/c57baaf4-0fa8-4aa4-9358-61eb7457b650/download/shapefile.zip",
               "large/parks/mon_park_raw.zip")
  ),
  
  tar_target(
    ott_park_raw, 
    download_shp("https://opendata.arcgis.com/api/v3/datasets/cfb079e407494c33b038e86c7e05288e_24/downloads/data?format=shp&spatialRefId=4326",
               "large/parks/ott_park_raw.zip")
  ),
  
  tar_target(
    tor_park_raw, 
    download_shp("https://ckan0.cf.opendata.inter.prod-toronto.ca/download_resource/198b6d28-c7f1-4770-8ad4-69534b9cdd82",
               "large/parks/tor_park_raw.zip")
  ),
  
  tar_target(
    van_park_raw, 
    download_shp("https://opendata.vancouver.ca/explore/dataset/parks-polygon-representation/download/?format=shp&timezone=Asia/Shanghai&lang=en",
               "large/parks/van_park_raw.zip")
  ),
  
  tar_target(
    win_park_raw, 
    download_shp("https://data.winnipeg.ca/api/geospatial/tug6-p73s?method=export&format=Shapefile",
               "large/parks/win_park_raw.zip")
  ),
  
  
  # Trees -------------------------------------------------------------------
  
  tar_target(
    cal_tree_raw, 
    download_csv("https://data.calgary.ca/api/views/tfs4-3wwa/rows.csv?accessType=DOWNLOAD",
                 "large/trees/cal_tree_raw.csv")
  ),
  
  tar_target(
    hal_tree_raw,
    download_csv("https://opendata.arcgis.com/api/v3/datasets/33a4e9b6c7e9439abcd2b20ac50c5a4d_0/downloads/data?format=csv&spatialRefId=4326",
                 "large/trees/hal_tree_raw.csv")
  ),
  
  tar_target(
    mon_tree_raw,
    download_csv("https://data.montreal.ca/dataset/b89fd27d-4b49-461b-8e54-fa2b34a628c4/resource/64e28fe6-ef37-437a-972d-d1d3f1f7d891/download/arbres-publics.csv",
                 "large/trees/mon_tree_raw.csv")
  ),
  
  tar_target(
    ott_tree_raw,
    download_csv("https://opendata.arcgis.com/api/v3/datasets/13092822f69143b695bdb916357d421b_0/downloads/data?format=csv&spatialRefId=4326",
                 "large/trees/ott_tree_raw.csv")
  ), 
  
  tar_target(
    tor_tree_raw, 
    download_csv("https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/6ac4569e-fd37-4cbc-ac63-db3624c5f6a2/resource/5930412c-408e-4ee3-b473-56a790c9dfb7/download/Alternate%20File_Street%20Tree%20Data_WGS84.csv.csv",
                 "large/trees/tor_tree_raw.csv")
  ), 
  
  tar_target(
    van_tree_raw, 
    download_csv("https://opendata.vancouver.ca/explore/dataset/street-trees/download/?format=csv&timezone=America/New_York&lang=en&use_labels_for_header=true&csv_separator=%3B",
                 "large/trees/van_tree_raw.csv") # uses ; as separator
  ),
  
  tar_target(
    win_tree_raw,
    download_csv("https://data.winnipeg.ca/api/views/h923-dxid/rows.csv?accessType=DOWNLOAD",
                 "large/trees/win_tree_raw.csv")
  ),
  

  # National ----------------------------------------------------------------

  tar_target(
    mun_bound_raw,
    download_shp("https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lcma000b16a_e.zip",
                 "large/national/can_bound_raw.zip")
  ),
  
  tar_target(
    road_raw,
    download_shp("https://www12.statcan.gc.ca/census-recensement/2011/geo/RNF-FRR/files-fichiers/lrnf000r20a_e.zip",
                 "large/national/can_road_raw.zip")
  ),
  
  tar_target(
    DA_raw,
    download_shp("https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lda_000b16a_e.zip",
                 "large/national/dsa_bound_raw.zip")
  ),
  
  tar_target(
    census_raw,
    download_csv("https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/prof/details/download-telecharger/comp/GetFile.cfm?Lang=E&FILETYPE=CSV&GEONO=044",
                 "large/national/can_cen_raw.zip")
  ),
  
  tar_target(
    mun_list,
    c("Alberta", "NovaScotia", "Quebec", "Ontario", "BritishColumbia", "Manitoba")
  ),
  
  tar_target(
    build_raw,
    for (i in 1:length(mun_list)){
      build_url <- paste0("https://usbuildingdata.blob.core.windows.net/canadian-buildings-v2/", municipality, ".zip")
      build_dest <- paste0("large/national/", municipality, "_building_density.zip")
      build_output <- paste0("large/national/", municipality, "_building_density")
      download.file(build_url[i], build_dest[i], mode="wb")
    }
  ),

  
  # Supplementary Files -----------------------------------------------------
  
  tar_file_read(
    hal_tree_spcode,
    hal_tree_spcode_path,
    read.csv(!!.x)
  ),
  
  tar_file_read(
    hal_tree_dbhcode,
    hal_tree_dbhcode_path,
    read.csv(!!.x, row.names = NULL)
  ),
  
  tar_file_read(
    mon_tree_hoodcode,
    mon_tree_hoodcode_path,
    read.csv(!!.x, row.names = NULL)
  ),
  
  tar_file_read(
    tor_tree_spcode,
    tor_tree_spcode_path,
    read.csv(!!.x)
  ),
  
  tar_file_read(
    ott_tree_spcode,
    ott_tree_spcode_path, 
    read.csv(!!.x)
  )

)