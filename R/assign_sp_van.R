assign_sp_van <- function(van_tree){
  
  # change "species in species" column to "sp."
  van_tree$species[van_tree$species == "SPECIES"] <- "sp."
  van_tree$species[van_tree$species == "XX"] <- "sp."
  # convert empty as NA for cultivar
  van_tree$cultivar[van_tree$cultivar == ""] <- NA
  # converting dbh from inches to cm
  van_tree$dbh <- van_tree$dbh*2.54

  }