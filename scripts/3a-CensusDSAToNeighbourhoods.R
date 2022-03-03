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
can_cen <- st_as_sf(can_cen)

#### SPATIALLY WEIGHTED JOIN ####
## Use a spatially weighted join to get the mean values of each dissemination area within each neighbourhood
# find all the DSAs that intersect with each neighbourhood
hood_cen <- st_intersection(can_hood, can_cen)
# calculate the area of each DSA, weight of each DSA, and the weighted mean
can_hood_cen <- hood_cen %>%
  select(c("city","hood","hood_id","dsa","totpop","popdens", "area", "sidehop","aptfivp","oadwelp","semhoup","rowhoup","aptdupp","aptbuip","otsihop","mvdwelp",
           "medinc", "lowinc", "recimmp", "aborigp", "visminp", "edubacp")) %>%
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
         popdens = mean(as.numeric(popdens)),
         sidehop = mean(as.numeric(sidehop)),
         aptfivp = mean(as.numeric(aptfivp)),
         oadwelp = mean(as.numeric(oadwelp)),
         semhoup = mean(as.numeric(semhoup)),
         rowhoup = mean(as.numeric(rowhoup)),
         aptdupp = mean(as.numeric(aptdupp)),
         aptbuip = mean(as.numeric(aptbuip)),
         otsihop = mean(as.numeric(otsihop)),
         mvdwelp = mean(as.numeric(mvdwelp)),
         medinc = mean(as.numeric(medinc)),
         lowinc = mean(as.numeric(lowinc)),
         recimmp = mean(as.numeric(recimmp)),
         aborigp = mean(as.numeric(aborigp)),
         visminp = mean(as.numeric(visminp)),
         edubacp = mean(as.numeric(edubacp))
  ) %>%
  distinct(hood, .keep_all = TRUE)
# save
saveRDS(can_hood_sum, "large/national/NeighbourhoodsCensusSum.rds")
st_write(can_hood_sum, "large/national/NeighbourhoodsCensusSum.gpkg", driver = "GPKG")
