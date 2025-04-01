clean_ee <- function(dl_link, dl_path, file_ext){
  
  drive_download(file = dl_link, path = dl_path, type = file_ext, overwrite = T)
  
  # read downloaded file
  file <- read.csv(dl_path)
  
  # extract the folder path
  folder <- dirname(dl_path)
  
  ee <- clean_sat(folder, file, dl_path)
  
  return(ee)
  
}

clean_sat <- function(folder, file, dl_path){
  
  if (folder == 'large/ndvi_ndbi'){
    
    label <- ""
    
    # remove system:index and geo columns because they are not in useable format
    df <- file %>% 
      rename_with(., ~ paste0(.x, "_", label), .cols = all_of(c("NDBI_count", "NDBI_max",	"NDBI_mean",	"NDBI_median",
                                                                "NDBI_min",	"NDBI_stdDev",	"NDVI_count",	"NDVI_max",
                                                                "NDVI_mean",	"NDVI_median",	"NDVI_min",	"NDVI_stdDev")))
    
    return(df)
    
    
  }
  
  else if (folder == 'large/temperature'){
    
    label <- "temp"
    
    df <- file %>% 
      rename_with(., ~ paste0(.x, "_", label), .cols = all_of(c("mean", "median", "max", "min", "count", "stdDev")))
    
    return(df)
  
    
  }
  
  else if (folder == 'large/dem'){
    
    label <- "bldhgt"
    
    df <- file %>% select(-c('system.index', '.geo')) %>% 
      rename_with(., ~ paste0(.x, "_", label), .cols = all_of(c("mean", "stdDev")))
    
    return(df)

    
  }
  
  else if (folder == 'large/pollution'){
    
    label <- basename(sans_ext(dl_path))
    
    df <- file %>% 
      rename_with(., ~ paste0(.x, "_", label), .cols = all_of(c("mean", "median", "max", "min", "count", "stdDev")))
    
    return(df)
    
    
  }
  
  
  else {
    print("error: none of the folder paths matched")
  }
  
  
}
