tree_cleaning <- function(trees_raw, parks_raw, hoods, boundaries, roads){
  

  parks_clean <- clean_parks(parks_raw)

  trees_clean <- clean_trees(trees_raw)  
  
  # transformations
  parks_t <- st_transform(parks_clean, crs = 3347)
  trees_t <- st_transform(trees_clean, crs = 3347)
  
  # cleaning roads
  city_bound <- subset(boundaries, CMANAME == hoods$city)
  city_road_ss <- roads[city_bound,]
  city_road_s <- dplyr::select(city_road_ss, c("street", "streetid", "geometry"))
  city_road <- city_road_s %>% dplyr::mutate(index = row_number())
  
  # check for duplicates
  dup <- trees_t$id[duplicated(trees_t$id)]
  trees_nd <- trees_t %>% dplyr::filter(!id %in% dup)
  
  # joining neighbourhoods
  if ("hood" %in% colnames(trees_nd) == "FALSE") {
    trees_h <- st_join(trees_nd, hoods, join = st_intersects)
  }
  else { trees_h <- trees_nd }
  
  
  # joining parks
  if ("park" %in% colnames(trees_h) == "FALSE") {
    trees_p <- st_join(trees_h, parks_t, join = st_intersects)
  }
  else { trees_p <- trees_h }
  
  
  # joining streets
  if ("street" %in% colnames(trees_p) == "FALSE") {
    trees_1 <- dplyr::mutate(trees_p, streetid = st_nearest_feature(trees_p, city_road)) # st_nearest_feature returns the index value not the street name
    trees_2 <- dplyr::mutate(trees_1, index = match(as.character(trees_1$streetid), as.character(city_road$index))) # return unique streetid based on index values
    trees_st <- dplyr::mutate(trees_2, street = city_road$street[match(trees_2$index, city_road$index)]) # add column with street name
  }
  
  else { 
    trees_1 <- dplyr::rename(trees_p, munstreetname = street)
    trees_2 <- dplyr::mutate(trees_1, streetid = st_nearest_feature(trees_1, city_road)) # st_nearest_feature returns the index value not the street name
    trees_3 <- dplyr::mutate(trees_2, index = match(as.character(trees_2$streetid), as.character(city_road$index))) # return unique streetid based on index values
    trees_st <- dplyr::mutate(trees_3, street = city_road$street[match(trees_3$index, city_road$index)]) # add column with street name
  }
  
  
  # filtering for street trees 
  trees_rna <- dplyr::mutate(trees_st, park = replace_na(as.character(park), "no"))
  trees_cde <- dplyr::mutate(trees_rna, park = ifelse(park == "no", "no", "yes"))
  trees_nopark <- trees_cde %>% dplyr::filter(park == "no")
  
  # ensuring proper formatting
  trees_g <- dplyr::mutate(trees_nopark, genus = str_to_title(trees_nopark$genus)) 
  trees_sp <- dplyr::mutate(trees_g, species = str_to_lower(trees_g$species))
  trees_cult <- dplyr::mutate(trees_sp, cultivar = str_to_lower(trees_sp$cultivar))
  
  
  # filtering for trees in city boundaries
  trees_clip <- trees_cult[city_bound,]
  

  # reordering & saving
  trees <- trees_clip[,c("city", "id", "genus", "species", "cultivar", "geometry", "hood", "hood_id", "park", "streetid", "dbh")]# Check and make output
  
  return(trees)
  
}



# parks cleaning ----------------------------------------------------------
clean_parks <- function(parks_raw){
  
  if (deparse(substitute(parks_raw)) == 'van_park_raw'){
    parks <- parks_raw %>%
      select(c("park_name", "geometry")) %>%
      rename("park" = "park_name")
    
    return(parks)
  }
  
  else if (deparse(substitute(parks_raw)) == 'cal_park_raw'){
    parks <- parks_raw %>%
      select(c("SITE_NAME", "the_geom")) %>%
      rename("park" = "SITE_NAME") %>%
      rename("geometry" = "the_geom") %>%
      st_as_sf(wkt = "geometry", crs = 4326)
    
    return(parks)
  }
  
  else if (deparse(substitute(parks_raw)) == 'win_park_raw'){
    parks <- parks_raw %>%
      select(c("park_name", "geometry")) %>%
      rename("park" = "park_name")
    
    return(parks)
  }
  
  else if (deparse(substitute(parks_raw)) == 'tor_park_raw'){
    
    parks <- parks_raw %>%
      select(c("OBJECTID", "geometry")) %>%
      rename("park" = "OBJECTID")
    
    return(parks)
  }
  
  else if (deparse(substitute(parks_raw)) == 'ott_park_raw'){
    parks <- parks_raw %>%
      select(c("NAME", "geometry")) %>%
      rename("park" = "NAME")
    
    return(parks)
  }
  
  else if (deparse(substitute(parks_raw)) == 'mon_park_raw'){
    parks <- parks_raw %>%
      select(c("Nom", "geometry")) %>%
      rename("park" = "Nom")
    
    return(parks)
  }
  
  else if (deparse(substitute(parks_raw)) == 'hal_park_raw'){
    parks <- parks_raw %>%
      select(c("PARK_NAME", "geometry")) %>%
      rename("park" = "PARK_NAME")
    
    return(parks)
  } 
  
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
    
    return(tree)
  }
  
  else if (deparse(substitute(trees_raw)) == 'cal_tree_raw'){
    
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
    
    return(tree)
  }
  
  else if (deparse(substitute(trees_raw)) == 'win_tree_raw'){
    tree_s <- trees_raw %>%
      select(c("the_geom","tree_id","botanical","dbh","park","street")) %>%
      rename("id" = "tree_id") %>%
      mutate(the_geom = substr(the_geom,8,nchar(the_geom)-1)) %>%
      separate(col = the_geom, into = c("lat", "long"), sep = "\\ ") %>%
      drop_na(c(lat,long)) %>%
      st_as_sf(coords = c("lat", "long"), crs = 4326, na.fail = FALSE, remove = FALSE)
    
    tree <- assign_sp_win(tree_s)
    
    return(tree)
  }
  
  else if (deparse(substitute(trees_raw)) == 'tor_tree_raw'){
    
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
    
    return(tree)
  }
  
  else if (deparse(substitute(trees_raw)) == 'ott_tree_raw'){
    tree_s <- trees_raw %>%
      select(c("X","Y","OBJECTID","ADDSTR","SPECIES","DBH")) %>%
      rename("long" = "X") %>%
      rename("lat" = "Y") %>%
      rename("id" = "OBJECTID") %>%
      rename("street" = "ADDSTR") %>%
      rename("dbh" = "DBH")
    
    tree <- assign_sp_ott(tree_s, tar_load(ott_tree_spcode))
    
    return(tree)
  }
  
  else if (deparse(substitute(trees_raw)) == 'mon_tree_raw'){
    tree_s <- trees_raw %>%
      select(c("Essence_latin","DHP", "Rue", "NOM_PARC","Longitude","Latitude")) %>%
      rename("dbh" = "DHP",
             "park" = "NOM_PARC",
             "street" = "Rue") %>%
      mutate(id = seq.int(nrow(.))) %>%
      drop_na(c(Latitude, Longitude))
    
    tree <- assign_sp_mon(tree_s)
    
    return(tree)

  }
  
  else if (deparse(substitute(trees_raw)) == 'hal_tree_raw'){
    tree_s <- trees_raw %>% 
      filter(ASSETSTAT == "INS") %>%
      select(c("X", "Y", "TREEID", "SP_SCIEN", "DBH")) %>%
      rename("id" = "TREEID") %>%
      rename("dbh" = "DBH") %>% 
      drop_na(c(X,Y))
    
    tree_sp <- assign_sp_hal(tree_s, tar_read(hal_tree_spcode), tar_read(hal_tree_dbhcode))
    
    tree <- tree_sp %>% st_as_sf(coords = c("X", "Y"), crs = 4326)
    
    return(tree)
  } 
  
}

