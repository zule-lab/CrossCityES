library(tidyr)

## Calgary tree cleanup
# Check for dupes
duplicated(cal_tree_raw)
# Extract columns needed and rename
data.frame(colnames(cal_tree_raw))
cal_tree <- cal_tree_raw[,c(5,6,7,9,16,17,20)]
names(cal_tree)[c(1,4,5,6,7)] <- c("genus", "dbh","id","hood","coord")

# Adding and fixing columns
cal_tree$city <- c("Calgary")
cal_tree$SPECIES[cal_tree$SPECIES==""]<-"sp."
cal_tree$botname <- paste(cal_tree$genus, cal_tree$SPECIES, cal_tree$CULTIVAR)
cal_tree <- cal_tree[,c(-2,-3)]

## Turning geom column into lat and long
# want to use gsub/sub to extract all digits inc. the decimal point if possible
cal_tree$coord <- substr(cal_tree$coord,2,nchar(cal_tree$coord)-1)
cal_tree <- separate(data = cal_tree, col = coord, into = c("lat", "long"), sep = "\\, ")

# Reorder columns
data.frame(colnames(cal_tree))
cal_tree <- cal_tree[,c(9,3,1,10,6,5,7,8)]


# Check and make output
View(cal_tree)
write.csv(cal_tree, "/Users/nicoleyu/Desktop/GRI ZULE/cross-city-es/output/cal_tree.csv", row.names=FALSE)






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








## Winnipeg tree cleanup
# Check for dupes
duplicated(win_tree_raw)
# Extract columns needed and rename
data.frame(colnames(win_tree_raw))
win_tree <- win_tree_raw[,c(1,2,5,6,12,13,15)]
names(win_tree)[c(1,2,3,4,5,6,7)] <- c("id", "botname","hood","dbh","x","y","coord")

# Add uniform columns
win_tree$city <- c("Winnipeg")
win_tree$genus <- sub("([A-Za-z]+).*", "\\1", win_tree$botname)

## Turning geom column into lat and long
# want to use gsub/sub to extract all digits inc. the decimal point if possible
win_tree$coord <- substr(win_tree$coord,2,nchar(win_tree$coord)-1)
win_tree <- separate(data = win_tree, col = coord, into = c("lat", "long"), sep = "\\, ")

# Reorder columns
data.frame(colnames(win_tree))
win_tree <- win_tree[,c("city","id","genus","botname","lat","long","hood","dbh","x","y")]

# Check and make output
View(win_tree)
write.csv(win_tree, "/Users/nicoleyu/Desktop/GRI ZULE/cross-city-es/output/win_tree.csv", row.names=FALSE)


### Unused code

win_tree <- win_tree %>%
  dplyr::mutate(lat = sf::st_coordinates(.)[,1],
                lon = sf::st_coordinates(.)[,2])
gsub
