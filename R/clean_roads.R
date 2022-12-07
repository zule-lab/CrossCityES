clean_roads <- function(mun_bound, road_raw){ 
  
  # select relevant columns
  road_raw_s <- road_raw[,c("NAME", "TYPE", "DIR", "NGD_UID", "RANK", "CLASS", "geometry")]
  
  # rename columns to be more interpretable and reproject
  road_raw_r <- road_raw_s %>%
    rename(street = NAME,
           streettype = TYPE,
           streetdir = DIR,
           streetid = NGD_UID,
           rank = RANK,
           class = CLASS) %>%
    st_transform(crs = 3347)
  
  # select roads within relevant municipalities
  mun_road_i <- road_raw_r[mun_bound,]
  
  # join road data with municipal 
  mun_road <- st_join(mun_road_i, mun_bound)
  
  
  }