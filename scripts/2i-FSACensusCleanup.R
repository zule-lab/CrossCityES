# Script to cleanup Canada Dissemination Areas and census data
# Author: Nicole Yu & Isabella Richmond

#### Packages ####
easypackages::packages("tidyverse","sf","data.table", "bit64")
install.packages("data.table")

#### Data ####
# Cleaned canada boundary data
can_bound <- readRDS("large/MunicipalBoundariesCleaned.rds")
# Forward sortation area boundaries
dsa_bound_raw <- read_sf("large/dsa_bound_raw/lda_000b16a_e.shp")
# 2016  Census survey data
can_cen_raw <- fread("large/can_cen_raw/98-401-X2016044_English_CSV_data.csv")

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
# select relevant columns and rows
# census data for Population 2016, total occupied private dwellings, types of dwellings, 
# total private households by size, number of people in private households, average household size
# emploment income, median employment income, and median after-tax income in 2015 among recipients
can_cen <- can_cen_raw %>%
  select(c("GEO_CODE (POR)","Member ID: Profile of Dissemination Areas (2247)","Dim: Sex (3): Member ID: [1]: Total - Sex")) %>%
  rename(dsa = "GEO_CODE (POR)") %>%
  rename(sofac = "Member ID: Profile of Dissemination Areas (2247)") %>%
  rename(sonum = "Dim: Sex (3): Member ID: [1]: Total - Sex") %>%
  filter(sofac %in% c(1, 41:58, 665, 685, 689))
# pivot to wide format
can_cen_wide <- can_cen %>% pivot_wider(names_from = sofac, values_from = sonum)
# rename columns
can_cen_wide <- can_cen_wide %>%
  rename(totpop = "1") %>%
  rename(opdwel = "41") %>%
  rename(sideho = "42") %>%
  rename(aptfiv = "43") %>%
  rename(oadwel = "44") %>%
  rename(semhou = "45") %>%
  rename(rowhou = "46") %>%
  rename(aptdup = "47") %>%
  rename(aptbui = "48") %>%
  rename(otsiho = "49") %>%
  rename(mvdwel = "50") %>%
  rename(totpri = "51") %>%
  rename(prione = "52") %>%
  rename(pritwo = "53") %>%
  rename(prithr = "54") %>%
  rename(prifou = "55") %>%
  rename(prifiv = "56") %>%
  rename(numper = "57") %>%
  rename(avhosi = "58") %>%
  rename(medtax = "665") %>%
  rename(medemp = "685") %>%
  rename(empinc = "689")
# match dissemination area to boundary polygon
can_cen_dsa<- merge(can_cen_wide, dsa_bound, by = "dsa")
# transform to sf object
can_cen_dsa <- st_as_sf(can_cen_dsa, sf_column_name = c("geometry"), crs = 6624)

# save to large first, though only 1.5MB
saveRDS(can_cen_dsa, "large/CensusDSACleaned.rds")
# not working
write_csv(can_cen_dsa, "large/CensusDSACleaned.csv")

