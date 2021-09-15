tree_cleaning <- function(city, trees, parks, hoods, boundaries, roads){
  p <- c("sf", "dplyr", "tidyr")
  lapply(p, library, character.only = T)
  
  parks <- st_transform(parks, crs = 3347)
  trees <- st_transform(trees, crs = 3347)
  saveRDS(parks, paste0("large/parks/", city, "ParksCleaned.rds"))
  
  city_bound <- subset(boundaries, bound == city)
  city_road <- roads[city_bound,]
  city_road <- select(city_road, c("street", "streetid", "geometry"))
  city_road <- city_road %>% mutate(index = 1:n())
  saveRDS(city_road, paste0("large/national/", city, "RoadsCleaned.rds"))
  
  trees <- st_join(trees, hoods, join = st_intersects)
  trees <- st_join(trees, parks, join = st_intersects)
  
  dup <- trees$id[duplicated(trees$id)]
  trees <- trees %>% filter(!id %in% dup)
  # replace NAs with "no" to indicate street trees 
  trees <- mutate(trees, park = replace_na(park, "no"))
  # if value is not "no", change value to "yes" so park column is binary yes/no
  trees <- mutate(trees, park = ifelse(park == "no", "no", "yes"))
  
  
  if ("street" %in% colnames(trees) == "FALSE") {
    # st_nearest_feature returns the index value not the street name
    trees <- mutate(trees, streetid = st_nearest_feature(trees, city_road))
    # return unique streetid based on index values
    trees <- mutate(trees, index = match(as.character(trees$streetid), as.character(city_road$index)))
    # add column with street name
    trees <- mutate(trees, street = city_road$street[match(trees$index, city_road$index)])
  }
  else { NULL }
  
  
  if ("hood" %in% colnames(trees) == "FALSE") {
    trees <- st_join(trees, hoods)
  }
  else { NULL }
  
  trees <- trees %>% filter(park == "no")
  
  trees <- trees[city_bound,]
  
  # reorder columns
  trees <- trees[,c("city","id","genus", "species", "cultivar", "geometry","hood","streetid","park", "street", "dbh")]# Check and make output
  
  saveRDS(trees,  paste0("large/trees/", city, "TreesCleaned.rds"))
}
