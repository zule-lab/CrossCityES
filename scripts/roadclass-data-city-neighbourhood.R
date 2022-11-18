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
      inner_join(mun_road, st_set_geometry(mun_bound_area, NULL), by = "CMANAME") %>%
      group_by(CMANAME) %>%
      mutate(CityArea = set_units(city_area, km^2),
             RoadLength = set_units(st_length(geometry), km)) %>%
      summarize(PropHighway = sum(rank == "1" | rank == "2" | rank == "3")/n(),
                PropMajRoads = sum(rank == "4")/n(),
                PropStreets = sum(rank == "5")/n(),
                RoadLength = sum(RoadLength),
                CityArea = first(CityArea),
                RoadDens = RoadLength/CityArea)
  ),
  
  tar_target(
    hood_road_prop,
    st_intersection(mun_road, can_hood) %>% 
      group_by(city, hood_id) %>%
      mutate(HoodArea = set_units(hood_area, km^2),
             RoadLength = set_units(st_length(geometry), km)) %>%
      summarize(PropHighway = sum(rank == "1" | rank == "2" | rank == "3")/n(),
                PropMajRoads = sum(rank == "4")/n(),
                PropStreets = sum(rank == "5")/n(),
                RoadLength = sum(RoadLength),
                HoodArea = first(HoodArea),
                RoadDens = RoadLength/HoodArea)
  )
  
)