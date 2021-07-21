# Script to cleanup Canada forward sortation areas and census data
# Author: Nicole Yu & Isabella Richmond

#### Packages ####
easypackages::packages("tidyverse","sf")

#### Data ####
# Cleaned canada boundary data
can_bound <- readRDS("large/MunicipalBoundariesCleaned.rds")
# Forward sortation area boundaries
fsa_bound_raw <- read_sf("large/fsa_bound_raw/lfsa000b16a_e.shp")
# 2016  Census survey data
can_cen_raw <- read.csv("input/can_cen_raw/98-401-X2016046_English_CSV_data.csv")

#### Cleanup ####
## Forward sortation area boundaries
# select relevant columns and rename 
fsa_bound <- fsa_bound_raw %>%
  select(c("CFSAUID", "geometry")) %>%
  rename("fsa" = "CFSAUID")
# transform 
fsa_bound <- st_transform(fsa_bound, crs = 6624)
# intersect with municipal boundaries
fsa_bound <- fsa_bound[can_bound,]
# save
saveRDS(fsa_bound, "large/FSACleaned.rds")

## Census survey data
#  select relevant columns and rows
can_cen <- can_cen_raw %>%
  select(c("GEO_CODE..POR.","DIM..Profile.of.Forward.Sortation.Areas..2247.","Member.ID..Profile.of.Forward.Sortation.Areas..2247.","Dim..Sex..3...Member.ID...1...Total...Sex")) %>%
  rename(fsa = "GEO_CODE..POR.") %>%
  rename(sofac = "DIM..Profile.of.Forward.Sortation.Areas..2247.") %>%
  rename(soid = "Member.ID..Profile.of.Forward.Sortation.Areas..2247.") %>%
  rename(sonum = "Dim..Sex..3...Member.ID...1...Total...Sex") %>%
  filter(soid %in% c(1,41:58,689,665,685))
# alternatively, filter(sofac %in% c("Population, 2016","Total - Occupied private dwellings by structural type of dwelling - 100% data","Single-detached house","Apartment in a building that has five or more storeys","Other attached dwelling","Semi-detached house","Row house","Apartment or flat in a duplex","Apartment in a building that has fewer than five storeys","Other single-attached house","Movable dwelling","Total - Private households by household size - 100% data","1 person","2 persons","3 persons","4 persons","5 or more persons","Number of persons in private households","Average household size","Employment income (%)","Median employment income in 2015 for full-year full-time workers ($)","Median after-tax income in 2015 among recipients ($)"))
# save to large first, though only 1.5MB
saveRDS(can_cen, "large/CensusCleaned.rds")
write_csv(can_cen, "large/CensusCleaned.csv")
