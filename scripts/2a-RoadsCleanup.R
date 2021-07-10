# Script to cleanup Canada raw data

#### Packages ####
easypackages::packages("tidyverse","sf")

### Canada municipality boundaries cleanup
can_bound <- can_bound_raw %>%
  select(c("CMANAME", "geometry")) %>%
  rename("bound" = "CMANAME")