clean_census_da <- function(x, n, o, da_bound){
  
  # combine 5 separated census files that are in zipped folder
  l <- as.character(unzip(x, list = T)$Name)
  
  l <- l[1:n]
  
  data <- lapply(l, function(y) read.csv((unzip(x, y, exdir = o)))) %>%
    bind_rows()
  
  census_da_f <- data %>%
    select(c("ALT_GEO_CODE","CHARACTERISTIC_ID","C1_COUNT_TOTAL")) %>%
    rename(da = "ALT_GEO_CODE",
           sofac = "CHARACTERISTIC_ID",
           sonum = "C1_COUNT_TOTAL") %>%
    filter(sofac %in% c(1, 6:7, 42:49, 115, 345, 1527, 1402, 1683, 2014)) 
  
  # 1 = Population 2021
  # 6 = Pop density per sq km
  # 7 = Land area sq km
  # 41 = Total - Occupied private dwellings by structural type of dwelling - 100% data (7)
  # 42 = Single-detached house
  # 43 = Semi-detached house
  # 44 = Row house
  # 45 = Apartment or flat in a duplex
  # 46 = Apartment in a building that has fewer than five storeys
  # 47 = Apartment in a building that has five or more storeys
  # 48 = Other single-attached house
  # 49 = Movable dwelling (9)
  # 115 = Median after-tax income in 2015 among recipients 
  # 345 = Prevalence of low income based on the Low-income measure, after tax (LIM-AT) (%)
  # 1527 = Total - Immigrant status and period of immigration for the population in private households - 25% sample data (63) -> Immigrants -> 2011-2016 (recent immigrants)
  # 1402 = Total - Indigenous identity for the population in private households - 25% sample data (104) -> Aboriginal identity (105)
  # 1683 = Total - Visible minority for the population in private households - 25% sample data (121) -> Total visible minority population (122)
  # 2014 = Total - Highest certificate, diploma or degree for the population aged 25 to 64 years in private households - 25% sample data (165)
  # we want percentages for all datasets except median income - need to transform 41:49, 1527, 1402, 1683, 2014
  # start with dwelling types
  
  census_da_w <- census_da_f %>% pivot_wider(names_from = sofac, values_from = sonum)
  
  census_da_r <- census_da_w %>%
    rename(totpop = "1") %>%
    rename(popdens = "6") %>%
    rename(area = "7") %>%
    rename(sideho = "42") %>%
    rename(semhou = "43") %>%
    rename(rowhou = "44") %>%
    rename(aptdup = "45") %>%
    rename(aptbui = "46") %>%
    rename(aptfiv = "47") %>%
    rename(otsiho = "48") %>%
    rename(mvdwel = "49") %>%
    rename(medinc = "115") %>%
    rename(lowinc = "345") %>%
    rename(recimm = "1527") %>%
    rename(indig = "1403") %>%
    rename(vismin = "1684") %>%
    rename(edubac = "2024")
  
  census_da_m <- merge(census_da_r, da_bound, by = "da")
  
  census_da_sf <- st_as_sf(census_da_m, sf_column_name = c("geometry"), crs = 3347)
  
  census_da_na <- census_da_sf %>% mutate(across(c(totpop:edubac), ~na_if(., "x")),
                          across(c(totpop:edubac), ~na_if(., "F")))
  
  census_da_num <- census_da_na %>% 
    mutate(da = as.factor(da)) %>%
    mutate(across(c(totpop:edubac), ~as.numeric(.))) %>%
    drop_na()
  
  can_cen <- setDT(census_da_num)
  
  can_cen_p <- can_cen[, c(paste0(names(can_cen[,c('sideho', 'semhou', 'rowhou', 'aptdup', 'aptbui', 'aptfiv', 'otsiho', 'mvdwel')]), "p")) := lapply(.SD, function(x) x / sum(.SD)), by=1:nrow(can_cen), .SDcols = c('sideho', 'semhou', 'rowhou', 'aptdup', 'aptbui', 'aptfiv', 'otsiho', 'mvdwel')]
  
  ## population percentages 
  can_cen_pp <- can_cen_p[ , c(paste0(names(can_cen_p[,c('recimm', 'indig', 'vismin', 'edubac')]), "p")) := lapply(.SD, function(x) x/totpop), .SDcols = c('recimm', 'indig', 'vismin', 'edubac')]
  
  return(can_cen)
  
}