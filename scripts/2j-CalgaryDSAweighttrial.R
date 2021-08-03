library(mapview)

#### Data ####
# Cleaned Calgary Neighbourhood boundary data
cal_hood <- read_sf("large/CalgaryHoodCleaned.shp")
# Cleaned Dissemination Area Boundaries
dsa_bound <- readRDS("large/DSACleaned.rds")
# 2016  Census survey data
can_cen_wide <- read.RDS("large/CensusWideCleaned.rds")
# Calgary Tree data
cal_tree <- readRDS("large/CalgaryTreesCleaned.rds")

tor_hood_raw <- read_sf("large/tor_hood_raw/Neighbourhoods.shp")
# select neighbourhood name and geometry from hood dataset
tor_hood <- tor_hood_raw %>% 
  select(c("FIELD_8", "geometry")) %>% 
  rename("hood" = "FIELD_8")
# transform to EPSG: 6624 to be consistent with other layers
tor_hood <- st_transform(tor_hood, crs = 6624)



#### Spatially join cal_hood with Dissemination Areas
cal_hood_cen <- st_intersection(can_cen_wide,cal_hood, left= FALSE)
View(cal_hood_dsa)

cal_hood_dsa <- st_intersection(st_make_valid(dsa_bound),cal_hood)


View(cal_hood_dsa)


#### Spatially join tor_hood with Dissemination Areas
tor_hood_cen <- st_intersection(can_cen_wide,tor_hood, left= FALSE)
View(cal_hood_dsa)

cbind(cal_hood_dsa[c('dsa', 'totpop')], area = st_area(cal_hood_dsa)) %>%
  mutate(weight = as.numeric(area / sum(area))) %>%
  arrange(desc(weight))

mapview(can_cen_wide)
mapview(cal_hood)


can_cen_raw[,can_cen_raw$GEO_CODE..POR.==48060764]

head(cal_hood_dsa)
str(can_cen_raw)


huh <- can_cen_raw %>% filter(GEO_CODE..POR.== mon_hood_dsa$dsa)


mon_hood_raw<- read_sf("large/mon_hood_raw/LIMADMIN.shp")
head(mon_hood_raw)
mon_hood <- mon_hood_raw %>% select(c("NOM","geometry"))
mon_hood <- st_transform(mon_hood,crs = 6624)
mon_hood_dsa <- st_intersection(dsa_bound,mon_hood, left= FALSE)

can_cen_wide
