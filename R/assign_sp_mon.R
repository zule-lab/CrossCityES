assign_sp_mon <- function(mon_tree){
  
  # dealing with problematic species names 
  mal <- plyr::colwise(function(x) str_replace_all(x, "Malus x", "Malus sp. x"))
  mon_tree <- mal(mon_tree)
  mal2 <- plyr::colwise(function(x) str_replace_all(x, "Malus 'Adams'", "Malus sp. Adams"))
  mon_tree <- mal2(mon_tree)
  am <- plyr::colwise(function(x) str_replace_all(x, "Amelanchier Autumn", "Amelanchier x grandiflora Autumn"))
  mon_tree <- am(mon_tree)
  
  # sorting species name into genus, species, and cultivar columns
  mon_tree <- mon_tree %>% separate(Essence_latin, c("genus","species","var","cultivar"), sep = " ")
  mon_tree$species[mon_tree$species %in% c("ssp", NA)]<-"sp."
  mon_tree$species[mon_tree$species %in% c("sp", NA)]<-"sp."
  mon_tree$species[mon_tree$species %in% c("sub", NA)]<-"sp."
  mon_tree$species[mon_tree$species %in% c("sp.(hybrides)", NA)]<-"sp."
  mon_tree$var[mon_tree$var %in% c("","var")] <- NA
  mon_treecul <- mon_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ")
  mon_treesp <- mon_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ")
  mon_tree <- rbind(mon_treecul, mon_treesp)
  mon_tree$cultivar[mon_tree$cultivar == ""] <- NA
  
  # remove quotation marks
  del <- plyr::colwise(function(x) str_replace_all(x, "'", ""))
  mon_tree <- del(mon_tree)
  
  # Converting dbh from mm to cm
  mon_tree$dbh <- as.numeric(mon_tree$dbh)
  mon_tree$dbh <- mon_tree$dbh/10
  
  return(mon_tree)
  
}