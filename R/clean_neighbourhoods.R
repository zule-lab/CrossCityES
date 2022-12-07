clean_neighbourhoods <- function(raw_df){
  
  if (deparse(substitute(raw_df)) == 'van_hood_raw'){
    df <- van_hood_raw %>% 
      select(c("name","geometry"))%>%
      rename(hood = "name") %>%
      mutate(city = c("Vancouver"))
  }
  
  if (deparse(substitute(raw_df)) == 'cal_hood_raw'){
    df <- cal_hood_raw %>% 
      select(c("NAME", "MULTIPOLYGON")) %>% 
      rename("hood" = "NAME") %>% 
      rename("geometry" = "MULTIPOLYGON") %>%
      mutate(city = c("Calgary")) %>%
      st_as_sf(wkt = "geometry", crs = 4326)
  }
  
  if (deparse(substitute(raw_df)) == 'win_hood_raw'){
    df <- win_hood_raw %>% 
      select(c("name","geometry")) %>%
      rename(hood = "name") %>%
      mutate(city = c("Winnipeg"))
  }
  
  if (deparse(substitute(raw_df)) == 'tor_hood_raw'){
    
    df <- tor_hood_raw %>% 
      select(c("FIELD_8", "geometry")) %>% 
      rename("hood" = "FIELD_8")%>%
      mutate(city = c("Toronto"))
  }
  
  if (deparse(substitute(raw_df)) == 'ott_hood_raw'){
    df <- ott_hood_raw %>% 
      select(c("Name", "geometry")) %>% 
      rename("hood" = "Name") %>%
      mutate(city = c("Ottawa"))
  }
  
  if (deparse(substitute(raw_df)) == 'mon_hood_raw'){
    df <- mon_hood_raw %>% 
      select(c("NOM","geometry")) %>%
      rename("hood" = "NOM") %>%
      mutate(city = c("Montreal"))
  }
  
  if (deparse(substitute(raw_df)) == 'hal_hood_raw'){
    df <- hal_hood_raw %>% 
      select(c("GSA_NAME", "geometry")) %>% 
      rename("hood" = "GSA_NAME") %>% 
      mutate(city = c("Halifax")) 
  }
  
  
  df <- df %>% mutate(hood_id = paste0(substr(deparse(substitute(df)), 1, 3), seq.int(nrow(df)))) # add hood id
  df$hood <- str_to_title(df$hood)   # change case of hood names
  df <- st_transform(df, crs = 3347) # transform
  df$hood_area <- st_area(df) # add area column
  
  return(df)
  
}
