name_list <- function(ee_data_unnamed, paths){
  
  names(ee_data_unnamed) <- basename(sans_ext(paths))
  
  return(ee_data_unnamed)
  
}