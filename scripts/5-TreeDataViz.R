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

#### VISUALIZATION ####
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
  geom_text(aes(label = Freq), vjust = -0.1)
ggsave("graphics/TreeCountCities.jpg")
