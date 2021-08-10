# Script to download public tree inventories
# Authors: Nicole Yu & Isabella Richmond

#### Packages ####
# if installing sf, data.table for the first time on mac, use line 6 and 7
# install.packages("sf", configure.args = "--with-proj-lib=/usr/local/lib/")
# install.packages("data.table", type = "source",repos = "https://Rdatatable.gitlab.io/data.table")
easypackages::packages("sf", "downloader", "tidyverse", "data.table", "bit64")

#### Setting download time ####
# Need a longer timeout for roads and bounds 
getOption('timeout')
options(timeout=600)

#### Data Downloads ####
# NOTE: all files larger than 50MB are downloaded to large/ folder 
# instead of input/ so they are not tracked on Git

### Neighborhood data downloads ###
## Calgary neighbourhood data download
cal_hood_url <- "https://data.calgary.ca/api/views/surr-xmvs/rows.csv?accessType=DOWNLOAD"
cal_hood_dest <- "input/cal_hood_raw.csv"
download.file(cal_hood_url,cal_hood_dest, mode="wb")
cal_hood_raw <- read.csv(cal_hood_dest)
View(cal_hood_raw)

## Halifax neighbourhood data download
hal_hood_url <- "https://opendata.arcgis.com/api/v3/datasets/b4088a068b794436bdb4e5c31df76fe2_0/downloads/data?format=shp&spatialRefId=4326"
hal_hood_dest <- "large/hal_hood_raw.zip"
download.file(hal_hood_url,hal_hood_dest, mode="wb")
unzip(hal_hood_dest, exdir="large/hal_hood_raw")
hal_hood_raw <- read_sf("large/hal_hood_raw/Community_Boundaries.shp")
View(hal_hood_raw)

## Montreal neighbourhood data download
mon_hood_url <- "https://data.montreal.ca/dataset/00bd85eb-23aa-4669-8f1b-ba9a000e3dd8/resource/62f7ce10-36ce-4bbd-b419-8f0a10d3b280/download/limadmin-shp.zip"
mon_hood_dest <- "large/mon_hood_raw.zip"
download.file(mon_hood_url,mon_hood_dest, mode="wb")
unzip(mon_hood_dest, exdir="large/mon_hood_raw")
mon_hood_raw <- read_sf("large/mon_hood_raw/LIMADMIN.shp")
View(mon_hood_raw)

## Ottawa neighbourhood data download
ott_hood_url <- "https://opendata.arcgis.com/api/v3/datasets/32fe76b71c5e424fab19fec1f180ec18_0/downloads/data?format=shp&spatialRefId=4326"
ott_hood_dest <- "large/ott_hood_raw.zip"
download.file(ott_hood_url,ott_hood_dest, mode="wb")
unzip(ott_hood_dest, exdir="large/ott_hood_raw")
ott_hood_raw <- read_sf("large/ott_hood_raw/Ottawa_Neighbourhood_Study_(ONS)_-_Neighbourhood_Boundaries_Gen_2.shp")
View(ott_hood_raw)

## Toronto community data download
tor_hood_url <- "https://ckan0.cf.opendata.inter.prod-toronto.ca/download_resource/a083c865-6d60-4d1d-b6c6-b0c8a85f9c15?format=shp&projection=4326"
tor_hood_dest <- "large/tor_hood_raw.zip"
download.file(tor_hood_url,tor_hood_dest, mode="wb")
unzip(tor_hood_dest, exdir="large/tor_hood_raw")
tor_hood_raw <- read_sf("large/tor_hood_raw/Neighbourhoods.shp")
View(tor_hood_raw)

## Vancouver neighbourhood data download
van_hood_url <- "https://opendata.vancouver.ca/explore/dataset/local-area-boundary/download/?format=shp&timezone=Asia/Shanghai&lang=enn"
van_hood_dest <- "large/van_hood_raw.zip"
download.file(van_hood_url,van_hood_dest, mode="wb")
unzip(van_hood_dest, exdir="large/van_hood_raw")
van_hood_raw <- read_sf("large/van_hood_raw/local-area-boundary.shp")
View(van_hood_raw)

## Winnipeg neighbourhood data download
win_hood_url <- "https://data.winnipeg.ca/api/geospatial/fen6-iygi?method=export&format=Shapefile"
win_hood_dest <- "large/win_hood_raw.zip"
download.file(win_hood_url,win_hood_dest, mode="wb")
unzip(win_hood_dest, exdir="large/win_hood_raw")
win_hood_raw <- read_sf("large/win_hood_raw/geo_export_a47a3525-fc99-4728-9039-eefec3dcf2de.shp")
View(win_hood_raw)

### Park data downloads
## Excluding Montreal and Winnipeg
## Calgary park data download
cal_park_url <- "https://data.calgary.ca/api/views/kami-qbfh/rows.csv?accessType=DOWNLOAD"
cal_park_dest <- "input/cal_park_raw.csv"
download.file(cal_park_url,cal_park_dest, mode="wb")
cal_park_raw <- read.csv(cal_park_dest)
View(cal_park_raw)

## Halifax park data download
hal_park_url <- "https://opendata.arcgis.com/api/v3/datasets/3df29a3d088a42d890f11d027ea1c0be_0/downloads/data?format=shp&spatialRefId=4326"
hal_park_dest <- "large/hal_park_raw.zip"
download.file(hal_park_url,hal_park_dest, mode="wb")
unzip(hal_park_dest, exdir="large/hal_park_raw")
hal_park_raw <- read_sf("large/hal_park_raw/HRM_Parks.shp")
View(hal_park_raw)

## Ottawa park data download
ott_park_url <- "https://opendata.arcgis.com/api/v3/datasets/cfb079e407494c33b038e86c7e05288e_24/downloads/data?format=shp&spatialRefId=4326"
ott_park_dest <- "large/ott_park_raw.zip"
download.file(ott_park_url,ott_park_dest, mode="wb")
unzip(ott_park_dest, exdir="large/ott_park_raw")
ott_park_raw <- read_sf("large/ott_park_raw/Parks_and_Greenspace.shp")
View(ott_park_raw)

## Toronto park data download
tor_park_url <- "https://ckan0.cf.opendata.inter.prod-toronto.ca/download_resource/198b6d28-c7f1-4770-8ad4-69534b9cdd82"
tor_park_dest <- "large/tor_park_raw.zip"
download.file(tor_park_url,tor_park_dest, mode="wb")
unzip(tor_park_dest, exdir="large/tor_park_raw")
tor_park_raw <- read_sf("large/tor_park_raw/CITY_GREEN_SPACE_WGS84.shp")
View(tor_park_raw)

## Vancouver park data download
van_park_url <- "https://opendata.vancouver.ca/explore/dataset/parks-polygon-representation/download/?format=shp&timezone=Asia/Shanghai&lang=en"
van_park_dest <- "large/van_park_raw.zip"
download.file(van_park_url,van_park_dest, mode="wb")
unzip(van_park_dest, exdir="large/van_park_raw")
van_park_raw <- read_sf("large/van_park_raw/parks-polygon-representation.shp")
View(van_park_raw)

# clean environment to make space for tree inventories 
rm(list=ls())

### Tree data downloads
## Calgary tree data download
# City of Calgary open data public tree inventory link
cal_tree_url<- "https://data.calgary.ca/api/views/tfs4-3wwa/rows.csv?accessType=DOWNLOAD"
# saving to large folder
cal_tree_dest<- "large/cal_tree_raw.csv"
download.file(cal_tree_url, cal_tree_dest, mode="wb")
cal_tree_raw<-read.csv(cal_tree_dest)
View(cal_tree_raw)

## Halifax tree data download
# City of Halifax open data public tree inventory link
hal_tree_url <- "https://opendata.arcgis.com/api/v3/datasets/33a4e9b6c7e9439abcd2b20ac50c5a4d_0/downloads/data?format=csv&spatialRefId=4326"
hal_tree_dest <- "input/hal_tree_raw.csv"
download.file(hal_tree_url, hal_tree_dest, mode = "wb")
hal_tree_raw <- read.csv(hal_tree_dest)
View(hal_tree_raw)

## Montreal tree data download
# City of Montreal open data public tree inventory link
mon_tree_url<- "https://data.montreal.ca/dataset/b89fd27d-4b49-461b-8e54-fa2b34a628c4/resource/64e28fe6-ef37-437a-972d-d1d3f1f7d891/download/arbres-publics.csv"
# saving to large folder
mon_tree_dest<- "large/mon_tree_raw.csv"
download.file(mon_tree_url,mon_tree_dest, mode="wb")
# note: Montreal tree dataset is 89MB - close to Git's limit
mon_tree_raw<-read.csv(mon_tree_dest)
View(mon_tree_raw)

## Ottawa tree data download
# City of Ottawa open data public tree inventory link
ott_tree_url <- "https://opendata.arcgis.com/api/v3/datasets/13092822f69143b695bdb916357d421b_0/downloads/data?format=csv&spatialRefId=4326"
ott_tree_dest <- "input/ott_tree_raw.csv"
download.file(ott_tree_url, ott_tree_dest, mode = "wb")
ott_tree_raw <- read.csv(ott_tree_dest)
View(ott_tree_raw)

## Toronto tree data download (shapefile)
# City of Toronto open data public tree inventory link
tor_tree_url<- "https://ckan0.cf.opendata.inter.prod-toronto.ca/download_resource/c1229af1-8ab6-4c71-b131-8be12da59c8e"
# saving to large folder because the shapefile is too big 
tor_tree_dest<- "large/tor_tree_raw.zip"
download.file(tor_tree_url,tor_tree_dest, mode="wb")
unzip(tor_tree_dest, exdir="large/tor_tree_raw")
tor_tree_raw <- read_sf("large/tor_tree_raw/TMMS_Open_Data_WGS84.shp")
View(tor_tree_raw)

## Vancouver tree data download
# City of Vancouver open data public tree inventory link
van_tree_url <- "https://opendata.vancouver.ca/explore/dataset/street-trees/download/?format=csv&timezone=Asia/Shanghai&lang=en&use_labels_for_header=true&csv_separator=%3B"
van_tree_dest <- "input/van_tree_raw.csv"
download.file(van_tree_url,van_tree_dest, mode="wb")
van_tree_raw <-read.csv(van_tree_dest, sep=";")
View(van_tree_raw)

## Winnipeg tree data download
# City of Winnipeg open data public tree inventory link
win_tree_url <- "https://data.winnipeg.ca/api/views/h923-dxid/rows.csv?accessType=DOWNLOAD"
# saving to large folder
win_tree_dest <- "large/win_tree_raw.csv"
download.file(win_tree_url,win_tree_dest, mode="wb")
win_tree_raw <-read.csv(win_tree_dest)
View(win_tree_raw)

# clean environment
rm(list=ls())

### Municipal neighbourhood downloads 
## Ottawa hood data download
ott_hood_url <- "https://opendata.arcgis.com/api/v3/datasets/32fe76b71c5e424fab19fec1f180ec18_0/downloads/data?format=shp&spatialRefId=4326"
ott_hood_dest <- "large/ott_hood_raw.zip"
download.file(ott_hood_url,ott_hood_dest, mode="wb")
unzip(ott_hood_dest, exdir="large/ott_hood_raw")
ott_hood_raw <- read_sf("large/ott_hood_raw/Ottawa_Neighbourhood_Study_(ONS)_-_Neighbourhood_Boundaries_Gen_2.shp")
View(ott_hood_raw)

### Canada downloads
## Municipal boundary layer download
# Canada bounds shapefile
bound_url <- "https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lcma000b16a_e.zip"
# saving to large folder
bound_dest <- "large/can_bound_raw.zip"
download.file(bound_url,bound_dest, mode="wb")
unzip(bound_dest, exdir="large/can_bound_raw")
can_bound_raw <- read_sf("large/can_bound_raw/lcma000b16a_e.shp")

## Canada road network downloads
# Canada road shapefile
road_url <- "https://www12.statcan.gc.ca/census-recensement/2011/geo/RNF-FRR/files-fichiers/lrnf000r20a_e.zip"
# saving to large folder
road_dest <- "large/can_road_raw.zip"
download.file(road_url,road_dest, mode="wb")
unzip(road_dest, exdir="large/can_road_raw")
can_road_raw <- read_sf("large/can_road_raw/lrnf000r20a_e.shp")
View(can_road_raw)

### Other supplementary files
# Halifax tree species codes
# extracted from tree data metadata accessible from http://hrm.maps.arcgis.com/sharing/rest/content/items/87d562e852a44e64ae268609e2cdc0d2/data
hal_tree_spcode <-read.csv("input/hal_tree_spcode.csv")
# Halifax tree dbh codes
# 9 categories, matched with dataset viewed in ARCGIS Viewer from https://www.arcgis.com/home/webmap/viewer.html?panel=gallery&layers=33a4e9b6c7e9439abcd2b20ac50c5a4d
hal_tree_dbhcode <-read.csv("input/hal_tree_dbhcode.csv", row.names = NULL)
# Montreal neighbourhood code
mon_tree_hoodcode <-read.csv("input/mon_tree_hoodcode.csv", row.names = NULL)

### 2016 Census data ###
# Dissemination Area boundaries
dsa_bound_url <- "https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lda_000b16a_e.zip" 
dsa_bound_dest <- "large/dsa_bound_raw.zip"
download.file(dsa_bound_url,dsa_bound_dest, mode="wb")
unzip(dsa_bound_dest, exdir="large/dsa_bound_raw")
dsa_bound_raw <- read_sf("large/dsa_bound_raw/lda_000b16a_e.shp")

# Census Survey Data
# census data downloaded is at the geographic scale of provinces, territories, census divisions (CDs), census subdivisions (CSDs), and dissemination areas (DAs)
can_cen_url <- "https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/prof/details/download-telecharger/comp/GetFile.cfm?Lang=E&FILETYPE=CSV&GEONO=044"
# saving to large folder
can_cen_dest <- "large/can_cen_raw.zip"
download.file(can_cen_url,can_cen_dest, mode="wb")
unzip(can_cen_dest, exdir="large/can_cen_raw")
can_cen_raw <- fread("large/can_cen_raw/98-401-X2016044_English_CSV_data.csv")

