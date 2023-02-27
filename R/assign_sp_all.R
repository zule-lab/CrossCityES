assign_sp_all <- function(van_tree_clean, cal_tree_clean, win_tree_clean, tor_tree_clean, ott_tree_clean, mon_tree_clean, hal_tree_clean){
  
  bind <- rbind(van_tree_clean, cal_tree_clean, win_tree_clean,
        tor_tree_clean, ott_tree_clean, mon_tree_clean, 
        hal_tree_clean)
  
  all <-  bind %>%
    drop_na(city) %>%
    mutate(species = as.factor(species),
           genus = as.factor(genus),
           city = as.factor(city),
           fullname = as.factor(paste0(genus, " ", species))) %>%
    filter(dbh < 500) %>%
    group_by(city) %>%
    mutate(nspecies = n_distinct(fullname))
  
  # manually inspected for spelling errors and inconsistencies 
  # Abies balsamea 
  all$fullname[all$fullname %in% c("Abies balsamaea")] <-"Abies balsamea"
  # Acer × freemanii
  all$fullname[all$fullname %in% c("Acer x fremannii", "Acer freemanii", "Acer freemanii   x")]<- "Acer x freemanii"
  # Acer pensylvanicum
  all$fullname[all$fullname %in% c("Acer pennsylvanicum")] <- "Acer pensylvanicum"
  # Acer platanoides
  all$fullname[all$fullname %in% c("Acer platinoides")]<- "Acer platanoides"
  # Acer tataricum 
  all$fullname[all$fullname %in% c("Acer tartaricum", "Acer tatricum")]<- "Acer tataricum"
  # Aesculus x carnea
  all$fullname[all$fullname %in% c("Aesculus carnea", "Aesculus carnea   x")]<- "Aesculus x carnea"
  # Amelanchier x grandiflora 
  all$fullname[all$fullname %in% c("Amelanchier grandiflora x")]<- "Amelanchier x grandiflora"
  # Betula platyphylla
  all$fullname[all$fullname %in% c("Betula platyphylla jefpark")]<- "Betula platyphylla"
  # Caragana arborescens 
  all$fullname[all$fullname %in% c("Caragana arboresense", "Caragana arobrescens")]<- "Caragana arborescens"
  # Cercidiphyllum japonicum
  all$fullname[all$fullname %in% c("Cercidiphyllym japonicum", "Cercidiphyllum japonic")]<- "Cercidiphyllum japonicum"
  # Cladrastis kentukea
  all$fullname[all$fullname %in% c("Cladastris kentukea")]<- "Cladrastis kentukea"
  # Chamaecyparis nootkatensis
  all$fullname[all$fullname %in% c("Chamaecyparis nootkensis")]<- "Chamaecyparis nootkatensis"
  # Cladastris lutea
  all$fullname[all$fullname %in% c("Cladrastis lutea")]<- "Cladastris lutea"
  # Crataegus crus-galli 
  all$fullname[all$fullname %in% c("Crataegus crus", "Crataegus crusgalli")]<- "Crataegus crus-galli"
  # Crataegus laevigata
  all$fullname[all$fullname %in% c("Cartaegus laevigata")]<- "Crataegus laevigata"
  # Crataegus × mordenensis
  all$fullname[all$fullname %in% c("Crataegus mordenensis", "Crataegus mordensis", "Crataegus x mordensis")]<- "Crataegus x mordenensis"
  # Crataegus x oxyacantha
  all$fullname[all$fullname %in% c("Crataegus oxyacantha")]<- "Crataegus x oxyacantha"
  # Euonymus alatus
  all$fullname[all$fullname %in% c("Euonymus altus")]<- "Euonymus alatus"
  # Fraxinus pennsylvanica
  all$fullname[all$fullname %in% c("Fraxinus pennsylvancia")]<- "Fraxinus pennsylvanica"
  # Gleditsia triacanthos
  all$fullname[all$fullname %in% c("Gleditisia triacanthos", "Gleditsia t.")]<- "Gleditsia triacanthos"
  # Hydrangea paniculata
  all$fullname[all$fullname %in% c("Hydrangea paniculata grandiflora")]<- "Hydrangea paniculata"
  # Juglans ailantifolia
  all$fullname[all$fullname %in% c("Juglans ailanthifolia")]<- "Juglans ailantifolia"
  # Juglans cinerea
  all$fullname[all$fullname %in% c("Juglans cinereax")]<- "Juglans cinerea"
  # Laburnum x watereri
  all$fullname[all$fullname %in% c("Laburnum watereri  x")]<- "Laburnum x watereri"
  # Liquidambar styraciflua
  all$fullname[all$fullname %in% c("Liguidambar styraciflua")]<- "Liquidambar styraciflua"
  # Liriodendron tulipifera
  all$fullname[all$fullname %in% c("Liriodendron tulipifer")]<- "Liriodendron tulipifera"
  # Maackia amurensis
  all$fullname[all$fullname %in% c("Maakia amurensis")]<- "Maackia amurensis"
  # Ostrya virginiana
  all$fullname[all$fullname %in% c("Ostryia virginiana")]<- "Ostrya virginiana"
  # Phellodendron amurense
  all$fullname[all$fullname %in% c("Phellodendon amurense", "Phellodendron amurensis")]<- "Phellodendron amurense"
  # Philadelphus lewisii
  all$fullname[all$fullname %in% c("Philadelphus lewissii")]<- "Philadelphus lewisii"
  # Picea engelmannii
  all$fullname[all$fullname %in% c("Picea englemannii")]<- "Picea engelmannii"
  # Picea mariana 
  all$fullname[all$fullname %in% c("Picea marina")]<- "Picea mariana"
  # Picea omorika
  all$fullname[all$fullname %in% c("Picea omorica")]<- "Picea omorika"
  # Picea pungens
  all$fullname[all$fullname %in% c("Picea punges")]<- "Picea pungens"
  # Pinus sylvestris
  all$fullname[all$fullname %in% c("Pinus sylverstris")]<- "Pinus sylvestris"
  # Platanus x acerifolia
  all$fullname[all$fullname %in% c("Platanus acerifolia   x")]<- "Platanus x acerifolia"
  # Populus balsamifera 
  all$fullname[all$fullname %in% c("Populus balamifera")]<- "Populus balsamifera"
  # Populus canescens
  all$fullname[all$fullname %in% c("Populus canescens   x")]<- "Populus canescens"
  # Prunus americana
  all$fullname[all$fullname %in% c("Prunus armeniaca")]<- "Prunus americana"
  # Prunus maackii
  all$fullname[all$fullname %in% c("Prunus maakii")]<- "Prunus maackii"
  # Prunus pensylvanica
  all$fullname[all$fullname %in% c("Prunus pennsylvanica")]<- "Prunus pensylvanica"
  # Prunus x nigrella
  all$fullname[all$fullname %in% c("Prunus nigrella")]<- "Prunus x nigrella"
  # Pseudotsuga menziesii
  all$fullname[all$fullname %in% c("Pseudostuga menziesii")]<- "Pseudotsuga menziesii"
  # Pterocarya stenoptera
  all$fullname[all$fullname %in% c("Pterocarya stepnotera")]<- "Pterocarya stenoptera"
  # Salix pentandra
  all$fullname[all$fullname %in% c("Salix pentendra")]<- "Salix pentandra"
  # Sorbus x thuringiaca
  all$fullname[all$fullname %in% c("Sorbus thuringiaca", "Sorbus thuringiaca   x")]<- "Sorbus x thuringiaca"
  # Thuja occidentalis
  all$fullname[all$fullname %in% c("Thuja occdentalis", "Thuya occidentalis")]<- "Thuja occidentalis"
  # Tilia × europaea
  all$fullname[all$fullname %in% c("Tilia x europea")]<- "Tilia x europaea"
  # Ulmus x pioneer 
  all$fullname[all$fullname %in% c("Ulmus pioneer")]<- "Ulmus x pioneer"
  # Ulmus x hollandica 
  all$fullname[all$fullname %in% c("Ulmus hollandica   x")]<- "Ulmus x hollandica"
  # Unknown sp.
  all$fullname[all$fullname %in% c("NA sp.", "See notes", "Various sp.", "Not suitable", "Populus deltoides / balsamifera (?)")] <- "Unknown sp."
  
  return(all)
  
}