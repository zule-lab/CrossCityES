height_data_neighbourhood_road <- c(
  
  tar_target(
    van_city_height, 
    height_city(van_build_height, 'vancouver.tif', "Vancouver")
  ),
  
  tar_target(
    van_hood_height,
    height_hood(van_hood, van_build_height, 'vancouver.tif')
  ),
  
  tar_target(
    van_road_height,
    height_road(mun_road, van_build_height, 'vancouver.tif')
  ),
  
  tar_target(
    cal_city_height, 
    height_city(cal_build_height, 'calgarywest.tif', "Calgary")
  ),
  
  tar_target(
    cal_hood_height,
    height_hood(cal_hood, cal_build_height, 'calgarywest.tif')
  ),
  
  tar_target(
    cal_road_height,
    height_road(mun_road, cal_build_height, 'calgarywest.tif')
  ),
  
  tar_target(
    win_city_height, 
    height_city(win_build_height, 'winnipegne.tif', "Winnipeg")
  ),
  
  tar_target(
    win_hood_height,
    height_hood(win_hood, win_build_height, 'winnipegne.tif')
  ),
  
  tar_target(
    win_road_height,
    height_road(mun_road, win_build_height, 'winnipegne.tif')
  ),
  
  tar_target(
    tor_city_height,
    height_city(tor_build_height, 'torontone.tif', "Toronto")
  ),
  
  tar_target(
    tor_hood_height,
    height_hood(tor_hood, tor_build_height, 'torontone.tif')
  ),
  
  tar_target(
    tor_road_height,
    height_road(mun_road, tor_build_height, 'torontone.tif')
  ),
  
  tar_target(
    ott_city_height,
    height_city(ott_build_height, 'ottawane.tif', "Ottawa")
  ),
  
  tar_target(
    ott_hood_height,
    height_hood(ott_hood, ott_build_height, 'ottawane.tif')
  ),
  
  tar_target(
    ott_road_height,
    height_road(mun_road, ott_build_height, 'ottawane.tif')
  ),
  
  tar_target(
    mon_city_height,
    height_city(mon_build_height, 'cotesaintluc.tif', "Montreal")
  ),

  tar_target(
    mon_hood_height,
    height_hood(mon_hood, mon_build_height, 'cotesaintluc.tif')
  ),
  
  tar_target(
    mon_road_height,
    height_road(mun_road, mon_build_height, 'cotesaintluc.tif')
  ),
  
  tar_target(
    hal_city_height, 
    height_city(hal_build_height, 'halifax.tif', "Halifax")
  ),
  
  tar_target(
    hal_hood_height,
    height_hood(hal_hood, hal_build_height, 'halifax.tif')
  ),
  
  tar_target(
    hal_road_height,
    height_road(mun_road, hal_build_height, 'halifax.tif')
  ),
  
  tar_target(
    city_height, 
    rbind(van_city_height, cal_city_height, win_city_height, tor_city_height, ott_city_height, mon_city_height, hal_city_height)
  ),
  
  tar_target(
    hood_height, 
    rbind(van_hood_height, cal_hood_height, win_hood_height, tor_hood_height, ott_hood_height, mon_hood_height, hal_hood_height)
  ),
  
  tar_target(
    road_height, 
    rbind(van_road_height, cal_road_height, win_road_height, tor_road_height, ott_road_height, mon_road_height, hal_road_height)
  )
  
)