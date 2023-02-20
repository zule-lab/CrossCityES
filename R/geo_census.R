geo_census <- function(can_bound, census_da_clean, scale){
  
  if (scale == 'city'){
    
    city_cen_i <- st_intersection(can_bound, st_as_sf(census_da_clean)) %>%
      select(c("CMANAME","da","totpop","popdens", "area", "sidehop","aptfivp","semhoup","rowhoup","aptdupp","aptbuip","otsihop","mvdwelp",
               "medinc", "lowinc", "recimmp", "indigp", "visminp", "edubacp")) %>%
      rename(city = CMANAME)
      
    
    city_cen <- city_cen_i %>%
      group_by(city) %>%   
      summarize(DAcount = n(),
             geometry = st_union(geometry),
             area = st_area(geometry),
             da = list(da),
             popdens = weighted.mean(as.numeric(popdens), as.numeric(totpop)),
             sidehop = weighted.mean(as.numeric(sidehop), as.numeric(totpop)),
             aptfivp = weighted.mean(as.numeric(aptfivp), as.numeric(totpop)),
             semhoup = weighted.mean(as.numeric(semhoup), as.numeric(totpop)),
             rowhoup = weighted.mean(as.numeric(rowhoup), as.numeric(totpop)),
             aptdupp = weighted.mean(as.numeric(aptdupp), as.numeric(totpop)),
             aptbuip = weighted.mean(as.numeric(aptbuip), as.numeric(totpop)),
             otsihop = weighted.mean(as.numeric(otsihop), as.numeric(totpop)),
             mvdwelp = weighted.mean(as.numeric(mvdwelp), as.numeric(totpop)),
             medinc = weighted.mean(as.numeric(medinc), as.numeric(totpop)),
             lowinc = weighted.mean(as.numeric(lowinc), as.numeric(totpop)),
             recimmp = weighted.mean(as.numeric(recimmp), as.numeric(totpop)),
             indigp = weighted.mean(as.numeric(indigp), as.numeric(totpop)),
             visminp = weighted.mean(as.numeric(visminp), as.numeric(totpop)),
             edubacp = weighted.mean(as.numeric(edubacp), as.numeric(totpop)),
             totpop = sum(as.numeric(totpop))
      ) %>%
      distinct(city, .keep_all = TRUE)
    
    return(city_cen)
    
    
  }
  
  
  else if (scale == 'neighbourhood'){
    
    cen_ni <- st_as_sf(census_da_clean) %>%
      mutate(areatot = st_area(geometry)) %>% # calculate total DA area
      st_set_geometry(NULL) %>% 
      select(da, areatot)
    
    # need to calculate the area of the DA that is within the neigbourhood (areaint)
    hood_cen_i <- st_intersection(can_bound, st_as_sf(census_da_clean)) %>% 
      mutate(areaint = st_area(geometry)) %>%
      left_join(., cen_ni, by = "da") %>%
      # to calculate the approximate population within the neighbourhood bounds (assuming equal density throughout the DA)
      # divide the intersected area/total area of DA and multiply the population by that 
      # can then use this population as weight for weighted means
      mutate(popwithin = (as.numeric(areaint)/as.numeric(areatot))*as.numeric(totpop)) %>% 
      select(c("city","hood","hood_id","da","totpop", "popwithin", "popdens", "area", "sidehop","aptfivp","semhoup","rowhoup","aptdupp","aptbuip","otsihop","mvdwelp",
               "medinc", "lowinc", "recimmp", "indigp", "visminp", "edubacp"))
    
    # population weighted mean
    hood_cen <- hood_cen_i %>%
      group_by(hood) %>%   
      summarize(DSAcount = n(),
             area = sum(area),
             da = list(da),
             geometry = st_union(geometry),
             popdens = weighted.mean(as.numeric(popdens), as.numeric(popwithin)),
             sidehop = weighted.mean(as.numeric(sidehop), as.numeric(popwithin)),
             aptfivp = weighted.mean(as.numeric(aptfivp), as.numeric(popwithin)),
             semhoup = weighted.mean(as.numeric(semhoup), as.numeric(popwithin)),
             rowhoup = weighted.mean(as.numeric(rowhoup), as.numeric(popwithin)),
             aptdupp = weighted.mean(as.numeric(aptdupp), as.numeric(popwithin)),
             aptbuip = weighted.mean(as.numeric(aptbuip), as.numeric(popwithin)),
             otsihop = weighted.mean(as.numeric(otsihop), as.numeric(popwithin)),
             mvdwelp = weighted.mean(as.numeric(mvdwelp), as.numeric(popwithin)),
             medinc = weighted.mean(as.numeric(medinc), as.numeric(popwithin)),
             lowinc = weighted.mean(as.numeric(lowinc), as.numeric(popwithin)),
             recimmp = weighted.mean(as.numeric(recimmp), as.numeric(popwithin)),
             indigp = weighted.mean(as.numeric(indigp), as.numeric(popwithin)),
             visminp = weighted.mean(as.numeric(visminp), as.numeric(popwithin)) ,
             edubacp = weighted.mean(as.numeric(edubacp), as.numeric(popwithin)),
             popwithin = sum(as.numeric(popwithin))
      ) %>%
      distinct(hood, .keep_all = TRUE)
    
    return(hood_cen)
    
  }
  
  else {
    print("error: none of the scale names matched")
  }
}