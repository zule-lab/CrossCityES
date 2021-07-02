# Script to cleanup raw data

#### Packages ####
easypackages::packages("tidyr", "tidyverse", "Rmisc","stringr")

#### City tree data cleanup ####

## Calgary tree data cleanup
# Check for dupes
unique(duplicated(cal_tree_raw$WAM_ID))
# Extract columns needed and rename
data.frame(colnames(cal_tree_raw))
cal_tree <- cal_tree_raw[,c(5,6,7,9,16,17,20)]
names(cal_tree)[c(1,2,3,4,5,6,7)] <- c("genus","species","cultivar", "dbh","id","hood","coord")
# Adding and fixing columns
cal_tree$city <- c("Calgary")
cal_tree$species[cal_tree$species %in% c("",NA)]<-"sp."
# Turning geom column into lat and long
cal_tree$coord <- substr(cal_tree$coord,2,nchar(cal_tree$coord)-1)
cal_tree <- separate(data = cal_tree, col = coord, into = c("lat", "long"), sep = "\\, ")
# Reorder columns
data.frame(colnames(cal_tree))
cal_tree <- cal_tree[c("city", "id", "genus","species","cultivar","lat","long","hood","dbh")]
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
ott_tree <- ott_tree_raw[,c(1,2,3,12,13)]
names(ott_tree)[c(1,2,3,5)] <- c("long","lat","id","dbh")
# Adding and fixing columns
ott_tree$city <- c("Ottawa")
# Reorder columns
data.frame(colnames(ott_tree))
ott_tree <- ott_tree[,c("city","id","lat","long","dbh","SPECIES")]
# Check and make output
ott_tree[ott_tree == ""] <- NA
View(ott_tree)
write.csv(ott_tree, "output/ott_tree.csv", row.names=FALSE)

## Toronto tree data cleanup
# Check for dupes
unique(duplicated(tor_tree_raw$STRUCTID))
# Extract columns needed and rename
data.frame(colnames(tor_tree_raw))
tor_tree <- data.frame(tor_tree_raw[,c(2,3,4,8,11,12)])
names(tor_tree)[c(1,2,3,4,6)] <- c("x","y","id","dbh","coord")
# Adding and fixing columns
tor_tree$city <- c("Toronto")
tor_tree <- tor_tree %>% separate(BOTANICAL_, c("genus","species","var","cultivar", "cultivar2"))
tor_tree$species[tor_tree$species == "sp"] <- "sp."
tor_tree$species[tor_tree$species == "X"] <- "x"
tor_tree$var[tor_tree$var == "var"] <- NA
tor_treecul <- tor_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar", "cultivar2"), na.rm = TRUE, sep = " ")
tor_treesp <- tor_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ") %>% unite(cultivar, c("cultivar", "cultivar2"), na.rm = TRUE, sep = " ")
tor_tree <- rbind(tor_treecul, tor_treesp)
## Turning geom column into lat and long
tor_tree$coord <- substr(tor_tree$coord,3,nchar(tor_tree$coord)-1)
tor_tree <- separate(data = tor_tree, col = coord, into = c("long", "lat"), sep = "\\, ")
# Reorder columns
data.frame(colnames(tor_tree))
tor_tree <- tor_tree[,c("city","id","genus","species","cultivar","lat","long","dbh","x","y")]
# Check and make output
tor_tree[tor_tree == ""] <- NA
View(tor_tree)
# saving to large folder
write.csv(tor_tree, "large/tor_tree.csv", row.names=FALSE)

## Vancouver tree data cleanup
# Check for dupes
unique(duplicated(van_tree_raw$TREE_ID))
# Extract columns needed and rename
data.frame(colnames(van_tree_raw))
van_tree <- van_tree_raw[,c(1,4,5,6,13,16,19)]
names(van_tree)[c(1,2,3,4,5,6,7)] <- c("id","genus","species","cultivar","hood","dbh","coord")
# Adding and fixing columns
van_tree$city <- c("Vancouver")
## Turning geom column into lat and long
van_tree$coord <- substr(van_tree$coord,35,nchar(van_tree$coord)-2)
van_tree <- separate(data = van_tree, col = coord, into = c("long", "lat"), sep = "\\, ")
van_tree$genus <- str_to_title(van_tree$genus) 
van_tree$species <- tolower(van_tree$species) 
van_tree$cultivar <- str_to_title(van_tree$cultivar) 
van_tree$hood <- str_to_title(van_tree$hood) 
# Reorder columns
data.frame(colnames(van_tree))
van_tree <- van_tree[,c("city","id","genus","species","cultivar","lat","long","hood","dbh")]
# Check and make output
van_tree[van_tree == ""] <- NA
View(van_tree)
write.csv(van_tree, "output/van_tree.csv", row.names=FALSE)

## Winnipeg tree data cleanup
# Check for dupes
unique(duplicated(win_tree_raw$Tree.ID))
# Extract columns needed and rename
data.frame(colnames(win_tree_raw))
View(win_tree_raw)
win_tree <- win_tree_raw[,c(1,2,5,6,12,13,15)]
names(win_tree)[c(1,3,4,5,6,7)] <- c("id","hood","dbh","x","y","coord")
# Adding and fixing columns
win_tree$city <- c("Winnipeg")
win_tree <- win_tree %>% separate(Botanical.Name, c("genus","species","var","cultivar"))
win_tree$species[win_tree$species %in% c("", NA)]<-"sp."
win_tree$var[win_tree$var == "var"] <- NA
win_treecul <- win_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ")
win_treesp <- win_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ")
win_tree <- rbind(win_treecul, win_treesp)
win_tree$hood <- str_to_title(win_tree$hood) 
## Turning geom column into lat and long
win_tree$coord <- substr(win_tree$coord,2,nchar(win_tree$coord)-1)
win_tree <- separate(data = win_tree, col = coord, into = c("lat", "long"), sep = "\\, ")
# Reorder columns
data.frame(colnames(win_tree))
win_tree <- win_tree[,c("city","id","genus","species","cultivar","lat","long","hood","dbh","x","y")]
# Check and make output
win_tree[win_tree == ""] <- NA
View(win_tree)
write.csv(win_tree, "output/win_tree.csv", row.names=FALSE)

#### Unused code ####
win_tree <- win_tree %>%
  dplyr::mutate(lat = sf::st_coordinates(.)[,1],
                lon = sf::st_coordinates(.)[,2])
gsub
