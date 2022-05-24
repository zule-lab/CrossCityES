census_data_neighbourhood <- c(
  
  tar_target(
    hood_cen_i,
    st_intersection(can_hood, census)
  ),
  
  tar_target(
    # spatially weighted join
    hood_cen_swj,
    hood_cen_i %>%
      select(c("city","hood","hood_id","dsa","totpop","popdens", "area", "sidehop","aptfivp","oadwelp","semhoup","rowhoup","aptdupp","aptbuip","otsihop","mvdwelp",
               "medinc", "lowinc", "recimmp", "aborigp", "visminp", "edubacp")) %>%
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
             dsa = list(dsa),
             totpop = sum(as.numeric(totpop)),
             popdens = mean(as.numeric(popdens)),
             sidehop = mean(as.numeric(sidehop)),
             aptfivp = mean(as.numeric(aptfivp)),
             oadwelp = mean(as.numeric(oadwelp)),
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
             visminp = mean(as.numeric(visminp)),
             edubacp = mean(as.numeric(edubacp))
      ) %>%
      distinct(hood, .keep_all = TRUE)
  )
)