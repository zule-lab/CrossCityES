geo_census <- function(can_bound, census_da_clean, scale){
  
  if (scale == 'city'){
    
    city_cen_i <- st_intersection(can_bound, st_as_sf(census_da_clean))
    
    # spatially weighted join
    city_cen_swj <- city_cen_i %>%
      select(c("CMANAME","da","totpop","popdens", "area", "sidehop","aptfivp","semhoup","rowhoup","aptdupp","aptbuip","otsihop","mvdwelp",
               "medinc", "lowinc", "recimmp", "indigp", "visminp", "edubacp")) %>%
      rename(city = CMANAME) %>%
      group_by(city) %>% 
      mutate(area = st_area(geometry)) %>% 
      mutate(weight = as.numeric(area / sum(area))) %>%
      mutate(wmean = weighted.mean(as.numeric(totpop), as.numeric(area)))
    
    city_cen <- city_cen_swj %>%
      group_by(city) %>%   
      mutate(DSAcount = n(),
             weight = sum(weight),
             area = sum(area),
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
             indigp = mean(as.numeric(indigp)),
             visminp = mean(as.numeric(visminp)) ,
             edubacp = mean(as.numeric(edubacp))
      ) %>%
      distinct(city, .keep_all = TRUE)
    
    return(city_cen)
    
    
  }
  
  
  else if (scale == 'neighbourhood'){
    
    hood_cen_i <- st_intersection(can_bound, st_as_sf(census_da_clean))
    
    # spatially weighted join
    hood_cen_swj <- hood_cen_i %>%
      select(c("city","hood","hood_id","da","totpop","popdens", "area", "sidehop","aptfivp","semhoup","rowhoup","aptdupp","aptbuip","otsihop","mvdwelp",
               "medinc", "lowinc", "recimmp", "indigp", "visminp", "edubacp")) %>%
      group_by(hood) %>% 
      mutate(area = st_area(geometry)) %>% 
      mutate(weight = as.numeric(area / sum(area))) %>%
      mutate(wmean = weighted.mean(as.numeric(totpop), as.numeric(area)))
    
    hood_cen <- hood_cen_swj %>%
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
             aborigp = mean(as.numeric(indigp)),
             visminp = mean(as.numeric(visminp)) ,
             edubacp = mean(as.numeric(edubacp))
      ) %>%
      distinct(hood, .keep_all = TRUE)
    
    return(hood_cen)
    
  }
  
  else {
    print("error: none of the scale names matched")
  }
}