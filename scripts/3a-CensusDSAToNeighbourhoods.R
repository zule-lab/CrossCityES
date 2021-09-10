# Script to spatially weigh census data by dissemination areas into neighbourhoods
# Author: Nicole Yu & Isabella Richmond

#### PACKAGES ####
p <- c("sf", "dplyr")
lapply(p, library, character.only = T)


#### DATA ####
# Cleaned Neighbourhood boundary data
can_hood <- readRDS("large/neighbourhoods/AllNeighbourhoodsCleaned.rds")
# Cleaned 2016 Census survey data with spatial coordinates 
can_cen <- readRDS("large/national/CensusDSACleaned.rds")

#### SPATIALLY WEIGHTED JOIN ####
## Use a spatially weighted join to get the mean values of each dissemination area within each neighbourhood
# find all the DSAs that intersect with each neighbourhood
hood_cen <- st_intersection(can_hood, can_cen)
# calculate the area of each DSA, weight of each DSA, and the weighted mean
can_hood_cen <- hood_cen %>%
  select(c("dsa","city","hood","totpop","opdwel","sideho","aptfiv","oadwel","semhou","rowhou","aptdup","aptbui","otsiho","mvdwel",
           "totpri","prione","pritwo","prithr","prifou","prifiv","numper","avhosi","medtax","medemp","empinc")) %>%
  group_by(hood) %>% 
  mutate(area = st_area(geometry)) %>% 
  mutate(weight = as.numeric(area / sum(area))) %>%
  mutate(wmean = weighted.mean(as.numeric(totpop), as.numeric(area)))
# make new dataset with one entry per neighbourhood 
can_hood_sum <- can_hood_cen %>%
  dplyr::group_by(hood) %>%   
  mutate(DSAcount = n(),
         weight = sum(weight),
         area = sum(area),
         dsa = list(dsa),
         totpop = sum(as.numeric(totpop)),
         opdwel = mean(as.numeric(opdwel)),
         sideho = mean(as.numeric(sideho)),
         aptfiv = mean(as.numeric(aptfiv)),
         oadwel = mean(as.numeric(oadwel)),
         semhou = mean(as.numeric(semhou)),
         rowhou = mean(as.numeric(rowhou)),
         aptdup = mean(as.numeric(aptdup)),
         aptbui = mean(as.numeric(aptbui)),
         otsiho = mean(as.numeric(otsiho)),
         mvdwel = mean(as.numeric(mvdwel)),
         totpri = mean(as.numeric(totpri)),
         prione = mean(as.numeric(prione)),
         pritwo = mean(as.numeric(pritwo)),
         prithr = mean(as.numeric(prithr)),
         prifou = mean(as.numeric(prifou)),
         prifiv = mean(as.numeric(prifiv)),
         numper = mean(as.numeric(numper)),
         avhosi = mean(as.numeric(avhosi)),
         medtax = median(as.numeric(medtax)),
         medemp = median(as.numeric(medemp)),
         empinc = median(as.numeric(empinc))) %>%
  distinct(hood, .keep_all = TRUE)
# save
saveRDS(can_hood_sum, "large/national/NeighbourhoodsCensusSum.rds")
st_write(can_hood_sum, "large/national/NeighbourhoodsCensusSum.gpkg", driver = "GPKG")
