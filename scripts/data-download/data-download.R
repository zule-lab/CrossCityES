targets_data_download <- c(

  # Microsoft Building Footprints -------------------------------------------
  tar_target(
    prov_list,
    c("Alberta", "NovaScotia", "Quebec", "Ontario", "BritishColumbia", "Manitoba")
  ),
  
  tar_target(
    build_raw,
    for (i in 1:length(prov_list)){
      build_url <- paste0("https://usbuildingdata.blob.core.windows.net/canadian-buildings-v2/", prov_list, ".zip")
      build_dest <- paste0("large/national/", prov_list, "_building_density.zip")
      build_output <- paste0("large/national/", prov_list, "_building_density")
      download.file(build_url[i], build_dest[i], mode="wb")
    }
  )

)