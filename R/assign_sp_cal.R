assign_sp_cal <- function(cal_tree_raw){
  
  # assign blanks and NAs in species column to "sp."
  cal_tree_raw$species[cal_tree_raw$species %in% c("",NA)]<-"sp."
  cal_tree_raw$species[cal_tree_raw$species == "deltoides / balsamifera (?)"] <- "sp."
  # remove quotations from cultivar names 
  cal_tree_raw$cultivar <- substr(cal_tree_raw$cultivar,2,nchar(cal_tree_raw$cultivar)-1)
  
  return(cal_tree_raw)
  
}