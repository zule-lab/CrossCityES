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
    
    city_cen_onep <- bind_cols(city_cen %>% select(c(city, area, da, geometry)),
              city_cen %>% st_set_geometry(NULL) %>% select(-c(city, area, da)) %>% select_if(~any(. > 0.01)))
    
    return(city_cen_onep)
    
    
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
      group_by(city, hood_id) %>%   
      summarize(hood = first(hood), 
                DSAcount = n(),
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
      distinct(city, hood_id, .keep_all = TRUE)
    
    hood_cen_onep <- bind_cols(hood_cen %>% select(c(hood, hood_id, area, da, geometry)),
                               hood_cen %>% st_set_geometry(NULL) %>% select(-c(city, hood, hood_id, area, da)) %>% select_if(~any(. > 0.01)))
    
    
    return(hood_cen_onep)
    
  }
  
  
  else if (scale == 'road'){
    
    cen_ni <- st_as_sf(census_da_clean) %>%
      mutate(areatot = st_area(geometry)) %>% # calculate total DA area
      st_set_geometry(NULL) %>% 
      select(da, areatot)
    
    # need to calculate the area of the DA that overlaps with the street (areaint)
    hood_cen_i <- st_intersection(can_bound, st_as_sf(census_da_clean)) %>% 
      mutate(areaint = st_area(geometry)) %>%
      left_join(., cen_ni, by = "da") %>%
      # to calculate the approximate population within the neighbourhood bounds (assuming equal density throughout the DA)
      # divide the intersected area/total area of DA and multiply the population by that 
      # can then use this population as weight for weighted means
      mutate(popwithin = (as.numeric(areaint)/as.numeric(areatot))*as.numeric(totpop)) %>%   
      select(c("street","streetid", "id", "CMANAME", "da","totpop", "popwithin", "popdens", "area", "sidehop","aptfivp","semhoup","rowhoup","aptdupp","aptbuip","otsihop","mvdwelp",
               "medinc", "lowinc", "recimmp", "indigp", "visminp", "edubacp"))
    
    # population weighted mean
    hood_cen <- hood_cen_i %>%
      group_by(CMANAME, streetid) %>%   
      summarize(street = first(street),
                id = first(id),
                DSAcount = n(),
                area = sum(area),
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
      distinct(CMANAME, streetid, .keep_all = TRUE)
    
    hood_cen_onep <- bind_cols(hood_cen %>% select(c(street, streetid, id, area, geometry)),
                               hood_cen %>% st_set_geometry(NULL) %>% select(-c(CMANAME, streetid, street, id, area)) %>% select_if(~any(. > 0.01))) %>% 
      st_set_geometry(NULL)
    
    
    return(hood_cen_onep)
    
  }
  
  else {
    print("error: none of the scale names matched")
  }
}
