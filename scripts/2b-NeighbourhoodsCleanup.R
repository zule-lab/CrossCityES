# Script to clean up Canada roads and city boundary raw data
# Author: Nicole Yu & Isabella Richmond

#### Packages ####
easypackages::packages("tidyverse","sf")

#### Data ####
# Calgary neighbourhood boundaries
cal_hood_raw <- read.csv("input/cal_hood_raw.csv")
# Halifax neighbourhood boundaries
hal_hood_raw <- read_sf("large/hal_hood_raw/Community_Boundaries.shp")
# Montreal neighbourhood boundaries
mon_hood_raw <- read_sf("large/mon_hood_raw/LIMADMIN.shp")
## Ottawa neighbourhood boundaries
ott_hood_raw <- read_sf("large/ott_hood_raw/Ottawa_Neighbourhood_Study_(ONS)_-_Neighbourhood_Boundaries_Gen_2.shp")
## Toronto neighbourhood boundaries
tor_hood_raw <- read_sf("large/tor_hood_raw/Neighbourhoods.shp")
## Vancouver neighbourhood boundaries
van_hood_raw <- read_sf("large/van_hood_raw/local-area-boundary.shp")
## Winnipeg neighbourhood boundaries
win_hood_raw <- read_sf("large/win_hood_raw/geo_export_a47a3525-fc99-4728-9039-eefec3dcf2de.shp")

#### Neighbourhood boundary cleanup
## Calgary
# select neighbourhood codes and names columns and rename
cal_hood <- cal_hood_raw %>% 
  select(c("NAME", "the_geom")) %>% 
  rename("hood" = "NAME") %>% 
  rename("geometry" = "the_geom") %>%
  mutate(city = c("Calgary"))
# change case of hood names
cal_hood$hood <- str_to_title(cal_hood$hood) 
# convert to sf object
cal_hood <- st_as_sf(cal_hood, wkt = "geometry", crs = 4326)
cal_hood <- st_transform(cal_hood, crs = 6624)
# save
saveRDS(cal_hood, "large/CalgaryNeighbourhoodsCleaned.rds")
st_write(cal_hood, "large/CalgaryNeighbourhoodsCleaned.gpkg", driver = "GPKG")

## Halifax
# add city column, select neighbourhood and geometry from hood dataset
# Halifax peninsula is considered to be one neighbourhood
hal_hood <- hal_hood_raw %>% 
  select(c("GSA_NAME", "geometry")) %>% 
  rename("hood" = "GSA_NAME") %>% 
  filter(hood == "HALIFAX") %>%
  mutate(city = c("Halifax"))
# change case of hood names
hal_hood$hood <- str_to_title(hal_hood$hood)
# transform to EPSG: 6624 to be consistent with other layers
hal_hood <- st_transform(hal_hood, crs = 6624)
# save cleaned neighbourhoods layer 
saveRDS(hal_hood, "large/HalifaxNeighbourhoodsCleaned.rds")
st_write(hal_hood, "large/HalifaxNeighbourhoodsCleaned.gpkg", driver = "GPKG")

## Montreal
# select neighbourhood name and geometry from hood dataset
mon_hood <- mon_hood_raw %>% select(c("NOM","geometry")) %>%
  rename("hood" = "NOM") %>%
  mutate(city = c("Montreal"))
# transform
mon_hood <- st_transform(mon_hood,crs = 6624)
# save
saveRDS(mon_hood, "large/MontrealNeighbourhoodsCleaned.rds")
st_write(mon_hood, "large/MontrealNeighbourhoodsCleaned.gpkg", driver = "GPKG")

## Ottawa
# select neighbourhood name and geometry from hood dataset
ott_hood <- ott_hood_raw %>% 
  select(c("Name", "geometry")) %>% 
  rename("hood" = "Name") %>%
  mutate(city = c("Ottawa"))
# transform
ott_hood <- st_transform(ott_hood, crs = 6624)
# save cleaned neighbourhoods layer 
saveRDS(ott_hood, "large/OttawaNeighbourhoodsCleaned.rds")
st_write(ott_hood, "large/OttawaNeighbourhoodsCleaned.gpkg", driver = "GPKG")

## Toronto
# select neighbourhood name and geometry from hood dataset
tor_hood <- tor_hood_raw %>% select(c("FIELD_8", "geometry")) %>% 
  rename("hood" = "FIELD_8")%>%
  mutate(city = c("Toronto"))
# transform
tor_hood <- st_transform(tor_hood, crs = 6624)
# save
saveRDS(tor_hood, "large/TorontoNeighbourhoodsCleaned.rds")
st_write(tor_hood, "large/TorontoNeighbourhoodsCleaned.gpkg", driver = "GPKG")

## Vancouver
# select neighbourhood name and geometry from hood dataset
van_hood <- van_hood_raw %>% select(c("name","geometry"))%>%
  rename(hood = "name") %>%
  mutate(city = c("Vancouver"))
# transform
van_hood <- st_transform(van_hood,crs = 6624)
# save
saveRDS(van_hood, "large/VancouverNeighbourhoodsCleaned.rds")
st_write(van_hood, "large/VancouverNeighbourhoodsCleaned.gpkg", driver = "GPKG")

## Winnipeg
# rename neighbourhood name column
win_hood <- win_hood_raw %>% select(c("name","geometry")) %>%
  rename(hood = "name") %>%
  mutate(city = c("Winnipeg"))
# transform
win_hood <- st_transform(win_hood,crs = 6624)
# save
saveRDS(win_hood, "large/WinnipegNeighbourhoodsCleaned.rds")
st_write(win_hood, "large/WinnipegNeighbourhoodsCleaned.gpkg", driver = "GPKG")

## Combine all neighbourhoods of all cities
can_hood <- rbind(cal_hood, hal_hood, mon_hood, ott_hood, tor_hood, van_hood, win_hood)
# save
saveRDS(can_hood, "large/AllNeighbourhoodsCleaned.rds")
st_write(can_hood, "large/AllNeighbourhoodsCleaned.gpkg", driver = "GPKG")