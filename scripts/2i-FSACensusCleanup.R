# Script to cleanup Canada Dissemination Areas and census data
# Author: Nicole Yu & Isabella Richmond

#### Packages ####
easypackages::packages("tidyverse","sf")

#### Data ####
# Cleaned canada boundary data
can_bound <- readRDS("large/MunicipalBoundariesCleaned.rds")
# Forward sortation area boundaries
dsa_bound_raw <- read_sf("large/dsa_bound_raw/lda_000b16a_e.shp")
# 2016  Census survey data
can_cen_raw <- read.csv("large/can_cen_raw/98-401-X2016044_English_CSV_data.csv")

#### Cleanup ####
## Dissemination Area boundaries
# select relevant columns and rename 
dsa_bound <- dsa_bound_raw %>%
  select(c("DAUID","PRNAME","geometry")) %>%
  rename(dsa = "DAUID") %>%
  rename(province = "PRNAME")
# transform 
dsa_bound <- st_transform(dsa_bound, crs = 6624)
# intersect with municipal boundaries
dsa_bound <- dsa_bound[can_bound,]
# save
saveRDS(dsa_bound, "large/DSACleaned.rds")

## Census survey data
#  select relevant columns and rows
can_cen <- can_cen_raw %>%
  select(c("GEO_CODE..POR.","DIM..Profile.of.Dissemination.Areas..2247.","Dim..Sex..3...Member.ID...1...Total...Sex")) %>%
  rename(dsa = "GEO_CODE..POR.") %>%
  rename(sofac = "DIM..Profile.of.Dissemination.Areas..2247.") %>%
  rename(sonum = "Dim..Sex..3...Member.ID...1...Total...Sex") %>%
  filter(sofac %in% c("Population, 2016","Total - Occupied private dwellings by structural type of dwelling - 100% data","Single-detached house","Apartment in a building that has five or more storeys","Other attached dwelling","Semi-detached house","Row house","Apartment or flat in a duplex","Apartment in a building that has fewer than five storeys","Other single-attached house","Movable dwelling","Total - Private households by household size - 100% data","1 person","2 persons","3 persons","4 persons","5 or more persons","Number of persons in private households","Average household size","Employment income (%)","Median employment income in 2015 for full-year full-time workers ($)","Median after-tax income in 2015 among recipients ($)"))
# pivot to wide format
can_cen_wide <- can_cen %>% pivot_wider(names_from = sofac, values_from = sonum)
# rename columns
can_cen_wide <- can_cen_wide %>%
  rename(totpop = "Population, 2016") %>%
  rename(opdwel =  "Total - Occupied private dwellings by structural type of dwelling - 100% data") %>%
  rename(sideho = "Single-detached house") %>%
  rename(aptfiv ="Apartment in a building that has five or more storeys") %>%
  rename(oadwel = "Other attached dwelling") %>%
  rename(semhou = "Semi-detached house") %>%
  rename(rowhou = "Row house") %>%
  rename(aptdup = "Apartment or flat in a duplex") %>%
  rename(aptbui = "Apartment in a building that has fewer than five storeys") %>%
  rename(otsiho = "Other single-attached house") %>%
  rename(mvdwel = "Movable dwelling") %>%
  rename(totpri = "Total - Private households by household size - 100% data") %>%
  rename(prione = "1 person") %>%
  rename(pritwo = "2 persons") %>%
  rename(prithr = "3 persons") %>%
  rename(prifou = "4 persons") %>%
  rename(prifiv = "5 or more persons") %>%
  rename(numper = "Number of persons in private households") %>%
  rename(avhosi = "Average household size") %>%
  rename(empinc = "Employment income (%)") %>%
  rename(medemp = "Median employment income in 2015 for full-year full-time workers ($)") %>%
  rename(medtax = "Median after-tax income in 2015 among recipients ($)")
# match dissemination area to boundary polygon
can_cen_dsa<- merge(can_cen_wide, dsa_bound, by = "dsa")
# transform to sf object
can_cen_dsa <- st_as_sf(can_cen_dsa, sf_column_name = c("geometry"), crs = 6624)

# save to large first, though only 1.5MB
saveRDS(can_cen_dsa, "large/CensusDSACleaned.rds")
# not working
write_csv(can_cen_dsa, "large/CensusDSACleaned.csv")

