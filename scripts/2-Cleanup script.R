# Script to cleanup raw data

#### Packages ####
easypackages::packages("tidyr", "tidyverse", "Rmisc","stringr","spatialEco","sp","sf","rgdal")



#### Canada roads data cleanup ####
View(can_road)
unique(duplicated(can_road$CSDUID))
can_road <- can_road[,c("CSDUID","geometry")]
can_road <- st_transform(can_road,crs = "epsg:6624")

#### City parks data cleanup ####
## Calgary park data cleanup
data.frame(colnames(cal_park_raw))
cal_park <- cal_park_raw[,c("SITE_NAME","the_geom")]
names(cal_park)[c(1)] <- "park"
cal_park$park[cal_park$park == ""] <- "is park" 
########### Can't remove the empty geom files
st_as_sf(cal_park, na.fail=FALSE)
View(cal_park_raw)

## Halifax park data cleanup
# remove after added download link in download script -- hal_park_raw <- read_sf("/Users/nicoleyu/Desktop/GRI_ZULE/Downloads/HRM_Parks/HRM_Parks.shp")
data.frame(colnames(hal_park_raw))
hal_park <- hal_park_raw[,c("PARK_NAME","geometry")]
names(hal_park)[c(1)] <- "park"
hal_park <- st_transform(hal_park,crs = "epsg:6624")
View(hal_park)

## Ottawa park data cleanup
data.frame(colnames(ott_park_raw))
ott_park <- ott_park_raw[,c("PARK_ID","geometry")]
names(ott_park)[c(1)] <- "park"
ott_park <- st_transform(ott_park,crs = "epsg:6624")
View(ott_park)

## Toronto park data cleanup
data.frame(colnames(tor_park_raw))
tor_park <- tor_park_raw[,c("OBJECT_ID","geometry")]
names(tor_park)[c(1)] <- "park"
tor_park <- st_transform(tor_park,crs = "epsg:6624")
View(tor_park)

## Vancouver park data cleanup
data.frame(colnames(van_park_raw))
van_park <- van_park_raw[,c(3,5)]
names(van_park)[c(1)] <- "park"
van_park <- st_transform(van_park,crs = "epsg:6624")
View(van_park)


#### City tree data cleanup ####
## Calgary tree data cleanup
# Check for dupes
unique(duplicated(cal_tree_raw$WAM_ID))
# Extract columns needed and rename
data.frame(colnames(cal_tree_raw))
cal_tree <- cal_tree_raw[,c(5,6,7,9,16,17,20)]
names(cal_tree)[c(1,2,3,4,5,7)] <- c("genus","species","cultivar", "dbh","id","coord")
# Adding and fixing columns
cal_tree$city <- c("Calgary")
cal_tree$species[cal_tree$species %in% c("",NA)]<-"sp."
cal_tree$cultivar <- substr(cal_tree$cultivar,2,nchar(cal_tree$cultivar)-1)
cal_tree_hoodcode <-read.csv("input/cal_tree_hoodcode.csv", row.names = NULL)
cal_tree$hood <- cal_tree_hoodcode$hood[match(as.character(cal_tree$COMM_CODE), as.character(cal_tree_hoodcode$code))]
## Unifying geom column and splitting into additional lat and long columns
cal_tree$coord <- substr(cal_tree$coord,2,nchar(cal_tree$coord)-1)
cal_tree <- separate(data = cal_tree, col = coord, into = c("lat", "long"), sep = "\\, ")
# Add park column
# Assigning street

# Reorder columns
data.frame(colnames(cal_tree))
cal_tree <- cal_tree[c("city", "id", "genus","species","cultivar","lat","long","hood","dbh","COMM_CODE")]
# Check and make output
cal_tree[cal_tree == ""] <- NA 
View(cal_tree)
write.csv(cal_tree, "output/cal_tree.csv", row.names=FALSE)

## Halifax tree data cleanup
# Check for dupes
hal_tree_raw <- hal_opendata
unique(duplicated(hal_tree_raw$TREEID))
# Extract columns needed and rename
data.frame(colnames(hal_tree_raw))
hal_tree <- hal_tree_raw %>% filter(ASSETSTAT == "INS")
hal_tree <- hal_tree[,c(1,2,5,7,15,17)]
data.frame(colnames(hal_tree_raw))
names(hal_tree)[c(1,2,3,6)] <- c("long", "lat","id","dbh")
# Adding and fixing columns
hal_tree$city <- c("Halifax")
hal_tree_spcode <-read.csv("input/hal_tree_spcode.csv", row.names = NULL)
# "BUROAK", "BLAOAK", "BOAK", "FMAPLE" undefined in metadata, "BUROAK" <- "Bur Oak", "BLAOAK" <- "Black Oak"
hal_tree$botname <- hal_tree_spcode$botname[match(as.character(hal_tree$SP_SCIEN), as.character(hal_tree_spcode$code))]
hal_tree <- hal_tree %>% separate(botname, c("genus","species","var","cultivar"))
hal_tree$species[hal_tree$species %in% c("",NA)] <- "sp."
hal_tree$var[hal_tree$var == "var"] <- NA
hal_treecul <- hal_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ")
hal_treesp <- hal_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ")
hal_tree <- rbind(hal_treecul, hal_treesp)
hal_tree_dbhcode <-read.csv("input/hal_tree_dbhcode.csv", row.names = NULL)
hal_tree$dbh <- hal_tree_dbhcode$dbh[match(as.character(hal_tree$dbh), as.character(hal_tree_dbhcode$code))]
unique(hal_tree$species)
# Reorder columns
data.frame(colnames(hal_tree))
hal_tree <- hal_tree[,c("city","id","genus","species","cultivar","lat","long","dbh","SP_SCIEN","OWNER")]
# Check and make output
hal_tree[hal_tree == ""] <- NA 
View(hal_tree)
write.csv(hal_tree, "output/hal_tree.csv", row.names=FALSE)

## Montreal tree data cleanup
# Check for dupes
View(mon_tree_raw)
unique(duplicated(mon_tree_raw))
# Extract columns needed and rename
data.frame(colnames(mon_tree_raw))
mon_tree <- mon_tree_raw[,c(3,9,10,12,15,21,22)]
names(mon_tree)[c(2,3,5,6,7)] <- c("x","y","dbh","long","lat")
# Adding and fixing columns
mon_tree$id <- seq.int(nrow(mon_tree))
mon_tree$city <- c("Montreal")
mon_tree <- mon_tree %>% separate(Essence_latin, c("genus","species","var","cultivar"))
mon_tree$species[mon_tree$species %in% c("ssp", NA)]<-"sp."
mon_tree$var[mon_tree$var %in% c("","var")] <- NA
mon_treecul <- mon_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ")
mon_treesp <- mon_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ")
mon_tree <- rbind(mon_treecul, mon_treesp)
mon_tree_hoodcode <-read.csv("input/mon_tree_hoodcode.csv", row.names = NULL)
mon_tree$hood <- mon_tree_hoodcode$hood[match(as.character(mon_tree$ARROND), as.character(mon_tree_hoodcode$code))]
# Converting dbh from mm to cm
mon_tree$dbh <- mon_tree$dbh/10
# Reorder columns
data.frame(colnames(mon_tree))
mon_tree <- mon_tree[,c("city","id","genus","species","cultivar","lat","long","hood","dbh","x","y")]
# Check and make output
mon_tree[mon_tree == ""] <- NA
View(mon_tree)
write.csv(mon_tree, "output/mon_tree.csv", row.names=FALSE)

## Ottawa tree data cleanup
# Species are common name, require further sorting
# Check for dupes
View(ott_tree_raw)
unique(duplicated(ott_tree_raw$OBJECTID))
# Extract columns needed and rename
data.frame(colnames(ott_tree_raw))
ott_tree <- ott_tree_raw[,c(1,2,3,6,12,13)]
names(ott_tree)[c(1,2,3,4,6)] <- c("long","lat","id","street","dbh")
# Adding and fixing columns
ott_tree$city <- c("Ottawa")
# Adding geometry column and converting to sf with epsg:6624 projection
ott_tree <- st_as_sf(x = ott_tree, coords = c("long", "lat"), crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0", na.fail = FALSE, remove = FALSE)
ott_tree <- st_transform(ott_tree,crs = "epsg:6624")
# Adding park column
############# error in evaluating the argument 'x' in selecting a method for function 'addAttrToGeom': empty geometries are not supported by sp classes: conversion failed
ott_tree <- point.in.poly(ott_tree, ott_park)
ott_tree$park <- ifelse(is.na(ott_tree$park),"no","yes")
# Adding hood column
#Adding street column
ott_tree$street <- st_nearest_feature(ott_tree, can_road)
# Reorder columns
data.frame(colnames(ott_tree))
ott_tree <- ott_tree[,c("city","id","SPECIES","lat","long","geometry","street","dbh")]
# Check and make output
######## This code not working? ott_tree[ott_tree == ""] <- NA
View(ott_tree)
st_write(ott_tree, "large/ott_tree.shp")


## Toronto tree data cleanup
# Check for dupes
unique(duplicated(tor_tree_raw$STRUCTID))
# Extract columns needed and rename
View(tor_tree_raw)
data.frame(colnames(tor_tree_raw))
tor_tree <- data.frame(tor_tree_raw[,c(2,3,4,7,8,11,12)])
names(tor_tree)[c(1,2,3,4,5)] <- c("x","y","id","street","dbh")
# Adding and fixing columns
tor_tree$city <- c("Toronto")
tor_tree <- tor_tree %>% separate(BOTANICAL_, c("genus","species","var","cultivar", "cultivar2"))
tor_tree$species[tor_tree$species == "sp"] <- "sp."
tor_tree$species[tor_tree$species == "X"] <- "x"
tor_tree$var[tor_tree$var == "var"] <- NA
tor_treecul <- tor_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar", "cultivar2"), na.rm = TRUE, sep = " ")
tor_treesp <- tor_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ") %>% unite(cultivar, c("cultivar", "cultivar2"), na.rm = TRUE, sep = " ")
tor_tree <- rbind(tor_treecul, tor_treesp)
tor_tree$street <- str_to_title(tor_tree$street)
# Adding lat and long columns from geometry column
tor_tree$coord <- substr(tor_tree$geometry,3,nchar(tor_tree$geometry)-1)
tor_tree <- separate(data = tor_tree, col = coord, into = c("long", "lat"), sep = "\\, ", remove = TRUE)
# Setting as sf with epsg:6624 projection
tor_tree <- st_as_sf(x = tor_tree, coords = c("long", "lat"), crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0", na.fail = FALSE, remove = FALSE)
tor_tree <- st_transform(tor_tree,crs = "epsg:6624")
#Add park column
tor_treesf <- point.in.poly(tor_tree, tor_park)
View(tor_treesf)
############ Error in st_geos_binop("intersects", x, y, sparse = sparse, prepared = prepared,  : st_crs(x) == st_crs(y) is not TRUE
# Reorder columns
data.frame(colnames(tor_tree))
tor_tree <- tor_tree[,c("city","id","genus","species","cultivar","lat","long","geometry","street","dbh","x","y")]
# Check and make output
tor_tree[tor_tree == ""] <- NA
View(tor_tree)
# saving to large folder
st_write(tor_tree, "large/tor_tree.shp")

## Vancouver tree data cleanup
# Check for dupes
unique(duplicated(van_tree_raw$TREE_ID))
View(van_tree_raw)
# Extract columns needed and rename
data.frame(colnames(van_tree_raw))
van_tree <- van_tree_raw[,c(1,4,5,6,12,13,16,19)]
names(van_tree)[c(1,2,3,4,5,6,7)] <- c("id","genus","species","cultivar","street","hood","dbh")
# Adding and fixing columns
van_tree$city <- c("Vancouver")
van_tree$genus <- str_to_title(van_tree$genus) 
van_tree$species <- tolower(van_tree$species) 
van_tree$species[van_tree$species == "species"] <- "sp."
van_tree$cultivar <- str_to_title(van_tree$cultivar) 
van_tree$street <- str_to_title(van_tree$street) 
van_tree$hood <- str_to_title(van_tree$hood) 
# Converting dbh from inches to cm
van_tree$dbh <- van_tree$dbh*2.54
## Unifying geom column and splitting into additional lat and long columns
van_tree$Geom <- substr(van_tree$Geom,35,nchar(van_tree$Geom)-2)
van_tree <- separate(data = van_tree, col = Geom, into = c("long", "lat"), sep = "\\, ")
# Setting as sf
van_tree <- st_as_sf(x = van_tree, coords = c("long", "lat"), crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0", na.fail = FALSE, remove = FALSE)
#Add park column
van_treesf <- van_tree %>% drop_na(lat)
van_treena <- van_tree %>% is.na(van_tree$lat)
van_treesf <- point.in.poly(van_treesf, van_park)
van_treesf$park <- ifelse(is.na(van_treesf$park),"no","yes")
van_treesf <- st_as_sf(van_treesf)
van_treena <- van_tree %>% filter(is.na(van_tree$lat)) %>% mutate(van_treena, park = c(NA))
van_tree <- rbind(van_treesf, van_treena)
# Reorder columns
data.frame(colnames(van_tree))
van_tree <- van_tree[,c("city","id","genus","species","cultivar","lat","long","geometry","hood","street","park","dbh")]
# Check and make output
View(van_tree)
st_write(van_tree, "large/van_tree.shp")

## Winnipeg tree data cleanup
# Check for dupes
unique(duplicated(win_tree_raw$tree_id))
# Extract columns needed and rename
data.frame(colnames(win_tree_raw))
View(win_tree_raw)
win_tree <- win_tree_raw[,c(1,2,3,5,6,7,9,10,13)]
names(win_tree)[c(2,4,5,6,7,8,9)] <- c("id","dbh","x","y","hood","park","street")
# Adding and fixing columns
win_tree$city <- c("Winnipeg")
win_tree <- win_tree %>% separate(botanical, c("genus","species","var","cultivar"))
win_tree$species[win_tree$species %in% c("", NA,"spp")]<-"sp."
win_tree$var[win_tree$var == "var"] <- NA
win_treesp <- win_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ")
win_treecul <- win_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ")
win_tree <- rbind(win_treecul, win_treesp)
win_tree$hood <- str_to_title(win_tree$hood)
win_tree$park <- ifelse(win_tree$park == "Not In Park","no","yes")
## Unifying geom column and splitting into additional lat and long columns
win_tree$the_geom <- substr(win_tree$the_geom,8,nchar(win_tree$the_geom)-1)
win_tree <- separate(data = win_tree, col = the_geom, into = c("lat", "long"), sep = "\\ ")
win_tree <- st_as_sf(x = win_tree, coords = c("long", "lat"), crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0", na.fail = FALSE, remove = FALSE)
# Reorder columns
data.frame(colnames(win_tree))
win_tree <- win_tree[,c("city","id","genus","species","cultivar","lat","long","geometry","hood","street","park","dbh","x","y")]
# Check and make output
View(win_tree)
st_write(win_tree, "large/win_tree.shp")


#### Unused code ####
win_tree <- win_tree %>%
  dplyr::mutate(lat = sf::st_coordinates(.)[,1],
                lon = sf::st_coordinates(.)[,2])
gsub

# the code took too long, was not run successfully and had to hit esc.
van_park_sf <- van_park  %>% st_intersection(van_tree) 
View(van_park_sf)