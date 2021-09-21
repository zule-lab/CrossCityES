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


#### OVERLAP #### 
ov <- ab_1 %>% 
  group_by(city) %>% 
  mutate(shared = n_distinct(fullname) == n_distinct(.$fullname))

Reduce(intersect, split(ab_1$fullname, ab_1$city))
