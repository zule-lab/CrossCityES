assign_sp_win <- function(win_tree){
  
  # recode problematic species names 
  win_tree$botanical[win_tree$botanical == "Not Available"] <- "Unknown sp."
  # sorting species name into genus, species, and cultivar columns
  win_tree <- win_tree %>% separate(botanical, c("genus","species","var","cultivar"))
  # assign blanks and NAs in species column to "sp."
  win_tree$species[win_tree$species %in% c("", NA,"spp")]<-"sp."
  win_tree$species[win_tree$species == "sp"] <- "sp."
  win_tree$var[win_tree$var == "var"] <- NA
  win_treesp <- win_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ") %>%
    mutate(cultivar = na_if(cultivar, ""))
  win_treecul <- win_tree %>% filter(species != "x") %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ") %>%
    mutate(cultivar = na_if(cultivar, ""))
  win_tree <- rbind(win_treecul, win_treesp)
  # identifying whether trees are street trees or park trees
  win_tree$park <- ifelse(win_tree$park == "Not In Park","no","yes")
  
  return(win_tree)
  
}