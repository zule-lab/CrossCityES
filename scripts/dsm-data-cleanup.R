dsm_data_cleanup <- c(
  
  tar_target(
    van_dsm,
    st_mosaic(van_1_dsm, van_2_dsm) %>%
      st_transform(., crs = st_crs(van_build))
  ),
  
  tar_target(
    cal_dsm,
    st_mosaic(cal_1_dsm, cal_2_dsm, cal_3_dsm, cal_4_dsm, cal_5_dsm, cal_6_dsm, cal_7_dsm, cal_8_dsm, cal_9_dsm, cal_10_dsm, cal_11_dsm, cal_12_dsm, cal_13_dsm) %>%
      st_transform(., crs = st_crs(cal_build))
  ),
  
  tar_target(
    win_dsm,
    st_mosaic(win_1_dsm, win_2_dsm, win_3_dsm, win_4_dsm, win_5_dsm, win_6_dsm, win_7_dsm) %>%
      st_transform(., crs = st_crs(win_build))
  ),
  
  tar_target(
    tor_dsm,
    st_mosaic(tor_1_dsm, tor_2_dsm, tor_3_dsm, tor_4_dsm, tor_5_dsm, tor_6_dsm, tor_7_dsm, tor_8_dsm, tor_9_dsm, tor_10_dsm, tor_11_dsm, tor_12_dsm) %>%
      st_transform(., crs = st_crs(tor_build))
  ),
  
  tar_target(
    ott_dsm,
    st_mosaic(ott_1_dsm, ott_2_dsm, ott_3_dsm, ott_4_dsm, ott_5_dsm, ott_6_dsm, ott_7_dsm, ott_8_dsm, ott_9_dsm, ott_10_dsm, ott_11_dsm, ott_12_dsm, 
              ott_13_dsm, ott_14_dsm, ott_15_dsm, ott_16_dsm, ott_17_dsm, ott_18_dsm, ott_19_dsm, ott_20_dsm, ott_21_dsm, ott_22_dsm, ott_23_dsm,
              ott_24_dsm, ott_25_dsm) %>%
      st_transform(., crs = st_crs(ott_build))
  ),
  
  tar_target(
    mon_dsm,
    st_mosaic(mon_1_dsm, mon_2_dsm, mon_3_dsm, mon_4_dsm, mon_5_dsm, mon_6_dsm, mon_7_dsm, mon_8_dsm) %>%
      st_transform(., crs = st_crs(mon_build))
  ),
  
  tar_target(
    hal_dsm,
    st_mosaic(hal_1_dsm, hal_2_dsm, hal_3_dsm) %>%
      st_transform(., crs = st_crs(hal_build))
  ),
  
  tar_target(
    van_dtm,
    st_mosaic(van_1_dtm, van_2_dtm) %>%
      st_transform(., crs = st_crs(van_build))
  ),
  
  tar_target(
    cal_dtm,
    st_mosaic(cal_1_dtm, cal_2_dtm, cal_3_dtm, cal_4_dtm, cal_5_dtm, cal_6_dtm, cal_7_dtm, cal_8_dtm, cal_9_dtm, cal_10_dtm, cal_11_dtm, cal_12_dtm, cal_13_dtm) %>%
      st_transform(., crs = st_crs(cal_build))
  ),
  
  tar_target(
    win_dtm,
    st_mosaic(win_1_dtm, win_2_dtm, win_3_dtm, win_4_dtm, win_5_dtm, win_6_dtm, win_7_dtm) %>%
      st_transform(., crs = st_crs(win_build))
  ),
  
  tar_target(
    tor_dtm,
    st_mosaic(tor_1_dtm, tor_2_dtm, tor_3_dtm, tor_4_dtm, tor_5_dtm, tor_6_dtm, tor_7_dtm, tor_8_dtm, tor_9_dtm, tor_10_dtm, tor_11_dtm, tor_12_dtm) %>%
      st_transform(., crs = st_crs(tor_build))
  ),
  
  tar_target(
    ott_dtm,
    st_mosaic(ott_1_dtm, ott_2_dtm, ott_3_dtm, ott_4_dtm, ott_5_dtm, ott_6_dtm, ott_7_dtm, ott_8_dtm, ott_9_dtm, ott_10_dtm, ott_11_dtm, ott_12_dtm, 
              ott_13_dtm, ott_14_dtm, ott_15_dtm, ott_16_dtm, ott_17_dtm, ott_18_dtm, ott_19_dtm, ott_20_dtm, ott_21_dtm, ott_22_dtm, ott_23_dtm,
              ott_24_dtm, ott_25_dtm) %>%
      st_transform(., crs = st_crs(ott_build))
  ),
  
  tar_target(
    mon_dtm,
    st_mosaic(mon_1_dtm, mon_2_dtm, mon_3_dtm, mon_4_dtm, mon_5_dtm, mon_6_dtm, mon_7_dtm, mon_8_dtm) %>%
      st_transform(., crs = st_crs(mon_build))
  ),
  
  tar_target(
    hal_dtm,
    st_mosaic(hal_1_dtm, hal_2_dtm, hal_3_dtm) %>%
      st_transform(., crs = st_crs(hal_build))
  ),
  
  tar_target(
    van_dem,
    van_dsm - van_dtm
  ),
  
  tar_target(
    cal_dem,
    cal_dsm - cal_dtm
  ),
  
  tar_target(
    win_dem,
    win_dsm - win_dtm
  ),
  
  tar_target(
    tor_dem,
    tor_dsm - tor_dtm
  ),
  
  tar_target(
    ott_dem,
    ott_dsm - ott_dtm
  ),
  
  tar_target(
    mon_dem,
    mon_dsm - mon_dtm
  ),
  
  tar_target(
    hal_dem,
    hal_dsm - hal_dtm
  ),
  
  tar_target(
    van_build_height, 
    building_height(van_dem, buildings = van_build)
  ),
  
  tar_target(
    cal_build_height,
    building_height(cal_dem, buildings = cal_build)
  ),
  
  tar_target(
    win_build_height,
    building_height(win_dem, buildings = win_build)
  ),
  
  tar_target(
    tor_build_height,
    building_height(tor_dem, buildings = tor_build)
  ),
  
  tar_target(
    ott_build_height,
    building_height(ott_dem, buildings = ott_build)
  ),
  
  tar_target(
    mon_build_height, 
    building_height(mon_dem, buildings = mon_build)
  ),
  
  tar_target(
    hal_build_height,
    building_height(hal_dem, buildings = hal_build)
  )
 
)