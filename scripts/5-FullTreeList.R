#### PACKAGES ####
p <- c("sf", "dplyr", "ggplot2", "tidyr")
lapply(p, library, character.only = T)

#### DATA ####
cal <- readRDS("large/trees/CalgaryTreesCleaned.rds")
hal <- readRDS("large/trees/HalifaxTreesCleaned.rds")
mon <- readRDS("large/trees/MontrealTreesCleaned.rds")
ott <- readRDS("large/trees/OttawaTreesCleaned.rds")
tor <- readRDS("large/trees/TorontoTreesCleaned.rds")
van <- readRDS("large/trees/VancouverTreesCleaned.rds")
win <- readRDS("large/trees/WinnipegTreesCleaned.rds")

#### MERGING ####
all <- rbind(cal, hal, mon, ott, tor, van, win)
all <- drop_na(all, city)

all$species <- as.factor(all$species)
all$genus <- as.factor(all$genus)
all$city <- as.factor(all$city)


all <- mutate(all, fullname = paste0(all$genus, " ", all$species))
all$fullname <- as.factor(all$fullname)


nlevels(all$genus)
nlevels(all$fullname)

all <- all %>%
  group_by(city) %>%
  mutate(nspecies = n_distinct(fullname))

#### DATA CLEANING ####
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
# Cercidiphyllum japonicum
all$fullname[all$fullname %in% c("Cercidiphyllym japonicum", "Cercidiphyllum japonic")]<- "Cercidiphyllum japonicum"
# Cladrastis kentukea
all$fullname[all$fullname %in% c("Cladastris kentukea")]<- "Cladrastis kentukea"
# Crataegus crus-galli 
all$fullname[all$fullname %in% c("Crataegus crus", "Crataegus crusgalli")]<- "Crataegus crus-galli"
# Crataegus × mordenensis
all$fullname[all$fullname %in% c("Crataegus mordenensis", "Crataegus mordensis", "Crataegus x mordensis")]<- "Crataegus x mordenensis"
# Euonymus alatus
all$fullname[all$fullname %in% c("Euonymus altus")]<- "Euonymus alatus"
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
# Picea engelmannii
all$fullname[all$fullname %in% c("Picea englemannii")]<- "Picea engelmannii"
# Picea mariana 
all$fullname[all$fullname %in% c("Picea marina")]<- "Picea mariana"
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
all$fullname[all$fullname %in% c("NA sp.", "See notes", "Various sp.")] <- "Unknown sp."

saveRDS(all, "large/trees/AllTreesCleaned.rds")

#### VISUALIZATION ####
all %>% group_by(city) %>% 
  summarise(nspecies = n_distinct(fullname)) %>%
  ggplot(aes(x = city, y = nspecies)) + 
  geom_col() + 
  theme_classic() +
  labs(x = "", y = "Species Count") + 
  geom_text(aes(label = nspecies), vjust = -0.1)
ggsave("graphics/SpeciesCountCities.jpg")


all %>% group_by(city) %>% 
  ggplot(aes(x = city)) +
  geom_bar()+
  theme_classic() + 
  labs(x = "", y = "Tree Count") + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.1)
ggsave("graphics/TreeCountCities.jpg")


#### ABUNDANCE ####
ab <- all %>%
  group_by(city, fullname) %>%
  summarise(n = n()) %>%
  mutate(freq = (n / sum(n))*100) %>%
  arrange(desc(freq), .by_group = T)

# 1% of city
ab_1 <- ab %>%
  filter(freq > 0.999)
ab_1 %>% group_by(city) %>% summarize(s = sum(freq))

# 1% of neighbourhoods
ab_1_hood <- all %>%
  group_by(city, hood, fullname) %>% 
  summarise(n = n()) %>%
  mutate(freq_hood = (n / sum(n))*100)

ab_1_hood <- ab_1_hood %>%
  filter(freq_hood > 1)

ab_1_hood %>% summarize(nspecies = n_distinct(fullname))  
ab_1_hood %>% group_by(city, hood) %>% summarize(s = sum(freq_hood))

saveRDS(ab_1_hood, "large/trees/NeighbourhoodTreesCleaned.rds")
write.csv(ab_1_hood, "output/NeighbourhoodTreesCleaned.csv")

# list of species 
sp <- as_tibble(unique(ab_1_hood$fullname)) %>% 
  rename(Species = value) %>% 
  arrange(Species)
write.csv(sp, "output/NeighbourhoodSpeciesList.csv")

#### OVERLAP #### 
# to-do
