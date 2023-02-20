road_class <- function(mun_road, bound_area, scale){
  
  # proportion of highways (ranks 1-3), major streets (rank 4), local streets (rank 5)
  # road density (road length / neighbourhood area)
  
  
  # RANK
  # 1 	Trans-Canada Highway
  # 2 	National Highway System (not rank 1)
  # 3 	Major Highway (not rank 1 or 2)
  # 4 	Secondary Highway, Major Street (not rank 1, 2, or 3)
  # 5 	All other streets (not rank 1, 2, 3, or 4)
  
  
  if (scale == "city"){
    
    bound_area <- bound_area %>%
      mutate(city_area = st_area(geometry))
    
    road_class_city <- st_intersection(mun_road, bound_area) %>%
      group_by(CMANAME) %>%
      mutate(city_area = set_units(city_area, km^2),
             road_length =  set_units(st_length(geometry), km)) %>%
      summarize(city = first(CMANAME), 
                prop_highway = sum(rank == "1" | rank == "2" | rank == "3")/n(),
                prop_majrds = sum(rank == "4")/n(),
                prop_strts = sum(rank == "5")/n(),
                road_length = sum(road_length),
                city_area = first(city_area),
                road_dens = as.numeric(road_length)/as.numeric(city_area)) 
    
    return(road_class_city)

  }
  
  else if (scale == "neighbourhood"){
    
    road_class_neighbourhood <- st_intersection(mun_road, bound_area) %>% 
      group_by(city, hood_id) %>%
      mutate(neighbourhood_area = set_units(hood_area, km^2),
             road_length = set_units(st_length(geometry), km)) %>%
      summarize(prop_highway = sum(rank == "1" | rank == "2" | rank == "3")/n(),
                prop_mjrds = sum(rank == "4")/n(),
                prop_strts = sum(rank == "5")/n(),
                road_length = sum(road_length),
                neighbourhood_area = first(neighbourhood_area),
                road_dens = road_length/neighbourhood_area)
    
    return(road_class_neighbourhood)
  }
  

  
  else{
    print("error: none of the scales matched")
  }
  
  
}