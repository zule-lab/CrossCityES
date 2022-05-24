assign_sp_cal <- function(cal_tree){
  
  # assign blanks and NAs in species column to "sp."
  cal_tree$species[cal_tree$species %in% c("",NA)]<-"sp."
  cal_tree$species[cal_tree$species == "deltoides / balsamifera (?)"] <- "sp."
  # remove quotations from cultivar names 
  cal_tree$cultivar <- substr(cal_tree$cultivar,2,nchar(cal_tree$cultivar)-1)
  
  return(cal_tree)
  
}