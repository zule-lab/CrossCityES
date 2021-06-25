library(tidyr)


## Winnipeg tree cleanup
# Check for dupes
duplicated(win_tree_raw)
# Extract columns needed and rename
win_tree_raw
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
win_tree <- win_tree[,c(9,1,10,2,5,6,7,8,3,4)]

# Check output
View(win_tree)


### Unused code

win_tree <- win_tree %>%
  dplyr::mutate(lat = sf::st_coordinates(.)[,1],
                lon = sf::st_coordinates(.)[,2])
gsub
