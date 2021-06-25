# Script to download public tree inventories

#### Packages ####
# if installing sf for the first time on mac, use line 5
# install.packages("sf", configure.args = "--with-proj-lib=/usr/local/lib/")
easypackages::packages("sf", "mapview", "downloader", "tidyverse")

#### Data Downloads ####

## Calgary tree data download
# City of Calgary open data public tree inventory link
cal_URL<- "https://data.calgary.ca/api/views/tfs4-3wwa/rows.csv?accessType=DOWNLOAD"
# save to input folder
cal_dest<- "input/cal_tree_raw.csv"
download.file(cal_URL, cal_dest, mode="wb")
cal_tree_raw<-read.csv(cal_dest)
View(cal_tree_raw)

## Halifax tree data download
hal_URL <- "https://catalogue-hrm.opendata.arcgis.com/datasets/33a4e9b6c7e9439abcd2b20ac50c5a4d_0/explore?location=44.648814%2C-63.600208%2C13.44"
hal_dest <- "input/hal_tree_raw.csv"
download.file(hal_URL, hal_dest, mode = "wb")


## Montreal tree data download
# City of Montreal open data public tree inventory link
mon_URL<- "https://data.montreal.ca/dataset/b89fd27d-4b49-461b-8e54-fa2b34a628c4/resource/64e28fe6-ef37-437a-972d-d1d3f1f7d891/download/arbres-publics.csv"
mon_dest<- "input/mon_tree_raw.csv"
download.file(mon_URL,mon_dest, mode="wb")
# note: Montreal tree dataset is 89MB - close to Git's limit
mon_tree_raw<-read.csv(mon_dest)
View(mon_tree_raw)

## Ottawa tree data download



## Toronto tree data download (shapefile)
# City of Toronto open data public tree inventory link
tor_URL<- "https://ckan0.cf.opendata.inter.prod-toronto.ca/download_resource/c1229af1-8ab6-4c71-b131-8be12da59c8e"
# saving to large folder because the shapefile is too big 
tor_dest<- "large/tor_tree_raw.zip"
download.file(tor_URL,tor_dest, mode="wb")
unzip(tor_dest, exdir="large/tor_tree_raw")
tor_tree_raw <- read_sf("large/tor_tree_raw/TMMS_Open_Data_WGS84.shp")

## Vancouver tree data download
# City of Vancouver open data public tree inventory link
van_URL <- "https://opendata.vancouver.ca/explore/dataset/street-trees/download/?format=csv&timezone=Asia/Shanghai&lang=en&use_labels_for_header=true&csv_separator=%3B"
van_dest <- "input/van_tree_raw.csv"
download.file(van_URL,van_dest, mode="wb")
van_tree_raw <-read.csv(van_dest, sep=";")
View(van_tree_raw)

## Winnipeg tree data download
# City of Winnipeg open data public tree inventory link
win_URL <- "https://data.winnipeg.ca/api/views/hfwk-jp4h/rows.csv?accessType=DOWNLOAD"
win_dest <- "/Users/nicoleyu/Desktop/GRI ZULE/R Cross City ES/Raw data/win_tree_raw.csv"
download.file(win_URL,win_dest, mode="wb")
win_tree_raw <-read.csv(win_dest)
View(win_tree_raw)

