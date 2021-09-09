# Script to cleanup Canada Dissemination Areas and census data
# Author: Nicole Yu & Isabella Richmond

#### PACKAGES ####
p <- c("sf", "dplyr", "tidyr", "data.table")
lapply(p, library, character.only = T)

#### DATA ####
# Municipal boundaries
can_bound <- readRDS("large/national/MunicipalBoundariesCleaned.rds")
# Dissemination Area (DSA) boundaries
dsa_bound_raw <- st_read(file.path("/vsizip", "large/national/dsa_bound_raw.zip"))
# 2016 Census survey data
can_cen_raw <- fread(cmd = 'unzip -p large/national/can_cen_raw.zip 98-401-X2016044_English_CSV_data.csv')

#### CLEANUP ####
## DSA Boundaries
dsa_bound <- dsa_bound_raw %>%
  select(c("DAUID","PRNAME","geometry")) %>%
  rename(dsa = "DAUID") %>%
  rename(province = "PRNAME")
dsa_bound <- st_transform(dsa_bound, crs = 3347)
dsa_bound <- dsa_bound[can_bound,]
saveRDS(dsa_bound, "large/national/DSACleaned.rds")

## Census survey data
# refer to large/national/can_cen_raw.zip/98-401-X2016044_English_meta.txt for variable names
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
can_cen_dsa <- st_as_sf(can_cen_dsa, sf_column_name = c("geometry"), crs = 3347)
# save
saveRDS(can_cen_dsa, "large/national/CensusDSACleaned.rds")
