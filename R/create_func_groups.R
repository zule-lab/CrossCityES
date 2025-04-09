create_func_groups <- function(TTTF_1.3, seed_mass, TTTF_newlit, ZULE_traits){
  
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
    drop_na(TraitAcc)
  
  # assign functional groups to each based on traits 
  
  
  # join with species list 
  
  
  return(traits)
  
}