targets_census_cleanup <- c(
  
  # Download 
  tar_eval(
    tar_target(
      file_name_sym,
      download_shp(dl_link, dl_path)
    ),
    values = values_census
  ),
  
  # Clean
  tar_target(
    da_s,
    dsa_bound_raw %>%
      select(c("DAUID", "geometry")) %>%
      rename(da = "DAUID") %>%
      st_transform(crs = 3347)
  ),
  
  tar_target(
    da_bound, 
    da_s[mun_bound,]
  ),
  
  tar_target(
    census_da_raw_full,
    combine_files("large/national/cen_da_raw.zip", 5, "large/national/cen_da_raw")
  ),
  
  tar_target(
    census_da_f,
    census_da_raw_full %>%
      select(c("ALT_GEO_CODE","CHARACTERISTIC_ID","C1_COUNT_TOTAL")) %>%
      rename(da = "ALT_GEO_CODE",
             sofac = "CHARACTERISTIC_ID",
             sonum = "C1_COUNT_TOTAL") %>%
      filter(sofac %in% c(1, 6:7, 42:49, 115, 331, 1522, 1389, 1670)) # missing education right now
  ),
  
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
  # 331 = Prevalence of low income based on the Low-income measure, after tax (LIM-AT) (%)
  # 1522 = Total - Immigrant status and period of immigration for the population in private households - 25% sample data (63) -> Immigrants -> 2011-2016 (recent immigrants)
  # 1389 = Total - Aboriginal identity for the population in private households - 25% sample data (104) -> Aboriginal identity (105)
  # 1670 = Total - Visible minority for the population in private households - 25% sample data (121) -> Total visible minority population (122)
  # we want percentages for all datasets except median income - need to transform 41:50, 1149, 1290, 1324, 1692
  # start with dwelling types

  
  tar_target(
    census_da_w,
    census_da_f %>% pivot_wider(names_from = sofac, values_from = sonum)
  ),
  
  tar_target(
    census_cma_w, 
    census_cma_f %>% pivot_wider(names_from = sofac, values_from = sonum)
  ),
  
  tar_target(
    census_da_r,
    census_da_w %>%
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
      rename(lowinc = "331") %>%
      rename(recimm = "1522") %>%
      rename(aborig = "1389") %>%
      rename(vismin = "1670") 
    #rename(edubac = "1692")
  ),
  
  tar_target(
    census_da_m,
    merge(census_da_r, da_bound, by = "da")
  ),
  
  tar_target(
    census_da_sf,
    st_as_sf(census_da_m, sf_column_name = c("geometry"), crs = 3347)
  ),
  
  tar_target(
    census_da_na,
    census_da_sf %>% mutate(across(c(2:17), ~na_if(., "x")),
                            across(c(2:17), ~na_if(., "F")))
  ),

  
  tar_target(
    census_da_num, 
    census_da_na %>% 
      mutate(da = as.factor(da)) %>%
      mutate(across(c(2:17), ~as.numeric(.))) %>%
      drop_na()
  ),
  
  
  tar_target(
    census_da_dt, 
    setDT(census_da_num)
  ),
  
  
  
  tar_target(
    census_da,
    calculate_percent(census_da_dt)
  )

  
)