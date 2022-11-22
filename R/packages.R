library(targets)
library(tarchetypes)
library(qs)

library(conflicted)
conflict_prefer_all("dplyr", c("plyr", "stats"))

library(downloader)
library(readr)
library(bit64)
conflict_prefer("match", "base", "bit64")
conflict_prefer(":", "base", "bit64")
conflict_prefer("%in%", "base")

library(sf)
library(geojsonio)
library(stars)

library(dplyr)
conflict_prefer("first", "dplyr", "data.table")
library(tidyr)
library(stringr)
library(plyr)
library(tibble)

library(data.table)

library(units)
library(anytime)

library(ggplot2)

library(iNEXT)