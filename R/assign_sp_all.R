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
  # Acer saccharum
  all$fullname[all$fullname %in% c("Acer barbatum")] <-"Acer saccharum"
  # Acer × freemanii
  all$fullname[all$fullname %in% c("Acer x fremannii", "Acer freemanii", "Acer freemanii   x")]<- "Acer x freemanii"
  # Acer cissifolium
  all$fullname[all$fullname %in% c("Acer henryi")] <-"Acer cissifolium"
  # Acer truncatum
  all$fullname[all$fullname %in% c("Acer pacific")] <-"Acer truncatum"
  # Acer pensylvanicum
  all$fullname[all$fullname %in% c("Acer pennsylvanicum")] <- "Acer pensylvanicum"
  # Acer platanoides
  all$fullname[all$fullname %in% c("Acer platinoides")]<- "Acer platanoides"
  # Acer tataricum 
  all$fullname[all$fullname %in% c("Acer tartaricum", "Acer tatricum", "Acer ginnala")]<- "Acer tataricum"
  # Acer sp.
  all$fullname[all$fullname %in% c("Acer g.")] <-"Acer sp."
  # Aesculus glabra
  all$fullname[all$fullname %in% c("Aesculus arguta")]<- "Aesculus glabra"
  # Aesculus flava
  all$fullname[all$fullname %in% c("Aesculus flava")]<- "Aesculus octandra"
  # Aesculus x hybrida
  all$fullname[all$fullname %in% c("Aesculus x autumn")]<- "Aesculus x hybrida"
  # Aesculus x carnea
  all$fullname[all$fullname %in% c("Aesculus carnea", "Aesculus carnea   x")]<- "Aesculus x carnea"
  # Salix sepulcralis
  all$fullname[all$fullname %in% c("Alix sepulcralis")]<- "Salix sepulcralis"
  # Ailanthus altissima
  all$fullname[all$fullname %in% c("Allianthus altissima")]<- "Ailanthus altissima"
  # Amelanchier arborea
  all$fullname[all$fullname %in% c("Amelanchier alba")]<- "Amelanchier arborea"
  # Amelanchier canadensis
  all$fullname[all$fullname %in% c("Amelanchier c.")]<- "Amelanchier canadensis"
  # Amelanchier x grandiflora 
  all$fullname[all$fullname %in% c("Amelanchier grandiflora x", "Amelanchier g.")]<- "Amelanchier x grandiflora"
  # Betula platyphylla
  all$fullname[all$fullname %in% c("Betula platyphylla jefpark", "Betula penci-2")]<- "Betula platyphylla"
  # Betula sp.
  all$fullname[all$fullname %in% c("Betula p.")]<- "Betula sp."
  # Betula albosinensis
  all$fullname[all$fullname %in% c("Betula alba-sinensis")]<- "Betula albosinensis"
  # Betula utilis
  all$fullname[all$fullname %in% c("Betula jacquemontii")]<- "Betula utilis"
  # Betula pendula
  all$fullname[all$fullname %in% c("Betula alba")]<- "Betula pendula"
  # Betula occidentalis
  all$fullname[all$fullname %in% c("Betula fontinalis")]<- "Betula occidentalis"
  # Catalpa sp.
  all$fullname[all$fullname %in% c("Catalpa hybrida x")]<- "Catalpa sp."
  # Caragana arborescens 
  all$fullname[all$fullname %in% c("Caragana arboresense", "Caragana arobrescens")]<- "Caragana arborescens"
  # Cercidiphyllum japonicum
  all$fullname[all$fullname %in% c("Cercidiphyllym japonicum", "Cercidiphyllum japonic")]<- "Cercidiphyllum japonicum"
  # Cladrastis kentukea
  all$fullname[all$fullname %in% c("Cladastris kentukea")]<- "Cladrastis kentukea"
  # Chamaecyparis nootkatensis
  all$fullname[all$fullname %in% c("Chamaecyparis nootkensis", "Chamaecyparis nootkatensis", "Cupressus nootkatensis")]<- "Callitropsis nootkatensis" 
  # Cladastris lutea
  all$fullname[all$fullname %in% c("Cladrastis lutea", "Cladastris lutea")]<- "Cladrastis kentukea"
  # Corylus colurna
  all$fullname[all$fullname %in% c("Corylus columa")]<- "Corylus colurna"
  # Cotoneaster acutifolius
  all$fullname[all$fullname %in% c("Cotoneaster lucidus")]<- "Cotoneaster acutifolius"
  # Crataegus crus-galli 
  all$fullname[all$fullname %in% c("Crataegus crus", "Crataegus crusgalli")]<- "Crataegus crus-galli"
  # Crataegus laevigata
  all$fullname[all$fullname %in% c("Cartaegus laevigata", "Crataegus oxyacantha", "Crataegus x oxyacantha")]<- "Crataegus laevigata"
  # Crataegus × mordenensis
  all$fullname[all$fullname %in% c("Crataegus mordenensis", "Crataegus mordensis", "Crataegus x mordensis")]<- "Crataegus x mordenensis"
  # Euonymus alatus
  all$fullname[all$fullname %in% c("Euonymus altus")]<- "Euonymus alatus"
  # Fraxinus pennsylvanica
  all$fullname[all$fullname %in% c("Fraxinus pennsylvancia")]<- "Fraxinus pennsylvanica"
  # Gleditsia triacanthos
  all$fullname[all$fullname %in% c("Gleditisia triacanthos", "Gleditsia t.")]<- "Gleditsia triacanthos"
  # Gleditsia dioicus
  all$fullname[all$fullname %in% c("Gleditisia d.")]<- "Gleditsia dioicus"
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
  # Magnolia acuminata
  all$fullname[all$fullname %in% c("Magnolia x yellow")]<- "Magnolia acuminata"
  # Magnolia x soulangeana
  all$fullname[all$fullname %in% c("Magnolia rustica", "Magnolia x soulangiana")]<- "Magnolia x soulangeana"
  # Magnolia sp.
  all$fullname[all$fullname %in% c("Magnolia little")]<- "Magnolia sp."
  # Malus sp.
  all$fullname[all$fullname %in% c("Malus 'Hopa'", "Malus makamik", "Malus profusion", "Malus royal", 
                                   "Malus thunderchild", "Malus x thunder", "Malus x spring", "Malus pendula",
                                   "Malus x durlawrence", "Malus x jefstar", "Malus x rudolph")]<- "Malus sp."
  # Ostrya virginiana
  all$fullname[all$fullname %in% c("Ostryia virginiana")]<- "Ostrya virginiana"
  # Phellodendron amurense
  all$fullname[all$fullname %in% c("Phellodendon amurense", "Phellodendron amurensis")]<- "Phellodendron amurense"
  # Phellodendron lavalleei
  all$fullname[all$fullname %in% c("Phellodendon l.")]<- "Phellodendron lavalleei"
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
  # Pinus mugo
  all$fullname[all$fullname %in% c("Pinus uncinata")]<- "Pinus mugo"
  # Platanus x acerifolia
  all$fullname[all$fullname %in% c("Platanus acerifolia   x", "Platanus hybrida", "Platanus x a.")]<- "Platanus x acerifolia"
  # Populus balsamifera 
  all$fullname[all$fullname %in% c("Populus balamifera", "Populus trichocarpa")]<- "Populus balsamifera"
  # Populus canescens
  all$fullname[all$fullname %in% c("Populus canescens   x", "Populus hybrida prairie skyrise")]<- "Populus canescens"
  # Populus deltoides
  all$fullname[all$fullname %in% c("Populus sargentii")]<- "Populus deltoides"
  # Populus sp. 
  all$fullname[all$fullname %in% c("Populus deltoides / balsamifera (?)", "Populus x", "Populus salicaceae")]<- "Populus sp."
  # Prunus americana
  all$fullname[all$fullname %in% c("Prunus armeniaca")]<- "Prunus americana"
  # Prunus maackii
  all$fullname[all$fullname %in% c("Prunus maakii", "Prunus x ming")]<- "Prunus maackii"
  # Prunus pensylvanica
  all$fullname[all$fullname %in% c("Prunus pennsylvanica")]<- "Prunus pensylvanica"
  # Prunus x nigrella
  all$fullname[all$fullname %in% c("Prunus nigrella")]<- "Prunus x nigrella"
  # Prunus sp.
  all$fullname[all$fullname %in% c("Prunus section", "Prunus sweetheart")]<- "Prunus sp."
  # Pseudotsuga menziesii
  all$fullname[all$fullname %in% c("Pseudostuga menziesii")]<- "Pseudotsuga menziesii"
  # Pterocarya stenoptera
  all$fullname[all$fullname %in% c("Pterocarya stepnotera")]<- "Pterocarya stenoptera"
  # Pyrus sp.
  all$fullname[all$fullname %in% c("Pyrus x durpsn302")]<- "Prunus sp."
  # Quercus montana
  all$fullname[all$fullname %in% c("Quercus prinus")]<- "Quercus montana"
  # Quercus robur
  all$fullname[all$fullname %in% c("Quercus robur x alba")]<- "Quercus robur"
  # Quercus sp.
  all$fullname[all$fullname %in% c("Quercus x")]<- "Quercus sp."
  # Quercus x bimundorum
  all$fullname[all$fullname %in% c("Quercus x b.")]<- "Quercus x bimundorum"
  # Quercus x kindred spirit
  all$fullname[all$fullname %in% c("Quercus x kindred")]<- "Quercus x kindred spirit"
  # Rhus typhina
  all$fullname[all$fullname %in% c("Rhus hirta")]<- "Rhus typhina"
  # Salix amygdaloides
  all$fullname[all$fullname %in% c("Salix amygdalioides")]<- "Salix amygdaloides"
  # Salix pentandra
  all$fullname[all$fullname %in% c("Salix pentendra")]<- "Salix pentandra"
  # Sequoia sempervirens
  all$fullname[all$fullname %in% c("Sequoia semprevirens")]<- "Sequoia sempervirens"
  # Sorbus americana
  all$fullname[all$fullname %in% c("Sorbus tianshanica")]<- "Sorbus americana"
  # Sorbus acuparia
  all$fullname[all$fullname %in% c("Sorbus xanthocarpa")]<- "Sorbus acuparia"
  # Sorbus intermedia
  all$fullname[all$fullname %in% c("Sorubus intermedia")]<- "Sorbus intermedia"
  # Sorbus x thuringiaca
  all$fullname[all$fullname %in% c("Sorbus thuringiaca", "Sorbus thuringiaca   x")]<- "Sorbus x thuringiaca"
  # Sorbus sp.
  all$fullname[all$fullname %in% c("Sorubus x")]<- "Sorbus sp."
  # Symphoricarpos albus
  all$fullname[all$fullname %in% c("Symphoricarpus alba")]<- "Symphoricarpos albus"
  # Symphoricarpos microphyllus
  all$fullname[all$fullname %in% c("Symphoricarpus mexicanus")]<- "Symphoricarpos microphyllus"
  # Taxodium distichum
  all$fullname[all$fullname %in% c("Taxodium ascendens")]<- "Taxodium distichum"
  # Thuja occidentalis
  all$fullname[all$fullname %in% c("Thuja occdentalis", "Thuya occidentalis")]<- "Thuja occidentalis"
  # Tilia americana
  all$fullname[all$fullname %in% c("Tilia a.")]<- "Tilia americana"
  # Tilia × euchlora
  all$fullname[all$fullname %in% c("Tilia euchlora   x")]<- "Tilia x euchlora"
  # Tilia × europaea
  all$fullname[all$fullname %in% c("Tilia x europea", "Tilia europaea   x")]<- "Tilia x europaea"
  # Tilia mongolica
  all$fullname[all$fullname %in% c("Tilia x mongolica", "Tilia mongolica harvest gold")]<- "Tilia mongolica"
  # Tilia x flavescens
  all$fullname[all$fullname %in% c("Tilia flavescens")]<- "Tilia x flavescens"
  # Tilia sp.
  all$fullname[all$fullname %in% c("Tilia x skinur")]<- "Tilia sp."
  # Ulmus minor 
  all$fullname[all$fullname %in% c("Ulmus carpinifolia")]<- "Ulmus minor"
  # Ulmus japonica 
  all$fullname[all$fullname %in% c("Ulmus wilsoniana", "Ulmus propinqua", "Ulmus prospector", "Ulmus x morton")]<- "Ulmus japonica"
  # Ulmus x hollandica 
  all$fullname[all$fullname %in% c("Ulmus hollandica   x", "Ulmus pioneer", "Ulmus x pioneer")]<- "Ulmus x hollandica"
  # Ulmus sp. 
  all$fullname[all$fullname %in% c("Ulmus x", "Ulmus 13-0053", "Ulmus new")]<- "Ulmus sp."
  
  # Unknown sp.
  all$fullname[all$fullname %in% c("NA sp.", "See notes", "Various sp.", "Not suitable", "Hedge sp.", "Stump sp.", "Divers sp.")] <- "Unknown sp."
  
  all$fullname <- droplevels(all$fullname)
  
  return(all)
  
}