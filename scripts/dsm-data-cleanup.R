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
    win_ne_dsm,
    read_stars("large/dsm/winnipegne.tif")
  ),
  
  tar_target(
    win_nw_dsm,
    read_stars("large/dsm/winnipegnw.tif")
  ),
  
  tar_target(
    win_se_dsm,
    read_stars("large/dsm/winnipegse.tif")
  ),
  
  tar_target(
    win_sw_dsm,
    read_stars("large/dsm/winnipegsw.tif")
  ),
  
  tar_target(
    tor_ne_dsm,
    read_stars("large/dsm/torontone.tif")
  ),
  
  tar_target(
    tor_nw_dsm,
    read_stars("large/dsm/torontonw.tif")
  ),
  
  tar_target(
    tor_se_dsm,
    read_stars("large/dsm/torontose.tif")
  ),
  
  tar_target(
    tor_sw_dsm,
    read_stars("large/dsm/torontosw.tif")
  ),
  
  tar_target(
    ott_ne_dsm,
    read_stars("large/dsm/ottawane.tif")
  ),
  
  tar_target(
    ott_nw_dsm,
    read_stars("large/dsm/ottawanw.tif")
  ),
  
  tar_target(
    ott_se_dsm,
    read_stars("large/dsm/ottawase.tif")
  ),
  
  tar_target(
    ott_sw_dsm,
    read_stars("large/dsm/ottawasw.tif")
  ),
  
  tar_target(
    mon_1_dsm,
    read_stars("large/dsm/cotesaintluc.tif")
  ),
  
  tar_target(
    mon_2_dsm, 
    read_stars("large/dsm/dollardesormeaux.tif")
  ),
  
  tar_target(
    mon_3_dsm,
    read_stars("large/dsm/ilebizard.tif")
  ),
  
  tar_target(
    mon_4_dsm,
    read_stars("large/dsm/montrealest.tif")
  ),
  
  tar_target(
    mon_5_dsm,
    read_stars("large/dsm/saintleonard.tif")
  ),
  
  tar_target(
    mon_6_dsm,
    read_stars("large/dsm/villeray_PartieNO.tif")
  ),
  
  tar_target(
    mon_7_dsm,
    read_stars("large/dsm/westmount.tif")
  ),
  
  tar_target(
    hal_dsm,
    read_stars("large/dsm/halifax.tif")
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
    building_height(r1 = win_ne_dsm, win_nw_dsm, win_se_dsm, win_sw_dsm, buildings = win_build)
  ),
  
  tar_target(
    tor_build_height,
    building_height(r1 = tor_ne_dsm, tor_nw_dsm, tor_se_dsm, tor_sw_dsm, buildings = tor_build)
  ),
  
  tar_target(
    ott_build_height,
    building_height(r1 = ott_ne_dsm, ott_nw_dsm, ott_se_dsm, ott_sw_dsm, buildings = ott_build)
  ),
  
  tar_target(
    mon_build_height, 
    building_height(r1 = mon_1_dsm, mon_2_dsm, mon_3_dsm, mon_4_dsm, mon_5_dsm, mon_6_dsm, mon_7_dsm, buildings = mon_build)
  ),
  
  tar_target(
    hal_build_height,
    building_height(r1 = hal_dsm, buildings = hal_build)
  )
 
)