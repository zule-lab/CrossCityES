tree_cleaning <- function(city, trees, parks, hoods, boundaries, roads){
  
  # transformations
  parks <- st_transform(parks, crs = 3347)
  trees <- st_transform(trees, crs = 3347)
  
  # cleaning roads
  city_bound <- subset(boundaries, CMANAME == city)
  city_road <- roads[city_bound,]
  city_road <- dplyr::select(city_road, c("street", "streetid", "geometry"))
  city_road <- city_road %>% dplyr::mutate(index = row_number())
  saveRDS(city_road, paste0("large/national/", city, "RoadsCleaned.rds"))
  
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
    trees <-dplyr::mutate(trees, streetid = st_nearest_feature(trees, city_road), # st_nearest_feature returns the index value not the street name
                          index = match(as.character(trees$streetid), as.character(city_road$index)), # return unique streetid based on index values
                          street = city_road$street[match(trees$index, city_road$index)]) # add column with street name
  }
  else { 
    trees <- trees %>%
      dplyr::rename(munstreetname = street) %>%
      dplyr::mutate(streetid = st_nearest_feature(trees, city_road),
             index = match(as.character(trees$streetid), as.character(city_road$index)),
             street = city_road$street[match(trees$index, city_road$index)])
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
  
  # reordering columns & saving
  trees <- trees[,c("city", "id", "genus", "species", "cultivar", "geometry", "hood", "park", "streetid", "dbh")]# Check and make output
  saveRDS(trees,  paste0("large/trees/", city, "TreesCleaned.rds"))
  
  return(trees)
  
}
