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
library(tidyr)
library(stringr)
library(plyr)

library(data.table)

library(units)
library(anytime)

library(ggplot2)