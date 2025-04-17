suppressPackageStartupMessages({

  library(targets)
  library(tarchetypes)
  library(qs2)
  library(quarto)
  library(renv)
  
  library(conflicted)
  conflict_prefer_all("dplyr", c("plyr", "stats"), quiet = TRUE)
  
  library(downloader)
  library(readr)
  library(bit64)
  conflict_prefer("match", "base", "bit64", quiet = T)
  conflict_prefer(":", "base", "bit64", quiet = T)
  conflict_prefer("%in%", "base", quiet = T)
  
  library(sf)
  library(geojsonio)
  library(stars)
  library(osmdata)
  library(rnaturalearth)
  library(ggrepel)
  
  library(plyr)
  library(dplyr)
  conflict_prefer("first", "dplyr", "data.table", quiet = T)
  library(tidyr)
  library(stringr)
  library(tibble)
  
  library(data.table)
  
  library(units)
  library(anytime)
  
  library(FactoMineR)
  library(factoextra)
  library(ggplot2)
  library(MetBrewer)
  
  
  library(vegan)
  
  library(mice)
  library(cluster)
  conflicts_prefer(dplyr::filter)
  
  library(xfun)
  
  library(googledrive)

})