assign_sp_hal <- function(hal_tree, hal_tree_spcode, hal_tree_dbhcode){
  
  # recode species from code to scientific name
  hal_tree$botname <- hal_tree_spcode$botname[match(as.character(hal_tree$SP_SCIEN), as.character(hal_tree_spcode$code))]
  # sorting species name into genus, species, and cultivar columns
  hal_tree <- hal_tree %>% separate(botname, c("genus","species","var","cultivar"))
  hal_tree$var[hal_tree$var == "var"] <- NA
  hal_treecul <- hal_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ")
  hal_treesp <- hal_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ")
  hal_tree <- rbind(hal_treecul, hal_treesp)
  hal_tree$cultivar[hal_tree$cultivar == ""] <- NA
  # assign blanks and NAs in species column to "sp."
  hal_tree$species[hal_tree$species %in% c("",NA)] <- "sp."
  # Assign "species" column as NA for "Unknown Species"
  hal_tree$species[hal_tree$species == "Species"] <- NA
  # recode dbh from categories to median measurements
  hal_tree$dbh <- hal_tree_dbhcode$dbh[match(as.character(hal_tree$dbh), as.character(hal_tree_dbhcode$code))]
  
  return(hal_tree)
  
}