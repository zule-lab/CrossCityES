tree_cleaning <- function(trees_raw, parks_raw, hoods, boundaries, roads){
  

  parks <- clean_parks(parks_raw)

  trees <- clean_trees(trees_raw)  
  
  # transformations
  parks <- st_transform(parks, crs = 3347)
  trees <- st_transform(trees, crs = 3347)
  
  # cleaning roads
  city_bound <- subset(boundaries, CMANAME == hoods$city)
  city_road <- roads[city_bound,]
  city_road <- dplyr::select(city_road, c("street", "streetid", "geometry"))
  city_road <- city_road %>% dplyr::mutate(index = row_number())
  
  # check for duplicates
  dup <- trees$id[duplicated(trees$id)]
  trees <- trees %>% dplyr::filter(!id %in% dup)
  
  # joining neighbourhoods
  if ("hood" %in% colnames(trees) == "FALSE") {
    trees <- st_join(trees, hoods, join = st_intersects)
  }
  else { NULL }
  
  
  # joining parks
  if ("park" %in% colnames(trees) == "FALSE") {
    trees <- st_join(trees, parks, join = st_intersects)
  }
  else { NULL }
  
  
  # joining streets
  if ("street" %in% colnames(trees) == "FALSE") {
    trees <- dplyr::mutate(trees, streetid = st_nearest_feature(trees, city_road)) # st_nearest_feature returns the index value not the street name
    trees <- dplyr::mutate(trees, index = match(as.character(trees$streetid), as.character(city_road$index))) # return unique streetid based on index values
    trees <- dplyr::mutate(trees, street = city_road$street[match(trees$index, city_road$index)]) # add column with street name
  }
  
  else { 
    trees <- dplyr::rename(trees, munstreetname = street)
    trees <- dplyr::mutate(trees, streetid = st_nearest_feature(trees, city_road)) # st_nearest_feature returns the index value not the street name
    trees <- dplyr::mutate(trees, index = match(as.character(trees$streetid), as.character(city_road$index))) # return unique streetid based on index values
    trees <- dplyr::mutate(trees, street = city_road$street[match(trees$index, city_road$index)]) # add column with street name
  }
  
  
  # filtering for street trees 
  trees <- dplyr::mutate(trees, park = replace_na(as.character(park), "no"))
  trees <- dplyr::mutate(trees, park = ifelse(park == "no", "no", "yes"))
  trees <- trees %>% dplyr::filter(park == "no")
  
  # ensuring proper formatting
  trees <- dplyr::mutate(trees, genus = str_to_title(trees$genus)) 
  trees <- dplyr::mutate(trees, species = str_to_lower(trees$species))
  trees <- dplyr::mutate(trees, cultivar = str_to_lower(trees$cultivar))
  
  
  # filtering for trees in city boundaries
  trees <- trees[city_bound,]
  

  # reordering & saving
  trees <- trees[,c("city", "id", "genus", "species", "cultivar", "geometry", "hood", "hood_id", "park", "streetid", "dbh")]# Check and make output
  
  return(trees)
  
}


# parks cleaning ----------------------------------------------------------
clean_parks <- function(parks_raw){
  if (deparse(substitute(parks_raw)) == 'van_park_raw'){
    parks <- van_park_raw %>%
      select(c("park_name", "geometry")) %>%
      rename("park" = "park_name")
  }
  
  if (deparse(substitute(parks_raw)) == 'cal_park_raw'){
    parks <- cal_park_raw %>%
      select(c("SITE_NAME", "the_geom")) %>%
      rename("park" = "SITE_NAME") %>%
      rename("geometry" = "the_geom") %>%
      st_as_sf(wkt = "geometry", crs = 4326)
  }
  
  if (deparse(substitute(parks_raw)) == 'win_park_raw'){
    parks <- win_park_raw %>%
      select(c("park_name", "geometry")) %>%
      rename("park" = "park_name")
  }
  
  if (deparse(substitute(parks_raw)) == 'tor_park_raw'){
    
    parks <- tor_park_raw %>%
      select(c("OBJECTID", "geometry")) %>%
      rename("park" = "OBJECTID")
  }
  
  if (deparse(substitute(parks_raw)) == 'ott_park_raw'){
    parks <- ott_park_raw %>%
      select(c("NAME", "geometry")) %>%
      rename("park" = "NAME")
  }
  
  if (deparse(substitute(parks_raw)) == 'mon_park_raw'){
    parks <- mon_park_raw %>%
      select(c("Nom", "geometry")) %>%
      rename("park" = "Nom")
  }
  
  if (deparse(substitute(parks_raw)) == 'hal_park_raw'){
    parks <- hal_park_raw %>%
      select(c("PARK_NAME", "geometry")) %>%
      rename("park" = "PARK_NAME")
  } 
  
  return(parks)
}

# trees cleaning ----------------------------------------------------------
clean_trees <- function(trees_raw){
  
  if (deparse(substitute(trees_raw)) == 'van_tree_raw'){
    
    trees_c <- read.csv('large/trees/van_tree_raw.csv', sep = ";")
    
    tree_s <- trees_c %>%
      select(c("TREE_ID","GENUS_NAME","SPECIES_NAME","CULTIVAR_NAME","ON_STREET","DIAMETER","Geom")) %>%
      rename("id" = "TREE_ID",
             "genus" = "GENUS_NAME",
             "species" = "SPECIES_NAME",
             "cultivar" = "CULTIVAR_NAME",
             "street" = "ON_STREET",
             "dbh" = "DIAMETER") %>%
      mutate(street = str_to_title(street),
             Geom = sub(".*\\[([^][]+)].*", "\\1", Geom)) %>%
      separate(col = Geom, into = c("long", "lat"), sep = "\\, ") %>%
      drop_na(c(lat,long)) %>%
      st_as_sf(coords = c("long", "lat"), crs = 4326, na.fail = FALSE, remove = FALSE)
    
    tree <- assign_sp_van(tree_s)
  }
  
  if (deparse(substitute(trees_raw)) == 'cal_tree_raw'){
    
    tree_s <- trees_raw %>%
      select(c("GENUS", "SPECIES", "CULTIVAR", "DBH_CM", "WAM_ID", "POINT")) %>%
      rename("genus" = "GENUS",
             "species" = "SPECIES",
             "cultivar" = "CULTIVAR",
             "dbh" = "DBH_CM",
             "id" = "WAM_ID",
             "geometry" = "POINT") %>% 
      drop_na(geometry) %>%
      st_as_sf(wkt = "geometry", crs = 4326)
    
    tree <- assign_sp_cal(tree_s)
  
  }
  
  if (deparse(substitute(trees_raw)) == 'win_tree_raw'){
    tree_s <- trees_raw %>%
      select(c("the_geom","tree_id","botanical","dbh","park","street")) %>%
      rename("id" = "tree_id") %>%
      mutate(the_geom = substr(the_geom,8,nchar(the_geom)-1)) %>%
      separate(col = the_geom, into = c("lat", "long"), sep = "\\ ") %>%
      drop_na(c(lat,long)) %>%
      st_as_sf(coords = c("lat", "long"), crs = 4326, na.fail = FALSE, remove = FALSE)
    
    tree <- assign_sp_win(tree_s)
  }
  
  if (deparse(substitute(trees_raw)) == 'tor_tree_raw'){
    
    tree_s <- trees_raw %>%
      select(c("STRUCTID","DBH_TRUNK","COMMON_NAME", "STREETNAME","geometry")) %>%
      rename("id" = "STRUCTID",
             "street" = "STREETNAME",
             "dbh" = "DBH_TRUNK") %>%
      mutate(street = str_to_title(street),
             geometry = substr(geometry,38,nchar(geometry)-2)) %>%
      separate(col = geometry, into = c("long", "lat"), sep = "\\, ") %>%
      drop_na(c(lat,long)) %>%
      st_as_sf(coords = c("long", "lat"), crs = 4326, na.fail = FALSE, remove = FALSE)
    
    tree <- assign_sp_tor(tree_s, tar_load(tor_tree_spcode)) # species codes may be an issue
  }
  
  if (deparse(substitute(trees_raw)) == 'ott_tree_raw'){
    tree_s <- trees_raw %>%
      select(c("X","Y","OBJECTID","ADDSTR","SPECIES","DBH")) %>%
      rename("long" = "X") %>%
      rename("lat" = "Y") %>%
      rename("id" = "OBJECTID") %>%
      rename("street" = "ADDSTR") %>%
      rename("dbh" = "DBH")
    
    tree <- assign_sp_ott(tree_s, tar_load(ott_tree_spcode))
  }
  
  if (deparse(substitute(trees_raw)) == 'mon_tree_raw'){
    tree_s <- trees_raw %>%
      select(c("Essence_latin","DHP", "Rue", "NOM_PARC","Longitude","Latitude")) %>%
      rename("dbh" = "DHP",
             "park" = "NOM_PARC",
             "street" = "Rue") %>%
      mutate(id = seq.int(nrow(.))) %>%
      drop_na(c(Latitude, Longitude))
    
    tree <- assign_sp_mon(tree_s)

  }
  
  if (deparse(substitute(trees_raw)) == 'hal_tree_raw'){
    tree_s <- trees_raw %>% 
      filter(ASSETSTAT == "INS") %>%
      select(c("X", "Y", "TREEID", "SP_SCIEN", "DBH")) %>%
      rename("id" = "TREEID") %>%
      rename("dbh" = "DBH") %>% 
      drop_na(c(X,Y)) %>%
      st_as_sf(coords = c("X", "Y"), crs = 4326)
    
    tree <- assign_sp_hal(tree_s, tar_load(hal_tree_spcode), tar_load(hal_tree_dbhcode))
  } 
  
  return(tree)
}