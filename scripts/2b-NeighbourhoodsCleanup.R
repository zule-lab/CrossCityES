# Script to clean up Canada roads and city boundary raw data
# Author: Nicole Yu & Isabella Richmond

#### PACKAGES ####
p <- c("sf", "dplyr")
lapply(p, library, character.only = T)

#### FUNCTIONS ####
hood_cleaned <- function(df, prefix, dest){
  p <- c("dplyr", "stringr", "sf")
  lapply(p, library, character.only = T)
  df %>% mutate(hood_id = paste0("prefix", seq.int(nrow(df)))) # add hood id
  df$hood <- str_to_title(df$hood)   # change case of hood names
  df <- st_transform(df, crs = 3347) # transform
  df$hood_area <- st_area(df) # add area column
  saveRDS(df, dest)
  df <- readRDS(dest)
  
}

#### DATA #### 
# Calgary 
cal_hood_raw <- read.csv("large/neighbourhoods/cal_hood_raw.csv")
# Halifax
hal_hood_raw <- st_read(file.path("/vsizip", "large/neighbourhoods/hal_hood_raw.zip"))
# Montreal
mon_hood_raw <- st_read(file.path("/vsizip", "large/neighbourhoods/mon_hood_raw.zip"))
# Ottawa
ott_hood_raw <- st_read(file.path("/vsizip", "large/neighbourhoods/ott_hood_raw.zip"))
# Toronto
tor_hood_raw <- st_read(file.path("/vsizip", "large/neighbourhoods/tor_hood_raw.zip"))
# Vancouver
van_hood_raw <- st_read(file.path("/vsizip", "large/neighbourhoods/van_hood_raw.zip"))
# Winnipeg
win_hood_raw <- st_read(file.path("/vsizip", "large/neighbourhoods/win_hood_raw.zip"))

#### CLEANUP ####
# Calgary
cal_hood <- cal_hood_raw %>% 
  select(c("NAME", "the_geom")) %>% 
  rename("hood" = "NAME") %>% 
  rename("geometry" = "the_geom") %>%
  mutate(city = c("Calgary")) # select neighbourhood codes and names columns and rename
cal_hood <- st_as_sf(cal_hood, wkt = "geometry", crs = 4326)
cal_hood <- hood_cleaned(cal_hood, cal, "large/neighbourhoods/CalgaryNeighbourhoodsCleaned.rds")
# Halifax
hal_hood <- hal_hood_raw %>% 
  select(c("GSA_NAME", "geometry")) %>% 
  rename("hood" = "GSA_NAME") %>% 
  filter(hood == "HALIFAX") %>%
  mutate(city = c("Halifax")) # Halifax peninsula is considered to be one neighbourhood as per correspondence with city officials
hal_hood <- hood_cleaned(hal_hood, hal, "large/neighbourhoods/HalifaxNeighbourhoodsCleaned.rds")
# Montreal
mon_hood <- mon_hood_raw %>% select(c("NOM","geometry")) %>%
  rename("hood" = "NOM") %>%
  mutate(city = c("Montreal"))
mon_hood <- hood_cleaned(mon_hood, mon, "large/neighbourhoods/MontrealNeighbourhoodsCleaned.rds")
# Ottawa
ott_hood <- ott_hood_raw %>% 
  select(c("Name", "geometry")) %>% 
  rename("hood" = "Name") %>%
  mutate(city = c("Ottawa"))
ott_hood <- hood_cleaned(ott_hood, ott, "large/neighbourhoods/OttawaNeighbourhoodsCleaned.rds")
# Toronto
tor_hood <- tor_hood_raw %>% select(c("FIELD_8", "geometry")) %>% 
  rename("hood" = "FIELD_8")%>%
  mutate(city = c("Toronto"))
tor_hood <- hood_cleaned(tor_hood, tor, "large/neighbourhoods/TorontoNeighbourhoodsCleaned.rds")
# Vancouver
van_hood <- van_hood_raw %>% select(c("name","geometry"))%>%
  rename(hood = "name") %>%
  mutate(city = c("Vancouver"))
van_hood <- hood_cleaned(van_hood, van, "large/neighbourhoods/VancouverNeighbourhoodsCleaned.rds")
# Winnipeg
win_hood <- win_hood_raw %>% select(c("name","geometry")) %>%
  rename(hood = "name") %>%
  mutate(city = c("Winnipeg"))
win_hood <- hood_cleaned(win_hood, win, "large/neighbourhoods/WinnipegNeighbourhoodsCleaned.rds")

#### COMBINE ####
can_hood <- rbind(cal_hood, hal_hood, mon_hood, ott_hood, tor_hood, van_hood, win_hood)
saveRDS(can_hood, "large/neighbourhoods/AllNeighbourhoodsCleaned.rds")
