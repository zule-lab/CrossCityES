create_func_groups <- function(can_trees, TTTF_1.3, seed_mass, TTTF_newlit, ZULE_traits){
  
  # clean functional trait databases
  seed_mass_c <- seed_mass %>% 
    rename(StdValue = SM..mg.or.g.for.1000seeds.) %>% 
    mutate(TraitAccUnit = "mg",
           TraitAcc = "SM", 
           TraitAccName = "Seed mass (Seed dry mass)",
           TraitAccID = 6,
           APA = case_when(Data.from.Kew == "Kew 2022" ~ "Kew 2022",
                           .default = Data.from.other.sources)) %>% 
    drop_na(StdValue) %>% 
    select(-c(Data.from.Kew, Data.from.other.sources))
  
  TTTF_newlit_c <- TTTF_newlit %>% 
    select(c(AccSpeciesName, TraitName, StdValue, UnitName, Reference)) %>% 
    rename(FinalName = AccSpeciesName,
           TraitAcc = TraitName,
           TraitAccUnit = UnitName, 
           APA = Reference)
  
  ZULE_c <- ZULE_traits %>% 
    select(c(X_DatasetID, TRYreference, Primary.Reference, AccSpeciesName, OrigValueStr, OrigUnitStr, LifeStage, StdValue, UnitName, TraitAcc, TraitID, TraitName, DataName)) %>% 
    filter(LifeStage != "Sapling" & LifeStage != "Seedling") %>% 
    mutate(APA = case_when(Primary.Reference == "" ~ TRYreference, 
                           .default = Primary.Reference),
           TraitAcc = case_when(TraitAcc == "" ~ DataName,
                                .default = TraitAcc),
           X_DatasetID = as.integer(X_DatasetID)) %>% 
    rename(ID_Ref = X_DatasetID, 
           FinalName = AccSpeciesName, 
           TraitAccUnit = UnitName,
           TraitAccID = TraitID,
           TraitAccName = TraitName) %>% 
    mutate(StdValue = case_when(str_detect(TraitAcc, "SLA|Specific leaf area|specific leaf area") == T & OrigUnitStr %in% c("mm2 mg−1", "mm2/mg", "mm2mg-1") ~ OrigValueStr,
                                str_detect(TraitAcc, "Leaf nitrogen|leaf nitrogen") == T & OrigUnitStr %in% c("mg g−1", "mg/g") ~ OrigValueStr,
                                str_detect(TraitAcc, "SM|Seed dry mass") == T & OrigUnitStr %in% c("mg", "g") ~ OrigValueStr,
                                str_detect(TraitAcc, "WD") == T & OrigUnitStr %in% c("g/cm3", "g/cm^3", "g cm^-3") ~ OrigValueStr,
                                .default = StdValue)) %>%
    mutate(TraitAccUnit = case_when(str_detect(TraitAcc, "SLA|Specific leaf area|specific leaf area") == T & OrigUnitStr %in% c("mm2 mg−1", "mm2/mg", "mm2mg-1") ~ OrigUnitStr,
                                    str_detect(TraitAcc, "Leaf nitrogen|leaf nitrogen") == T & OrigUnitStr %in% c("mg g−1", "mg/g") ~ OrigUnitStr,
                                    str_detect(TraitAcc, "SM|Seed dry mass") & OrigUnitStr %in% c("mg", "g") ~ OrigUnitStr,
                                    str_detect(TraitAcc, "WD") == T & OrigUnitStr %in% c("g/cm3", "g/cm^3", "g cm^-3") ~ OrigUnitStr,
                                    .default = TraitAccUnit)) %>% 
    select(-c(LifeStage, Primary.Reference, TRYreference, DataName)) 
  
  # identify all the rows with standardized units/values 
  ZULE_std <- ZULE_c %>% 
    filter(!is.na(StdValue) & TraitAccUnit != "")
  
  # fix all the ones with unstandardized units/values
  ZULE_unstd <- ZULE_c %>% 
    filter(is.na(StdValue) | TraitAccUnit == "") %>% 
    mutate(StdValue = case_when(str_detect(TraitAcc, "SLA") == T & OrigUnitStr == "cm2/g" ~ OrigValueStr*100/1000,
                                str_detect(TraitAcc, "SLA") == T & OrigUnitStr == "g m-2" ~ 1/(OrigValueStr*1000/1000000),
                                str_detect(TraitAcc, "SLA") == T & OrigUnitStr %in% c("cm2/g", "cm2") ~ OrigValueStr*100/1000,
                                str_detect(TraitAcc, "Leaf nitrogen") == T & OrigUnitStr == "%" ~ OrigValueStr/100*1000,
                                str_detect(TraitAcc, "Leaf nitrogen") == T & OrigUnitStr == "g/kg" ~ OrigValueStr,
                                FinalName == "Populus angustifolia" & OrigValueStr == 2.400 ~ OrigValueStr * 0.00829 * 1000, # from paper
                                FinalName == "Populus angustifolia" & OrigValueStr == 2.350 ~ OrigValueStr * 0.009 * 1000, # from paper
                                FinalName == "Cornus officinalis" & OrigValueStr == 0.6800 ~ OrigValueStr * (1/39) * 1000, # from paper
                                FinalName == "Corylus heterophylla" & OrigValueStr == 0.6100 ~ OrigValueStr * (1/35) * 1000, # from paper
                                FinalName == "Cotoneaster acutifolius" & OrigValueStr == 1.52 ~ OrigValueStr * (1/107) * 1000, # from paper
                                FinalName == "Cotoneaster acutifolius" & OrigValueStr == 1.47 ~ OrigValueStr * (1/68) * 1000, # from paper
                                FinalName == "Cotoneaster acutifolius" & OrigValueStr == 1.22 ~ OrigValueStr * (1/76) * 1000, # from paper
                                str_detect(TraitAcc, "WD") == T & OrigUnitStr == "kg/m3" ~ OrigValueStr*1000/1000000,
                                str_detect(TraitAcc, "WD") == T & OrigUnitStr == "mg/mm3" ~ OrigValueStr,
                                .default = StdValue),
           TraitAccUnit = case_when(str_detect(TraitAcc, "SLA") == T & OrigUnitStr == "cm2/g" ~ "mm2/mg",
                                    str_detect(TraitAcc, "SLA") == T & OrigUnitStr == "g m-2" ~ "mm2/mg",
                                    str_detect(TraitAcc, "SLA|Specific leaf area") == T & OrigUnitStr %in% c("cm2/g", "cm2") ~ "mm2/mg",
                                    str_detect(TraitAcc, "Leaf nitrogen") == T & OrigUnitStr == "%" ~ "mg/g",
                                    str_detect(TraitAcc, "Leaf nitrogen") == T & OrigUnitStr == "g/kg" ~ "mg/g",
                                    FinalName == "Populus angustifolia" & OrigValueStr == 2.400 ~ "mg/g", 
                                    FinalName == "Populus angustifolia" & OrigValueStr == 2.350 ~ "mg/g",
                                    FinalName == "Cornus officinalis" & OrigValueStr == 0.6800 ~ "mg/g", # from paper
                                    FinalName == "Corylus heterophylla" & OrigValueStr == 0.6100 ~ "mg/g", # from paper
                                    FinalName == "Cotoneaster acutifolius" & OrigValueStr == 1.52 ~ "mg/g", # from paper
                                    FinalName == "Cotoneaster acutifolius" & OrigValueStr == 1.47 ~ "mg/g", # from paper
                                    FinalName == "Cotoneaster acutifolius" & OrigValueStr == 1.22 ~ "mg/g", # from paper
                                    str_detect(TraitAcc, "WD") == T & OrigUnitStr == "kg/m3" ~ "g/cm3",
                                    str_detect(TraitAcc, "WD") == T & OrigUnitStr == "mg/mm3" ~ "g/cm3",
                                    .default = TraitAccUnit)) 
  
  ZULE_simovic <- ZULE_unstd %>% 
    filter(str_detect(APA, "Simovic")) %>% 
    pivot_wider(id_cols = c(FinalName, APA), names_from = TraitAcc, values_from = OrigValueStr) %>% 
    mutate(Nmass = `Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): undefined if petiole is in- or excluded`*`Leaf nitrogen (N) content per leaf dry mass`*1000,
           SLA = `Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): undefined if petiole is in- or excluded`*1000000/1000) %>% 
    pivot_longer(cols = -c(FinalName, APA), names_to = 'TraitAcc', values_to = 'StdValue') %>% 
    filter(TraitAcc == 'Nmass' | TraitAcc == 'SLA') %>% 
    mutate(TraitAccUnit = case_when(TraitAcc == "Nmass" ~ "mg/g",
                                    TraitAcc == "SLA" ~ "mm2/mg")) %>% 
    bind_rows(ZULE_unstd) %>% 
    filter(TraitAccUnit != "") %>% 
    bind_rows(ZULE_std) %>% 
    select(c(FinalName, TraitAccID, TraitAcc, StdValue, TraitAccUnit, TraitAccName, ID_Ref, APA))
  
  TTTF_df <- TTTF_1.3 %>% 
    select(c(FinalName, TraitAccID, TraitAcc, StdValue, TraitAccUnit, TraitAccName, ID_Ref, APA))
  
  # put all dataframes together 
  traits <- bind_rows(seed_mass_c, TTTF_newlit_c, TTTF_df, ZULE_simovic) %>%
    # remove erroneous outlier values
    filter(FinalName != "Quercus robur" | StdValue != 5.24) %>% 
    # make sure all traits have a standardized TraitAccID
    mutate(TraitAccID = case_when(TraitAccID == 15 ~ 4,
                                  TraitAccID == 3116 | TraitAccID == 3115 | TraitAccID == 3117 | TraitAccID == 6584 ~ 5,
                                  TraitAccID == 21 | TraitAccID == 26 | TraitAccID == 30 | TraitAccID == 119 ~ 6,
                                  str_detect(TraitAcc, "SLA|specific leaf area|Specific leaf area") == T ~ 5,
                                  str_detect(TraitAcc, "SM") == T ~ 6,
                                  str_detect(TraitAcc, "Nmass|Leaf nitrogen") == T ~ 4,
                                  str_detect(TraitAcc, "WD") == T ~ 8,
                                  .default = TraitAccID))
        
  # calculate mean trait values for each species 
  
  traits_avg <- traits %>% 
    group_by(FinalName, TraitAccID) %>% 
    summarize(TraitAccUnit = first(TraitAccUnit), 
              mean = mean(StdValue)) %>% 
    mutate(TraitAcc = case_when(TraitAccID == 4 ~ 'Nmass',
                                TraitAccID == 5 ~ 'SLA', 
                                TraitAccID == 6 ~ 'SM',
                                TraitAccID == 8 ~ 'WD')) %>% 
    drop_na(TraitAcc) %>% 
    pivot_wider(id_cols = FinalName, names_from = TraitAcc, values_from = mean)
  
  # join with species list 
  species_traits <- can_trees %>% 
    st_drop_geometry() %>% 
    group_by(fullname) %>% 
    tally() %>%
    mutate(fullname = str_replace(fullname, ' sp.', ' sp'),
           fullname = case_when(fullname == "Acer spcatum" ~ "Acer spicatum",
                                fullname == "Amelanchier x grandiflora" ~ "Amelanchier grandiflora",
                                fullname == "Carpinus carolina" ~ "Carpinus caroliniana",
                                fullname == "Cupressocyparis   X leylandii" ~ "Cupressocyparis x leylandii",
                                fullname == "Euonymus europea" ~ "Euonymus europaeus",
                                fullname == "Fraxinus oxycarpa" ~ "Fraxinus angustifolia subsp. oxycarpa",
                                fullname == "Ginkgo b.the" | fullname == "Gingko sp" ~ "Ginkgo biloba",
                                fullname == "Juglans ailantifolia" ~ "Juglans ailanthifolia",
                                fullname == "Magnolia soulangeana  x" | fullname == "Magnolia soulangiana" ~ "Magnolia x soulangeana",
                                fullname == "Magnolia spengeri" ~ "Magnolia sprengeri",
                                fullname == "Malus micromalus   x" ~ "Malus x micromalus",
                                fullname == "Malus zumi" ~ "Malus x zumi",
                                fullname == "Populus canescens" ~ "Populus x canescens",
                                fullname == "Prunus américain" ~ "Prunus americana",
                                fullname == "Prunus sp" ~ "Prunus sp.",
                                fullname == "Prunus virginianna" ~ "Prunus virginiana",
                                fullname == "Pyrus usseriensis" ~ "Pyrus ussuriensis",
                                fullname == "Salix sp" ~ "Salix sp.",
                                fullname == "Sorbus acuparia" ~ "Sorbus aucuparia",
                                fullname == "Sorbus hybrida x" ~ "Sorbus x hybrida",
                                fullname == "Tilia europaea" ~ "Tilia x europaea",
                                fullname == "Catalpa spciosa" ~ "Catalpa speciosa",
                                fullname == "Aesculus octandra" ~ "Aesculus flava",
                                fullname == "Alnus rugosa" ~ "Alnus incana",
                                fullname == "Aralia spnosa" ~ "Aralia spinosa",
                                fullname == "Carya tomentosa" ~ "Carya alba",
                                fullname == "Salix matsudana" ~ "Salix babylonica var. matsudana",
                                fullname == "Malux x thunder" ~ "Malus x thunder", 
                                .default = fullname)) %>% 
    left_join(., traits_avg, by = join_by(fullname == FinalName)) %>% 
    filter(!str_detect(fullname, "Unknown|Unidentified|Stump"))
  
  # identify the genuses with missing traits 
  genus_level <- species_traits %>% 
    filter(str_detect(fullname, "\\bsp\\b") & if_any(c(Nmass, SLA, SM, WD), is.na)) %>% 
    separate(fullname, c('genus', 'species', 'hybrid'), sep = " ") %>% 
    left_join(., traits_avg %>% separate(FinalName, c('genus', 'species', 'hybrid'), sep = " "), by = 'genus', suffix = c('', '_sp')) %>% 
    group_by(genus) %>%
    summarize(species = 'sp',
              Nmass = if_else(is.na(Nmass), mean(Nmass_sp, na.rm= T), Nmass),
              SLA = if_else(is.na(SLA), mean(SLA_sp, na.rm= T), SLA),
              SM = if_else(is.na(SM), mean(SM_sp, na.rm= T), SM),
              WD = if_else(is.na(WD), mean(WD_sp, na.rm= T), WD)) %>% 
    distinct() %>% 
    unite(fullname, c("genus", "species"), sep = " ")
  
  species_traits_g <- species_traits %>% 
    filter(!str_detect(fullname, "\\bsp\\b") | !if_any(c(Nmass, SLA, SM, WD), is.na)) %>%  
    bind_rows(genus_level)
  
  # average seed mass by genus for missing seed mass values 
  seed_mass <- species_traits_g %>% 
    filter(is.na(SM)) %>% 
    separate(fullname, c('genus', 'species', 'hybrid', "cultivar"), sep = " ") %>% 
    left_join(., traits_avg %>% separate(FinalName, c('genus', 'species', 'hybrid'), sep = " "), by = 'genus', suffix = c('', '_sp')) %>%
    mutate(fullname = paste0(genus, " ", species, " ", hybrid, " ", cultivar),
           fullname = str_replace_all(fullname, " NA", "")) %>%
    group_by(fullname) %>%
    summarize(Nmass = first(Nmass),
              SLA = first(SLA),
              SM = mean(SM_sp, na.rm= T),
              WD = first(WD)) 
  
  species_traits_sm <- species_traits_g %>% 
    filter(!is.na(SM)) %>% 
    bind_rows(seed_mass)
  
  # impute missing values for species missing only one trait - code from Paquette et al 2021
  # dataset includes species with all trait data and species with 1 missing trait
  onetrait_na <- species_traits_sm %>% 
    filter( (!if_any(c(SM, SLA, WD, Nmass), is.na)) | (!is.na(SM) & !is.na(SLA) & !is.na(WD) & is.na(Nmass)) | (is.na(SM) & !is.na(SLA) & !is.na(WD) & !is.na(Nmass)) | 
             (!is.na(SM) & is.na(SLA) & !is.na(WD) & !is.na(Nmass)) | (!is.na(SM) & !is.na(SLA) & is.na(WD) & !is.na(Nmass))) %>% 
    select(-c(n)) %>% 
    distinct()
  
  # impute with random forest 
  onetrait_imp <- mice(data = onetrait_na, m = 100, maxit = 500, inc = T, method = "rf")
  onetrait_full <-complete(onetrait_imp)
  
  # assign functional groups to each based on dissimilarity matrix and hierarchical clustering - code from Paquette et al 2021
  rownames(onetrait_full) <- onetrait_full$fullname
  
  # gower distance matrix 
  gow <- daisy(onetrait_full %>% select(-fullname), metric="gower") 
  # hierarchical clustering 
  groups <- agnes(gow, diss=TRUE, method = "ward") 
  # clusters 
  FG <- as.data.frame(cutree(groups, k=c(3:10)))
  rownames(FG) <- onetrait_full$fullname
  
  # The highest value of Silhouette Width should be the preferred number of clusters.
  sil_width <- c(NA) ;for(i in 3:10) {
    pam_fit <- pam(gow, diss = TRUE, k = i)
    sil_width [i] <- pam_fit$silinfo$avg.width
  }
  
  # identify cluster number with max Silhouette Width
  nclusters <- (as_tibble(sil_width) %>% 
    mutate(clusters = row_number()) %>% 
    filter(value == max(value, na.rm = T)))$clusters
  
  # make dataset with functional group assigments 
  FG_final <- FG %>% 
    select(matches(paste0('\\b',as.character(nclusters), '\\b'))) %>% 
    rename(cluster = 1) %>% 
    rownames_to_column('fullname') %>% 
    inner_join(., onetrait_full, by = 'fullname')
  
  # plot dendogram 
  cols <- c("#440154FF", "#433E85FF", "#2D708EFF", "#2BB07FFF", "#85D54AFF", "#FDE725FF")
  dend <- fviz_dend(groups, k = nclusters, rect = T, palette = cols ) 
  ggsave('output/dendrogram.png', dend, width = 45, height = 15, units = 'in')
  
  # assign species missing multiple trait values to functional group
  twotraits_na <- species_traits_sm %>% 
    filter(if_all(c(SM, SLA, WD), is.na) | 
             if_all(c(SM, SLA, Nmass), is.na) |
             if_all(c(SLA, WD, Nmass), is.na) |
             if_all(c(SM, WD, Nmass), is.na) |
             if_all(c(SM, SLA), is.na) | 
             if_all(c(SM, WD), is.na) | 
             if_all(c(SM, Nmass), is.na) | 
             if_all(c(SLA, WD), is.na) |
             if_all(c(SLA, Nmass), is.na) | 
             if_all(c(WD, Nmass), is.na) ) %>% 
    select(-c(n)) %>% 
    distinct() %>% 
    # remove completely blank species
    filter(!if_all(c(SM, SLA, WD, Nmass), is.na)) %>% 
    rename(group = fullname)
  
  FG_groups <- FG_final %>% 
    group_by(cluster) %>% 
    summarize(across(c(SM, SLA, WD, Nmass), mean)) %>% 
    rename(group = cluster) %>% 
    mutate(group = as.character(group)) %>% 
    bind_rows(twotraits_na)
  
  FG_long <- FG_groups %>% 
    pivot_longer(!group, names_to = 'trait', values_to = 'value')
  
  i <- outer(unique(FG_long$group),unique(FG_long$group),FUN=function(i,j) i)
  j <- outer(unique(FG_long$group),unique(FG_long$group),FUN=function(i,j) j)
  i <- i[!lower.tri(i)] ; j <- j[!lower.tri(j)]
  
  # Define function (comp) that perform the pairwise comparisons between all species and functional groups (or sub-groups) - Paquette et al 2021
  comp <- function(ind){
    res <- cosine_na2(FG_long$value[FG_long$group==i[ind]], FG_long$value[FG_long$group==j[ind]])[1,2]
    list(No1=as.character(i[ind]),No2=as.character(j[ind]),CosSim=res)
  }
  
  res <- t(apply(as.data.frame(t(sapply(seq_along(i),FUN="comp"))), 1, unlist))
  
  grouptokeep <- c('1', '2', '3', '4', '5', '6')
  
  FG_assigned <- as.data.frame(bind_cols( as.data.frame(res[,1]), as.data.frame(res[,2]), as.data.frame(res[,3]))) %>%
    transmute(Fgroup=res[,1],CodeSp=res[,2],cosimil=res[,3]) %>%
    filter(Fgroup %in% grouptokeep) %>%
    subset(!(CodeSp %in% grouptokeep)) %>% 
    mutate(Fgroup = as.factor(Fgroup), CodeSp = as.factor(CodeSp), cosimil=as.numeric(cosimil)) %>% 
    group_by(CodeSp) %>% 
    # remove 1s, not enough data for group selection
    filter(cosimil == max(cosimil) & cosimil != 1) %>% 
    rename(cluster = Fgroup,
           fullname = CodeSp,
           similarity = cosimil) %>% 
    left_join(., FG_groups, by = join_by(fullname == group))
    
  # put all data together 
  empty <- species_traits_sm %>% 
    filter(if_all(c(SM, SLA, WD, Nmass), is.na))
  
  full <- bind_rows(FG_final %>% mutate(cluster = as.character(cluster)), FG_assigned, empty) %>% 
    full_join(species_traits_sm %>% select(-n) %>% distinct, by = 'fullname', suffix = c("", "_s")) %>% 
    mutate(SM = case_when(is.na(SM) ~ SM_s, .default = SM),
           SLA = case_when(is.na(SLA) ~ SLA_s, .default = SLA),
           WD = case_when(is.na(WD) ~ WD_s, .default = WD), 
           Nmass = case_when(is.na(Nmass) ~ Nmass_s, .default = Nmass)) %>% 
    rename(FG = cluster) %>% 
    select(c(fullname, FG, SM, WD, SLA, Nmass, similarity))
  
  
  return(full)
  
}

# cosine similarity function from Paquette et al 2021
cosine_na <- function( x, y=NULL ) {
  
  if ( is.matrix(x) && is.null(y) ) {
    co = array(0,c(ncol(x),ncol(x)))
    f = colnames( x )
    dimnames(co) = list(f,f)
    for (i in 2:ncol(x)) {
      for (j in 1:(i-1)) {
      co[i,j] = cosine_na(x[,i], x[,j])}}
    co = co + t(co)
    diag(co) = 1
    return (as.matrix(co)) } 
  
  else if ( is.vector(x) && is.vector(y) ) {
  return ( crossprod(x,y) / sqrt( crossprod(x)*crossprod(y) ) )} 
  else {stop("argument mismatch. Either one matrix or two vectors needed as input.")}
  }

cosine_na2 <- function(x,y) cosine_na(na.omit(cbind(x,y)))

