assign_sp_hal <- function(hal_tree, hal_tree_spcode, hal_tree_dbhcode){
  
  # recode species from code to scientific name
  hal_tree$botname <- hal_tree_spcode$botname[match(as.character(hal_tree$SP_SCIEN), as.character(hal_tree_spcode$code))]
  # sorting species name into genus, species, and cultivar columns
  hal_tree <- hal_tree %>% separate(botname, c("genus","species","var","cultivar"))
  hal_tree$var[hal_tree$var == "var"] <- NA
  hal_treecul <- hal_tree %>% filter(species != "x" | is.na(species)) %>% unite(cultivar, c("var", "cultivar"), na.rm = TRUE, sep = " ")
  hal_treesp <- hal_tree %>% filter(species == "x") %>% unite(species, c("species", "var"), na.rm = TRUE, sep = " ")
  hal_tree <- rbind(hal_treecul, hal_treesp)
  hal_tree$cultivar[hal_tree$cultivar == ""] <- NA
  # assign blanks and NAs in species column to "sp."
  hal_tree$species[hal_tree$species %in% c("",NA)] <- "sp."
  # Assign "species" column as NA for "Unknown Species"
  hal_tree$species[hal_tree$species == "Species"] <- NA
  # randomly sample from category values for DBH 
  hal_tree <- hal_tree %>% 
    mutate(dbh = replace_string(as.character(dbh)),
           dbh = round(as.numeric(dbh), 1))
  
  return(hal_tree)
  
}


# values taken from hal_tree_dbhcode
replace_string <- function(g) {
  sapply(g, function(a) {
    case_match(a,
               "1" ~ as.character(runif(1, 0, 7)),
               "2" ~ as.character(runif(1, 7, 15)),
               "3" ~ as.character(runif(1, 15, 30)),
               "4" ~ as.character(runif(1, 30, 45)),
               "5" ~ as.character(runif(1, 45, 60)),
               "6" ~ as.character(runif(1, 60, 76)),
               "7" ~ as.character(runif(1, 76, 90)),
               "8" ~ as.character(runif(1, 90, 106)),
               "9" ~ as.character(runif(1, 106, 500)),
               .default = a
    )
  })
}
