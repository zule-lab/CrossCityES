# Script to spatially weigh census data by dissemination areas into neighbourhoods
# Author: Nicole Yu & Isabella Richmond

#### Packages ####
easypackages::packages("tidyverse","sf")

#### Data ####
# Cleaned Neighbourhood boundary data
can_hood <- readRDS("large/AllNeighbourhoodsCleaned.rds")
# Cleaned 2016 Census survey data with spatial coordinates 
can_cen <- readRDS("large/CensusDSACleaned.rds")

#### Spatially weighted join ####
## Use a spatially weighted join to get the mean values of each dissemination area within each Calgary neighbourhood
# find all the DSAs that intersect with each neighbourhood
hood_cen <- st_intersection(can_hood, can_cen)
 # calculate the area of each DSA, weight of each DSA, and the weighted mean
can_hood_cen <- can_hood_cen %>%
  select(c("dsa","city","hood","totpop","opdwel","sideho","aptfiv","oadwel","semhou","rowhou","aptdup","aptbui","otsiho","mvdwel",
           "totpri","prione","pritwo","prithr","prifou","prifiv","numper","avhosi","medtax","medemp","empinc")) %>%
  group_by(hood) %>% 
  mutate(area = st_area(geometry)) %>% 
  mutate(weight = as.numeric(area / sum(area))) %>%
  mutate(wmean = weighted.mean(as.numeric(totpop), as.numeric(area)))
# make new dataset with one entry per neighbourhood 
can_hood_sum <- can_hood_cen %>%
  group_by(hood) %>% 
  mutate(DSAcount = n()) %>%
  mutate(weight = sum(weight)) %>%
  mutate(area = sum(area)) %>%
  mutate(dsa = list(dsa)) %>% 
  mutate(totpop = sum(as.numeric(totpop))) %>%
  mutate(opdwel = mean(as.numeric(opdwel))) %>%
  mutate(sideho = mean(as.numeric(sideho))) %>%
  mutate(aptfiv = mean(as.numeric(aptfiv))) %>%
  mutate(oadwel = mean(as.numeric(oadwel))) %>%
  mutate(semhou = mean(as.numeric(semhou))) %>%
  mutate(rowhou = mean(as.numeric(rowhou))) %>%
  mutate(aptdup = mean(as.numeric(aptdup))) %>%
  mutate(aptbui = mean(as.numeric(aptbui))) %>%
  mutate(otsiho = mean(as.numeric(otsiho))) %>%
  mutate(mvdwel = mean(as.numeric(mvdwel))) %>%
  mutate(totpri = mean(as.numeric(totpri))) %>%
  mutate(prione = mean(as.numeric(prione))) %>%
  mutate(pritwo = mean(as.numeric(pritwo))) %>%
  mutate(prithr = mean(as.numeric(prithr))) %>%
  mutate(prifou = mean(as.numeric(prifou))) %>%
  mutate(prifiv = mean(as.numeric(prifiv))) %>%
  mutate(numper = mean(as.numeric(numper))) %>%
  mutate(avhosi = mean(as.numeric(avhosi))) %>%
  mutate(medtax = median(as.numeric(medtax))) %>%
  mutate(medemp = median(as.numeric(medemp))) %>%
  mutate(empinc = median(as.numeric(empinc))) %>%
  distinct(hood, .keep_all = TRUE)
# save
saveRDS(can_hood_sum, "large/NeighbourhoodsCensusSum.rds")
st_write(can_hood_sum, "large/NeighbourhoodsCensusSum.gpkg", driver = "GPKG")
