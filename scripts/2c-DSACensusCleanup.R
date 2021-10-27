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
  filter(sofac %in% c(1, 6:7, 41:50, 665, 857, 1149, 1290, 1324, 1692))
# pivot to wide format
can_cen_wide <- can_cen %>% pivot_wider(names_from = sofac, values_from = sonum)
# rename columns
can_cen_wide <- can_cen_wide %>%
  rename(totpop = "1") %>%
  rename(popdens = "6") %>%
  rename(area = "7") %>%
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
  rename(medinc = "665") %>%
  rename(lowinc = "857") %>%
  rename(recimm = "1149") %>%
  rename(aborig = "1290") %>%
  rename(vismin = "1324") %>%
  rename(edubac = "1692")
# match dissemination area to boundary polygon
can_cen_dsa<- merge(can_cen_wide, dsa_bound, by = "dsa")
# transform to sf object
can_cen_dsa <- st_as_sf(can_cen_dsa, sf_column_name = c("geometry"), crs = 3347)
# change x, F to NA 
can_cen_dsa<- can_cen_dsa %>% mutate(across(c(2:20), ~na_if(., "x")))
can_cen_dsa<- can_cen_dsa %>% mutate(across(c(2:20), ~na_if(., "F")))
# transform to factor for DSAs and numeric for values
can_cen_dsa$dsa <- as.factor(can_cen_dsa$dsa)
can_cen_dsa<- can_cen_dsa %>% mutate(across(c(2:20), ~as.numeric(.)))
can_cen_dsa <- drop_na(can_cen_dsa)

# 41 = Total - Occupied private dwellings by structural type of dwelling - 100% data (7)
# 42 = Single-detached house
# 43 = Apartment in a building that has five or more storeys
# 44 = Other attached dwelling (8)
# 45 = Semi-detached house
# 46 = Row house
# 47 = Apartment or flat in a duplex
# 48 = Apartment in a building that has fewer than five storeys
# 49 = Other single-attached house
# 50 = Movable dwelling (9)
# 665 = Median after-tax income in 2015 among recipients 
# 857 = Prevalence of low income based on the Low-income measure, after tax (LIM-AT) (%)
# 1149 = Total - Immigrant status and period of immigration for the population in private households - 25% sample data (63) -> Immigrants -> 2011-2016 (recent immigrants)
# 1290 = Total - Aboriginal identity for the population in private households - 25% sample data (104) -> Aboriginal identity (105)
# 1324 = Total - Visible minority for the population in private households - 25% sample data (121) -> Total visible minority population (122)
# 1692 = Total - Highest certificate, diploma or degree for the population aged 15 years and over in private households - 25% sample data (178) -> University certificate, diploma or degree at bachelor level or above
# we want percentages for all datasets except median income - need to transform 41:50, 1149, 1290, 1324, 1692
# start with dwelling types
setDT(can_cen_dsa)
can_cen_dsa <- can_cen_dsa[, c(paste0(names(can_cen_dsa[,6:14]), "p")) := lapply(.SD, function(x) x / sum(.SD)), by=1:nrow(can_cen_dsa), .SDcols = c(6:14)]
# population percentages 
can_cen_dsa <- can_cen_dsa[ , c(paste0(names(can_cen_dsa[,17:20]), "p")) := lapply(.SD, function(x) x/totpop), .SDcols = 17:20]

# save
saveRDS(can_cen_dsa, "large/national/CensusDSACleaned.rds")
