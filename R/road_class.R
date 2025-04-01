road_class <- function(mun_road, bound_area, scale){
  
  # proportion of highways and streets
  # road density (road length / neighbourhood area)
  
  # CLASS
  # 10 	Highway
  # 11 	Expressway
  # 12 	Primary highway
  # 13 	Secondary highway
  # 20 	Road
  # 21 	Arterial
  # 22 	Collector
  # 23 	Local
  # 24 	Alley / Lane / Utility
  # 25 	Connector / Ramp
  # 26 	Reserve / Trail
  # 27 	Rapid transit
  # 28 	Planned
  # 29 	Strata
  # 80 	Bridge / Tunnel
  # 87 	Winter
  # 90 	Unknown
  
  # highways: 10, 11, 12, 13, 25, 80 
  # regular roads: 20, 21, 22, 23, 24, 29
  
  if (scale == "city"){
    
    bound_area <- bound_area %>%
      mutate(city_area = st_area(geometry))
    
    road_class_city <- st_intersection(mun_road, bound_area) %>%
      group_by(CMANAME) %>%
      mutate(city_area = set_units(city_area, km^2),
             road_length =  set_units(st_length(geometry), km)) %>%
      summarize(city = first(CMANAME), 
                prop_highway = sum(class == "10" | class == "11" | class == "12" | class == "13" | class == "25" | class == "80")/n(),
                prop_strts = sum(class == "20" | class == "21" | class == "22" | class == "23" | class == "24" | class == "29")/n(),
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