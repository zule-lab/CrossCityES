#### Ottawa public tree inventory cleanup ####
# Author: Nicole Yu


# Ottawa hood data cleanup
data.frame(colnames(ott_hood_raw))
ott_hood <- ott_hood_raw[,c("Name","geometry")]
names(ott_hood)[c(1)] <- "hood"
ott_hood <- st_transform(ott_hood,crs = "epsg:6624")
View(ott_hood)


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
# Extracting rows with geometry available
ott_treesf <- ott_tree %>% drop_na(lat)
# Adding hood column
ott_treesf <- point.in.poly(ott_treesf, ott_hood)
# Adding park column
ott_treesf <- point.in.poly(ott_treesf, ott_park)
ott_treesf$park <- ifelse(is.na(ott_treesf$park),"no","yes")
ott_treesf <- st_as_sf(ott_treesf)
ott_treesf <- ott_treesf[,-c(8)]
names(ott_treesf)[8] <- "hood"
# Adding back rows without geometry available
ott_treena <- ott_tree %>% filter(is.na(ott_tree$lat)) %>% mutate(ott_treena, hood = c(NA), park = c(NA))
ott_tree <- rbind(ott_treesf, ott_treena)
data.frame(colnames(ott_tree))
#Adding street column
ott_tree$street <- st_nearest_feature(ott_tree, can_road)
# Reorder columns
data.frame(colnames(ott_tree))
ott_tree <- ott_tree[,c("city","id","SPECIES","lat","long","geometry","hood","street","park","dbh")]
# Check and make output
######## This code not working? ott_tree[ott_tree == ""] <- NA
View(ott_tree)
st_write(ott_tree, "large/ott_tree.shp")


can_road(C)

