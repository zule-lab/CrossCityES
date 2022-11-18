roadclass_data_city_neighbourhood <- c(
  
  # proportion of highways (ranks 1-3), major streets (rank 4), local streets (rank 5)
  # road density (road length / neighbourhood area)
  
  
  # RANK
  # 1 	Trans-Canada Highway
  # 2 	National Highway System (not rank 1)
  # 3 	Major Highway (not rank 1 or 2)
  # 4 	Secondary Highway, Major Street (not rank 1, 2, or 3)
  # 5 	All other streets (not rank 1, 2, 3, or 4)
  
  tar_target(
    city_road_prop,
    mun_road %>% 
      group_by(CMANAME) %>%
      summarize(PropHighway = sum(rank == "1" | rank == "2" | rank == "3")/n(),
                PropMajRoads = sum(rank == "4")/n(),
                PropStreets = sum(rank == "5")/n())
  ),
  
  tar_target(
    city_road_density, 
    mun_road %>%
      group_by(CMANAME) %>% 
      summarize(RoadLength = sum(st_length(geometry)))
  ),
  
  tar_target(
    hood_road_prop,
    st_intersection(mun_road, can_hood) %>% 
      group_by(city, hood_id) %>%
      summarize(PropHighway = sum(rank == "1" | rank == "2" | rank == "3")/n(),
                PropMajRoads = sum(rank == "4")/n(),
                PropStreets = sum(rank == "5")/n())
  )
  
  
  
  
)