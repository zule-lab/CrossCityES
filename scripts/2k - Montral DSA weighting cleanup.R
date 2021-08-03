rm(list=ls())

#### Data ####
# Montreal tree data
mon_tree <- readRDS("large/MontrealTreesCleaned.rds")
# Montreal Neighbourhood boundary data
mon_hood <- readRDS("large/MontrealNeighbourhoodsCleaned.rds")
# Cleaned Dissemination Area Boundaries
dsa_bound <- readRDS("large/DSACleaned.rds")
# 2016  Census survey data
can_cen_dsa <- readRDS("large/CensusDSACleaned.rds")

## Calculating weighted mean
# Need the dsa areas with the census variables -> can_cen_dsa
# need the tree info with the neighbourhoods
# need to have an object containing values needed for weighted mean + 
# numerical vector of weights the same length as x

# joining montreal data with neighbourhood
mon_tree_hood <- st_join(mon_tree,mon_hood, left=FALSE)
# 
mon_tree_dsa <- st_join(mon_tree_hood,can_cen_dsa, left=FALSE)
#
mon_hood_dsa <- st_intersection(mon_tree_dsa,mon_hood left= FALSE)

mon_swmtrial <- cbind(mon_hood_dsa[c('hood.y', 'totpop')], area = st_area(mon_hood_dsa)) %>%
  mutate(weight = as.numeric(area / sum(area))) %>%
  arrange(desc(weight))

weighted.mean(mon_hood_dsa$totpop, as.numeric(st_area(mon_hood_dsa)))

?weighted.mean
