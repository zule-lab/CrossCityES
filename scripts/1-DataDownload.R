# Script to download public tree inventories
# Authors: Nicole Yu & Isabella Richmond

#### Setting download time ####
# Need a longer timeout for roads and bounds 
getOption('timeout')
options(timeout=600)


#### Functions #### 
download_csv <- function(url, dest){
  
  p <- c("downloader","readr", "bit64")
  lapply(p, library, character.only = T)
  
  download.file(url, dest, mode = "wb")
  
  df <- read_csv(dest)
  
  View(df)
  
}


download_shp <- function(url, dest){
  p <- c("downloader","sf", "bit64")
  lapply(p, library, character.only = T)
  
  temp <- tempfile()
  
  download.file(url, dest, mode = "wb")
  
  shp <- st_read(file.path("/vsizip", dest))
  
  View(shp)
  
}


#### Data Downloads ####
# NOTE: all files larger than 50MB are downloaded to large/ folder 
# instead of input/ so they are not tracked on Git

### NEIGHBOURHOODS ###
## Calgary neighbourhood data download
download_csv("https://data.calgary.ca/api/views/surr-xmvs/rows.csv?accessType=DOWNLOAD", 
             "large/neighbourhoods/cal_hood_raw.csv")

## Halifax neighbourhood data download
download_shp("https://opendata.arcgis.com/api/v3/datasets/b4088a068b794436bdb4e5c31df76fe2_0/downloads/data?format=shp&spatialRefId=4326",
             "large/neighbourhoods/hal_hood_raw.zip")  


## Montreal neighbourhood data download
download_shp("https://data.montreal.ca/dataset/00bd85eb-23aa-4669-8f1b-ba9a000e3dd8/resource/62f7ce10-36ce-4bbd-b419-8f0a10d3b280/download/limadmin-shp.zip",
             "large/neighbourhoods/mon_hood_raw.zip")

## Ottawa neighbourhood data download
download_shp("https://opendata.arcgis.com/api/v3/datasets/32fe76b71c5e424fab19fec1f180ec18_0/downloads/data?format=shp&spatialRefId=4326",
             "large/neighbourhoods/ott_hood_raw.zip")

## Toronto community data download
download_shp("https://ckan0.cf.opendata.inter.prod-toronto.ca/download_resource/a083c865-6d60-4d1d-b6c6-b0c8a85f9c15?format=shp&projection=4326",
             "large/neighbourhoods/tor_hood_raw.zip")

## Vancouver neighbourhood data download
download_shp("https://opendata.vancouver.ca/explore/dataset/local-area-boundary/download/?format=shp&timezone=Asia/Shanghai&lang=enn",
             "large/neighbourhoods/van_hood_raw.zip")

## Winnipeg neighbourhood data download
download_shp("https://data.winnipeg.ca/api/geospatial/fen6-iygi?method=export&format=Shapefile",
             "large/neighbourhoods/win_hood_raw.zip")

### PARKS ###
## Calgary park data download
download_csv("https://data.calgary.ca/api/views/kami-qbfh/rows.csv?accessType=DOWNLOAD",
             "large/parks/cal_park_raw.csv")

## Halifax park data download
download_shp("https://opendata.arcgis.com/api/v3/datasets/3df29a3d088a42d890f11d027ea1c0be_0/downloads/data?format=shp&spatialRefId=4326",
             "large/parks/hal_park_raw.zip")

## Montreal park data download 
download_shp("https://data.montreal.ca/dataset/2e9e4d2f-173a-4c3d-a5e3-565d79baa27d/resource/c57baaf4-0fa8-4aa4-9358-61eb7457b650/download/shapefile.zip",
             "large/parks/mon_park_raw.zip")

## Ottawa park data download
download_shp("https://opendata.arcgis.com/api/v3/datasets/cfb079e407494c33b038e86c7e05288e_24/downloads/data?format=shp&spatialRefId=4326",
             "large/parks/ott_park_raw.zip")

## Toronto park data download
download_shp("https://ckan0.cf.opendata.inter.prod-toronto.ca/download_resource/198b6d28-c7f1-4770-8ad4-69534b9cdd82",
             "large/parks/tor_park_raw.zip")

## Vancouver park data download
download_shp("https://opendata.vancouver.ca/explore/dataset/parks-polygon-representation/download/?format=shp&timezone=Asia/Shanghai&lang=en",
             "large/parks/van_park_raw.zip")

## Winnipeg park data download
download_shp("https://data.winnipeg.ca/api/geospatial/tug6-p73s?method=export&format=Shapefile",
             "large/parks/win_park_raw.zip")


### TREES ###
## Calgary
download_csv("https://data.calgary.ca/api/views/tfs4-3wwa/rows.csv?accessType=DOWNLOAD",
             "large/trees/cal_tree_raw.csv")

## Halifax
download_csv("https://opendata.arcgis.com/api/v3/datasets/33a4e9b6c7e9439abcd2b20ac50c5a4d_0/downloads/data?format=csv&spatialRefId=4326",
             "large/trees/hal_tree_raw.csv")

## Montreal
download_csv("https://data.montreal.ca/dataset/b89fd27d-4b49-461b-8e54-fa2b34a628c4/resource/64e28fe6-ef37-437a-972d-d1d3f1f7d891/download/arbres-publics.csv",
             "large/trees/mon_tree_raw.csv")

## Ottawa
download_csv("https://opendata.arcgis.com/api/v3/datasets/13092822f69143b695bdb916357d421b_0/downloads/data?format=csv&spatialRefId=4326",
             "large/trees/ott_tree_raw.csv")

## Toronto 
# alternate file because main download link has issues - revisit
download_csv("https://ckan0.cf.opendata.inter.prod-toronto.ca/download_resource/b4163dc2-7871-4592-8bcd-9f0c1bcb63ba",
             "large/trees/tor_tree_raw.csv")

## Vancouver
# csv uses ; as separator
download_csv("https://opendata.vancouver.ca/explore/dataset/street-trees/download/?format=csv&timezone=America/New_York&lang=en&use_labels_for_header=true&csv_separator=%3B",
             "large/trees/van_tree_raw.csv")

## Winnipeg
download_csv("https://data.winnipeg.ca/api/views/h923-dxid/rows.csv?accessType=DOWNLOAD",
             "large/trees/win_tree_raw.csv")


### NATIONAL ###
## Municipal boundaries
download_shp("https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lcma000b16a_e.zip",
             "large/national/can_bound_raw.zip")

## Road network
download_shp("https://www12.statcan.gc.ca/census-recensement/2011/geo/RNF-FRR/files-fichiers/lrnf000r20a_e.zip",
             "large/national/can_road_raw.zip")


## Building footprints
# defining the municipality names used in the links
municipality <- c("Alberta", "NovaScotia", "Quebec", "Ontario", "BritishColumbia", "Manitoba")
# download and unzip data from all 6 regional municipalities to large file
for (i in 1:length(municipality)){
  build_url <- paste0("https://usbuildingdata.blob.core.windows.net/canadian-buildings-v2/", municipality, ".zip")
  build_dest <- paste0("large/national/", municipality, "_building_density.zip")
  build_output <- paste0("large/national/", municipality, "_building_density")
  download.file(build_url[i], build_dest[i], mode="wb")
}

## 2016 census Dissemination Area boundaries
download_shp("https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lda_000b16a_e.zip",
             "large/national/dsa_bound_raw.zip")

## 2016 census survey data
download_csv("https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/prof/details/download-telecharger/comp/GetFile.cfm?Lang=E&FILETYPE=CSV&GEONO=044",
             "large/national/can_cen_raw.zip")

### SUPPLEMENTARY FILES ###
# Halifax tree species codes
# extracted from tree data metadata accessible from http://hrm.maps.arcgis.com/sharing/rest/content/items/87d562e852a44e64ae268609e2cdc0d2/data
hal_tree_spcode <- read.csv("input/hal_tree_spcode.csv")
# Halifax tree dbh codes
# 9 categories, matched with dataset viewed in ARCGIS Viewer from https://www.arcgis.com/home/webmap/viewer.html?panel=gallery&layers=33a4e9b6c7e9439abcd2b20ac50c5a4d
hal_tree_dbhcode <- read.csv("input/hal_tree_dbhcode.csv", row.names = NULL)
# Montreal neighbourhood code
mon_tree_hoodcode <- read.csv("input/mon_tree_hoodcode.csv", row.names = NULL)
