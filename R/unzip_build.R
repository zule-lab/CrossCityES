unzip_build <- function(){
  # Alberta
  unzip("large/national/Alberta_building_density.zip", exdir = "large/national/ABBuildings")
  # Nova Scotia
  unzip("large/national/NovaScotia_building_density.zip", exdir = "large/national/NSBuildings")
  # Quebec
  unzip("large/national/Quebec_building_density.zip", exdir = "large/national/QCBuildings")
  # Ontario
  unzip("large/national/Ontario_building_density.zip", exdir = "large/national/ONBuildings")
  # British Columbia
  unzip("large/national/BritishColumbia_building_density.zip", exdir = "large/national/BCBuildings")
  # Manitoba
  unzip("large/national/Manitoba_building_density.zip", exdir = "large/national/MBBuildings")
}