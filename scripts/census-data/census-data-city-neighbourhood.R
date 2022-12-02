census_data_neighbourhood <- c(
  
  tar_target(
    hood_cen_i,
    st_intersection(can_hood, st_as_sf(census_da))
  ),
  
  tar_target(
    city_cen,
    st_intersection(mun_bound, st_as_sf(census_cma))
  ),
  
  tar_target(
    # spatially weighted join
    hood_cen_swj,
    hood_cen_i %>%
      select(c("city","hood","hood_id","da","totpop","popdens", "area", "sidehop","aptfivp","semhoup","rowhoup","aptdupp","aptbuip","otsihop","mvdwelp",
               "medinc", "lowinc", "recimmp", "aborigp", "visminp")) %>%
      group_by(hood) %>% 
      mutate(area = st_area(geometry)) %>% 
      mutate(weight = as.numeric(area / sum(area))) %>%
      mutate(wmean = weighted.mean(as.numeric(totpop), as.numeric(area)))
  ),
  
  tar_target(
    hood_cen,
    hood_cen_swj %>%
      group_by(hood) %>%   
      mutate(DSAcount = n(),
             weight = sum(weight),
             area = sum(area),
             da = list(da),
             geometry = st_union(geometry),
             totpop = sum(as.numeric(totpop)),
             popdens = mean(as.numeric(popdens)),
             sidehop = mean(as.numeric(sidehop)),
             aptfivp = mean(as.numeric(aptfivp)),
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
             visminp = mean(as.numeric(visminp)) #,
             #edubacp = mean(as.numeric(edubacp))
      ) %>%
      distinct(hood, .keep_all = TRUE)
  )
)