assign_sp_tor <- function(tor_tree, tor_tree_spcode){
  
  # sorting species name into genus, species, and cultivar columns
  tor_tree$BOTANICAL_NAME <- tor_tree_spcode$BOTANICAL_NAME[match(as.character(tor_tree$COMMON_NAME), as.character(tor_tree_spcode$COMMON_NAME))]
  
  tor_tree <- select(tor_tree, -"COMMON_NAME")
  tor_tree <- tor_tree %>% separate(BOTANICAL_NAME, c("genus","species","var","cultivar", "cultivar2"))
  tor_tree$species[tor_tree$species == "sp"] <- "sp."
  tor_tree$species[tor_tree$species == "X"] <- "x"
  tor_tree$var[tor_tree$var == "var"] <- NA
  tor_treecul <- tor_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar", "cultivar2"), na.rm = TRUE, sep = " ")%>%
    mutate(cultivar = na_if(cultivar, ""))
  tor_treesp <- tor_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ") %>% unite(cultivar, c("cultivar", "cultivar2"), na.rm = TRUE, sep = " ")%>%
    mutate(cultivar = na_if(cultivar, ""))
  tor_tree <- rbind(tor_treecul, tor_treesp)
  
  return(tor_tree)
}