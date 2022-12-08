values_hood <- tribble(
  
  # columns
  ~dl_path, ~dl_link,
  
  
  # neighbourhoods ----------------------------------------------------------
  'large/neighbourhoods/van_hood_raw.zip', 'https://opendata.vancouver.ca/explore/dataset/local-area-boundary/download/?format=shp&timezone=Asia/Shanghai&lang=enn',
  'large/neighbourhoods/cal_hood_raw.csv', 'https://data.calgary.ca/api/views/surr-xmvs/rows.csv?accessType=DOWNLOAD',
  'large/neighbourhoods/win_hood_raw.zip', 'https://data.winnipeg.ca/api/geospatial/fen6-iygi?method=export&format=Shapefile',
  'large/neighbourhoods/tor_hood_raw.zip', 'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/neighbourhoods/resource/34b409a6-68ef-45f7-9cc8-c85153c1af62/download/Neighbourhoods%20-%204326.zip',
  'large/neighbourhoods/ott_hood_raw.zip', 'https://opendata.arcgis.com/api/v3/datasets/32fe76b71c5e424fab19fec1f180ec18_0/downloads/data?format=shp&spatialRefId=4326',
  'large/neighbourhoods/mon_hood_raw.zip', 'https://data.montreal.ca/dataset/00bd85eb-23aa-4669-8f1b-ba9a000e3dd8/resource/62f7ce10-36ce-4bbd-b419-8f0a10d3b280/download/limadmin-shp.zip',
  'large/neighbourhoods/hal_hood_raw.zip', 'https://opendata.arcgis.com/api/v3/datasets/b4088a068b794436bdb4e5c31df76fe2_0/downloads/data?format=shp&spatialRefId=4326',
  
)



values_parks <- tribble(
  
  # columns
  ~dl_path, ~dl_link,
  
  # parks -------------------------------------------------------------------
  'large/parks/van_park_raw.zip', 'https://opendata.vancouver.ca/explore/dataset/parks-polygon-representation/download/?format=shp&timezone=Asia/Shanghai&lang=en',
  'large/parks/cal_park_raw.csv', 'https://data.calgary.ca/api/views/kami-qbfh/rows.csv?accessType=DOWNLOAD',
  'large/parks/win_park_raw.zip', 'https://data.winnipeg.ca/api/geospatial/tug6-p73s?method=export&format=Shapefile',
  'large/parks/tor_park_raw.zip', 'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/2aac8903-23ff-4072-ab72-b76cac44ad89/resource/9f53c253-a47e-497f-8a07-528f7d7aad90/download/parks-wgs84.zip',
  'large/parks/ott_park_raw.zip', 'https://opendata.arcgis.com/api/v3/datasets/cfb079e407494c33b038e86c7e05288e_24/downloads/data?format=shp&spatialRefId=4326',
  'large/parks/mon_park_raw.zip', 'https://data.montreal.ca/dataset/2e9e4d2f-173a-4c3d-a5e3-565d79baa27d/resource/c57baaf4-0fa8-4aa4-9358-61eb7457b650/download/shapefile.zip',
  'large/parks/hal_park_raw.zip', 'https://opendata.arcgis.com/api/v3/datasets/3df29a3d088a42d890f11d027ea1c0be_0/downloads/data?format=shp&spatialRefId=4326',
  
  
  # trees -------------------------------------------------------------------
  'large/trees/van_tree_raw.csv', 'https://opendata.vancouver.ca/explore/dataset/street-trees/download/?format=csv&timezone=America/New_York&lang=en&use_labels_for_header=true&csv_separator=%3B',
  'large/trees/cal_tree_raw.csv', 'https://data.calgary.ca/api/views/tfs4-3wwa/rows.csv?accessType=DOWNLOAD',
  'large/trees/win_tree_raw.csv', 'https://data.winnipeg.ca/api/views/h923-dxid/rows.csv?accessType=DOWNLOAD',
  'large/trees/tor_tree_raw.csv', 'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/6ac4569e-fd37-4cbc-ac63-db3624c5f6a2/resource/5930412c-408e-4ee3-b473-56a790c9dfb7/download/Alternate%20File_Street%20Tree%20Data_WGS84.csv.csv',
  'large/trees/ott_tree_raw.csv', 'https://opendata.arcgis.com/api/v3/datasets/13092822f69143b695bdb916357d421b_0/downloads/data?format=csv&spatialRefId=4326',
  'large/trees/mon_tree_raw.csv', 'https://data.montreal.ca/dataset/b89fd27d-4b49-461b-8e54-fa2b34a628c4/resource/64e28fe6-ef37-437a-972d-d1d3f1f7d891/download/arbres-publics.csv',
  'large/trees/hal_tree_raw.csv', 'https://opendata.arcgis.com/api/v3/datasets/33a4e9b6c7e9439abcd2b20ac50c5a4d_0/downloads/data?format=csv&spatialRefId=4326',
  
  
  # StatsCan boundaries -----------------------------------------------------
  'large/national/can_bound_raw.zip', 'https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/files-fichiers/lcma000b21a_e.zip',
  'large/national/can_road_raw.zip', 'https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/RNF-FRR/files-fichiers/lrnf000r21a_e.zip',
  'large/national/dsa_bound_raw.zip', 'https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/files-fichiers/lda_000b21a_e.zip',
  
  
  
  # census ------------------------------------------------------------------
  'large/national/cen_da_raw.zip', 'https://www12.statcan.gc.ca/census-recensement/2021/dp-pd/prof/details/download-telecharger/comp/GetFile.cfm?Lang=E&FILETYPE=CSV&GEONO=006CI',
  
  # dems --------------------------------------------------------------------
  'large/dem/van_1_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/BC/Lower_Mainland_2016/utm10/dsm_1m_utm10_w_0_145.tif',
  'large/dem/van_1_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/BC/Lower_Mainland_2016/utm10/dtm_1m_utm10_w_0_145.tif',
  'large/dem/van_2_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/BC/Lower_Mainland_2016/utm10/dsm_1m_utm10_w_1_145.tif',
  'large/dem/van_2_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/BC/Lower_Mainland_2016/utm10/dtm_1m_utm10_w_1_145.tif',
  
  'large/dem/cal_1_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_19_167.tif',
  'large/dem/cal_1_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_19_167.tif',
  'large/dem/cal_2_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_20_167.tif',
  'large/dem/cal_2_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_20_167.tif',
  'large/dem/cal_3_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_21_167.tif',
  'large/dem/cal_3_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_21_167.tif',
  'large/dem/cal_4_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_19_166.tif',
  'large/dem/cal_4_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_19_166.tif',
  'large/dem/cal_5_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_19_166.tif',
  'large/dem/cal_5_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_20_166.tif',
  'large/dem/cal_6_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_21_166.tif',
  'large/dem/cal_6_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_21_166.tif',
  'large/dem/cal_7_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_19_165.tif',
  'large/dem/cal_7_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_19_165.tif', 
  'large/dem/cal_8_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_20_165.tif',
  'large/dem/cal_8_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_20_165.tif',
  'large/dem/cal_9_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_21_165.tif',
  'large/dem/cal_9_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_21_165.tif',
  'large/dem/cal_10_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_20_164.tif',
  'large/dem/cal_10_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_20_164.tif',
  'large/dem/cal_11_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_21_164.tif',
  'large/dem/cal_11_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_21_164.tif',
  'large/dem/cal_12_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_20_163.tif', 
  'large/dem/cal_12_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_20_163.tif',
  'large/dem/cal_13_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/Calgary_West_utm11_2020/utm11/dsm_1m_utm11_e_21_163.tif',
  'large/dem/cal_13_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/Calgary_West_utm11_2020/utm11/dtm_1m_utm11_e_21_163.tif',
  
  'large/dem/win_1_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/MB/Red_River_2020/utm14/dsm_1m_utm14_e_12_153.tif',
  'large/dem/win_1_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/MB/Red_River_2020/utm14/dtm_1m_utm14_e_12_153.tif',
  'large/dem/win_2_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/MB/Red_River_2020/utm14/dsm_1m_utm14_e_13_153.tif',
  'large/dem/win_2_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/MB/Red_River_2020/utm14/dsm_1m_utm14_e_13_153.tif',
  'large/dem/win_3_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/MB/Red_River_2020/utm14/dsm_1m_utm14_e_14_153.tif',
  'large/dem/win_3_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/MB/Red_River_2020/utm14/dtm_1m_utm14_e_14_153.tif',
  'large/dem/win_4_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/MB/Red_River_2020/utm14/dsm_1m_utm14_e_12_152.tif',
  'large/dem/win_4_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/MB/Red_River_2020/utm14/dtm_1m_utm14_e_12_152.tif', 
  'large/dem/win_5_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/MB/Red_River_2020/utm14/dsm_1m_utm14_e_13_152.tif',
  'large/dem/win_5_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/MB/Red_River_2020/utm14/dtm_1m_utm14_e_13_152.tif',
  'large/dem/win_6_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/MB/Red_River_2020/utm14/dsm_1m_utm14_e_14_152.tif',
  'large/dem/win_6_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/MB/Red_River_2020/utm14/dtm_1m_utm14_e_14_152.tif',
  'large/dem/win_7_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/MB/Red_River_2020/utm14/dsm_1m_utm14_e_13_151.tif',
  'large/dem/win_7_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/MB/Red_River_2020/utm14/dtm_1m_utm14_e_13_151.tif', 
  
  'large/dem/tor_1_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_11_82.tif',
  'large/dem/tor_1_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_11_82.tif',
  'large/dem/tor_2_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_11_83.tif', 
  'large/dem/tor_2_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_11_83.tif',
  'large/dem/tor_3_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_11_84.tif',
  'large/dem/tor_3_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_11_84.tif',
  'large/dem/tor_4_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_12_82.tif',
  'large/dem/tor_4_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_12_82.tif',
  'large/dem/tor_5_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_12_83.tif',
  'large/dem/tor_5_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_12_83.tif', 
  'large/dem/tor_6_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_12_84.tif',
  'large/dem/tor_6_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_12_84.tif',
  'large/dem/tor_7_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_13_85.tif',
  'large/dem/tor_7_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_13_85.tif',
  'large/dem/tor_8_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_13_84.tif',
  'large/dem/tor_8_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_13_84.tif', 
  'large/dem/tor_9_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_13_83.tif',
  'large/dem/tor_9_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_13_83.tif', 
  'large/dem/tor_10_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_14_84.tif', 
  'large/dem/tor_10_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_14_84.tif', 
  'large/dem/tor_11_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_14_85.tif',
  'large/dem/tor_11_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_14_85.tif',
  'large/dem/tor_12_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NRCAN/York_2019/utm17/dsm_1m_utm17_e_15_85.tif',
  'large/dem/tor_12_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NRCAN/York_2019/utm17/dtm_1m_utm17_e_15_85.tif',
  
  'large/dem/ott_1_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_9_103.tif', 
  'large/dem/ott_1_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_9_103.tif', 
  'large/dem/ott_2_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/QC/600020_35_Outaouais_Gatineau_MTM9_2020/utm18/dsm_1m_utm18_w_8_103.tif',
  'large/dem/ott_2_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/QC/600020_35_Outaouais_Gatineau_MTM9_2020/utm18/dtm_1m_utm18_w_8_103.tif',
  'large/dem/ott_3_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_8_102.tif',
  'large/dem/ott_3_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_8_102.tif',
  'large/dem/ott_4_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_7_103.tif',
  'large/dem/ott_4_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_7_103.tif',
  'large/dem/ott_5_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_7_102.tif', 
  'large/dem/ott_5_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_7_102.tif',
  'large/dem/ott_6_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_7_101.tif',
  'large/dem/ott_6_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_7_101.tif', 
  'large/dem/ott_7_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_6_100.tif',
  'large/dem/ott_7_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_6_100.tif',
  'large/dem/ott_8_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_6_101.tif', 
  'large/dem/ott_8_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_6_101.tif', 
  'large/dem/ott_9_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_6_102.tif',
  'large/dem/ott_9_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_6_102.tif',
  'large/dem/ott_10_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_5_99.tif',
  'large/dem/ott_10_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_5_99.tif',
  'large/dem/ott_11_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_5_100.tif', 
  'large/dem/ott_11_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_5_100.tif', 
  'large/dem/ott_12_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_5_101.tif',
  'large/dem/ott_12_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_5_101.tif',
  'large/dem/ott_13_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_5_102.tif',
  'large/dem/ott_13_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_5_102.tif',
  'large/dem/ott_14_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_5_103.tif',
  'large/dem/ott_14_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_5_103.tif', 
  'large/dem/ott_15_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_4_103.tif',
  'large/dem/ott_15_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_4_103.tif',
  'large/dem/ott_16_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_4_102.tif',
  'large/dem/ott_16_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_4_102.tif',
  'large/dem/ott_17_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_4_101.tif',
  'large/dem/ott_17_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_4_101.tif',
  'large/dem/ott_18_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_4_100.tif',
  'large/dem/ott_18_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_4_100.tif',
  'large/dem/ott_19_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_3_100.tif',
  'large/dem/ott_19_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_3_100.tif',
  'large/dem/ott_20_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_3_101.tif',
  'large/dem/ott_20_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_3_101.tif',
  'large/dem/ott_21_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_3_102.tif',
  'large/dem/ott_21_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_3_102.tif', 
  'large/dem/ott_22_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_2_102.tif',
  'large/dem/ott_22_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_2_102.tif', 
  'large/dem/ott_23_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_3_103.tif',
  'large/dem/ott_23_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_3_103.tif',
  'large/dem/ott_24_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_4_103.tif',
  'large/dem/ott_24_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_4_103.tif',
  'large/dem/ott_25_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dsm_1m_utm18_w_4_102.tif',
  'large/dem/ott_25_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_OTTAWA/Ottawa_Gatineau_2020/utm18/dtm_1m_utm18_w_4_102.tif',
  
  'large/dem/mon_1_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/QC/Fleuve_St_Laurent_2018/utm18/dsm_1m_utm18_e_8_103.tif',
  'large/dem/mon_1_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/QC/Fleuve_St_Laurent_2018/utm18/dtm_1m_utm18_e_8_103.tif',
  'large/dem/mon_2_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/QC/Fleuve_St_Laurent_2018/utm18/dsm_1m_utm18_e_9_103.tif',
  'large/dem/mon_2_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/QC/Fleuve_St_Laurent_2018/utm18/dtm_1m_utm18_e_9_103.tif',
  'large/dem/mon_3_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/QC/Fleuve_St_Laurent_2018/utm18/dsm_1m_utm18_e_10_103.tif',
  'large/dem/mon_3_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/QC/Fleuve_St_Laurent_2018/utm18/dtm_1m_utm18_e_10_103.tif',
  'large/dem/mon_4_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/QC/Fleuve_St_Laurent_2018/utm18/dsm_1m_utm18_e_11_103.tif',
  'large/dem/mon_4_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/QC/Fleuve_St_Laurent_2018/utm18/dtm_1m_utm18_e_11_103.tif', 
  'large/dem/mon_5_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/QC/600017-31_Partie_NO/utm18/dsm_1m_utm18_e_10_104.tif',
  'large/dem/mon_5_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/QC/600017-31_Partie_NO/utm18/dtm_1m_utm18_e_10_104.tif',
  'large/dem/mon_6_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/QC/Fleuve_St_Laurent_2018/utm18/dsm_1m_utm18_e_11_104.tif',
  'large/dem/mon_6_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/QC/Fleuve_St_Laurent_2018/utm18/dtm_1m_utm18_e_11_104.tif', 
  'large/dem/mon_7_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/QC/600017-31_Partie_NO/utm18/dsm_1m_utm18_e_10_105.tif', 
  'large/dem/mon_7_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/QC/600017-31_Partie_NO/utm18/dtm_1m_utm18_e_10_105.tif', 
  'large/dem/mon_8_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/QC/Fleuve_St_Laurent_2018/utm18/dsm_1m_utm18_e_11_105.tif',
  'large/dem/mon_8_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/QC/Fleuve_St_Laurent_2018/utm18/dtm_1m_utm18_e_11_105.tif',
  
  'large/dem/hal_1_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NS/NSDNR_2019_3/utm20/dsm_1m_utm20_w_4_94.tif',
  'large/dem/hal_1_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NS/NSDNR_2019_3/utm20/dtm_1m_utm20_w_4_94.tif',
  'large/dem/hal_2_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NS/NSDNR_2019_3/utm20/dsm_1m_utm20_w_5_94.tif', 
  'large/dem/hal_2_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NS/NSDNR_2019_3/utm20/dtm_1m_utm20_w_5_94.tif', 
  'large/dem/hal_3_dsm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/NS/NSDNR_2019_3/utm20/dsm_1m_utm20_w_4_95.tif', 
  'large/dem/hal_3_dtm.tif', 'https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/NS/NSDNR_2019_3/utm20/dtm_1m_utm20_w_4_95.tif'
  
)

values_trib$file_name <- basename(sans_ext(values_trib$dl_path))
values_trib$file_name_sym <- lapply(values_trib$file_name, as.symbol)
values_trib$file_ext <- lapply(values_trib$dl_path, file_ext)

