# Script to download public tree inventories

#### Packages ####
# if installing sf for the first time on mac, use line 5
# install.packages("sf", configure.args = "--with-proj-lib=/usr/local/lib/")
easypackages::packages("sf", "mapview", "downloader", "tidyverse")

#### Data Downloads ####

### Park data downloads
## Excluding Montreal and Winnipeg
## Calgary park data download
cal_park_url <- "https://data.calgary.ca/api/views/kami-qbfh/rows.csv?accessType=DOWNLOAD"
cal_park_dest <- "input/cal_park_raw.csv"
download.file(cal_park_url,cal_park_dest, mode="wb")
cal_park_raw<-read.csv(cal_park_dest)
View(cal_park_raw)

## Halifax park data download
hal_park_url <- ""
hal_park_dest <- "large/hal_park_raw.zip"
download.file(hal_park_url,hal_park_dest, mode="wb")
unzip(hal_park_dest, exdir="large/hal_park_raw")
hal_park_raw <- read_sf("large/hal_park_raw/HRM_Parks.shp")
View(hal_park_raw)

## Ottawa park data download
ott_park_url <- "https://opendata.arcgis.com/api/v3/datasets/cfb079e407494c33b038e86c7e05288e_24/downloads/data?format=shp&spatialRefId=4326"
ott_park_dest <- "large/ott_park_raw.zip"
download.file(ott_park_url,ott_park_dest, mode="wb")
unzip(van_park_dest, exdir="large/ott_park_raw")
ott_park_raw <- read_sf("large/ott_park_raw/parks-polygon-representation.shp")
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

## Canada municipality boundary downloads
# Canada bounds shapefile
bound_url <- "https://www12.statcan.gc.ca/census-recensement/2011/geo/RNF-FRR/files-fichiers/lrnf000r20a_e.zip"
# saving to large folder
bound_dest <- "large/can_bound.zip"
download.file(bound_url,bound_dest, mode="wb")
unzip(bound_dest, exdir="large/can_bound")
can_bound <- read_sf("large/can_bound/lrnf000r20a_e.shp")

## Canada road network downloads
# Canada road shapefile
road_url <- "https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/lcsd000a20a_e.zip"
# saving to large folder
road_dest <- "large/can_road.zip"
download.file(road_url,road_dest, mode="wb")
unzip(road_dest, exdir="large/can_road")
can_road <- read_sf("large/can_road/lcsd000a20a_e.shp")
View(can_road)

#### Setting download time ####
# For roads and bounds
getOption('timeout')
options(timeout=600)
