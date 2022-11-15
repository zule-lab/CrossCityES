dsm_data_cleanup <- c(
  
  tar_target(
    van_dsm,
    read_stars("large/dsm/vancouver.tif")
  ),
  
  tar_target(
    van_w_dsm,
    read_stars("large/dsm/vancouver_west.tif")
  ),
  
  tar_target(
    cal_w_dsm,
    read_stars("large/dsm/calgarywest.tif")
  ),
  
  tar_target(
    cal_e_dsm,
    read_stars("large/dsm/calgaryeast.tif")
  ),
  
  tar_target(
    van_build_height, 
    building_height(r1 = van_dsm, van_w_dsm, buildings = van_build)
  ),
  
  tar_target(
    cal_build_height,
    building_height(r1 = cal_w_dsm, cal_e_dsm, buildings = cal_build)
  ),
  
  tar_target(
    win_build_height,
    building_height()
  ),
  
  tar_target(
    tor_build_height,
    building_height()
  ),
  
  tar_target(
    ott_build_height,
    building_height()
  )
  
#  tar_target(
#    mon_build_height, 
#    building_height()
#  ),
#  
#  tar_target(
#    hal_build_height,
#    building_height()
#  )
# 
)