census_data_cleanup <- c(
  
  tar_target(
    DA_s,
    DA_raw %>%
      select(c("DAUID","PRNAME","geometry")) %>%
      rename(dsa = "DAUID") %>%
      rename(province = "PRNAME") %>%
      st_transform(crs = 3347)
  ),
  
  tar_target(
    DA_bound, 
    DA_s[mun_bound,]
  ),
  
  tar_target(
    census_f,
    census_raw %>%
      select(c("GEO_CODE (POR)","Member ID: Profile of Dissemination Areas (2247)","Dim: Sex (3): Member ID: [1]: Total - Sex")) %>%
      rename(dsa = "GEO_CODE (POR)") %>%
      rename(sofac = "Member ID: Profile of Dissemination Areas (2247)") %>%
      rename(sonum = "Dim: Sex (3): Member ID: [1]: Total - Sex") %>%
      filter(sofac %in% c(1, 6:7, 42:50, 665, 857, 1149, 1290, 1324, 1692))
  ),
  
  tar_target(
    census_w,
    census_f %>% pivot_wider(names_from = sofac, values_from = sonum)
  ),
  
  tar_target(
    census_r,
    census_w %>%
      rename(totpop = "1") %>%
      rename(popdens = "6") %>%
      rename(area = "7") %>%
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
  ),
  
  tar_target(
    census_DA_m,
    merge(census_r, DA_bound, by = "dsa")
  ),
  
  tar_target(
    census_DA_sf,
    st_as_sf(census_DA_m, sf_column_name = c("geometry"), crs = 3347)
  ),
  
  tar_target(
    census_DA_na,
    census_DA_sf %>% mutate(across(c(2:20), ~na_if(., "x")),
                            across(c(2:20), ~na_if(., "F")))
  ),
  
  tar_target(
    census_DA_num, 
    census_DA_na %>% 
      mutate(dsa = as.factor(dsa)) %>%
      mutate(across(c(2:19), ~as.numeric(.))) %>%
      drop_na()
  ),
  
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
  
  tar_target(
    census_dt, 
    setDT(census_DA_num)
  ),
  
  tar_target(
    census,
    calculate_percent(census_dt)
  )
  
)