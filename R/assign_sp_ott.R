assign_sp_ott <- function(ott_tree, ott_tree_spcode){
  
  # match scientific names using species codes
  ott_tree$SPECIES <- ott_tree_spcode$SPECIES_LATIN[match(as.character(ott_tree$SPECIES), as.character(ott_tree_spcode$SPECIES_COMMON))]
  # rename problematic species 
  ott_tree$SPECIES[ott_tree$SPECIES == "Hedge Start"] <- "Hedge sp."
  ott_tree$SPECIES[ott_tree$SPECIES == "Hedge End"] <- "Hedge sp."
  ott_tree$SPECIES[ott_tree$SPECIES == "Other - See Notes"] <- "Unknown sp."
  # sorting species name into genus, species, and cultivar columns
  ott_tree <- ott_tree %>% separate(SPECIES, c("genus","species","var","cultivar", "cultivar2"))
  ott_tree$species[ott_tree$species == "species"] <- "sp."
  ott_tree$species[ott_tree$species == "Species"] <- "sp."
  ott_tree$species[ott_tree$species == "sp"] <- "sp."
  ott_tree$species[ott_tree$species == "X"] <- "x"
  ott_tree$species[ott_tree$species == "crabapple"] <- "sp."
  ott_tree$species[ott_tree$species == "apple"] <- "sp."
  ott_tree$cultivar[ott_tree$cultivar == "Species"] <- NA
  ott_tree$var[ott_tree$var == "var"] <- NA
  ott_treecul <- ott_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar", "cultivar2"), na.rm = TRUE, sep = " ")%>%
    mutate(cultivar = na_if(cultivar, ""))
  ott_treesp <- ott_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ") %>% unite(cultivar, c("cultivar", "cultivar2"), na.rm = TRUE, sep = " ")%>%
    mutate(cultivar = na_if(cultivar, ""))
  ott_tree <- rbind(ott_treecul, ott_treesp)
  
  return(ott_tree)
}