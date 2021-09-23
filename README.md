# Chapter 1: Cross-city drivers of urban forest regulatory ecosystem services  
## Contributors: Isabella Richmond & Nicole Yu  
**Work in Progress**

## Proposed first chapter of my PhD thesis, asking:  

> What are the cross-city drivers of regulatory ecosystem services provided by the urban forest in Canadian temperate cities?  

Using existing, publicly available data to test temperature regulation, air pollution mitigation, and carbon storage capacity and their drivers in seven major, southern, temperate cities that span the east-west coasts of Canada: Vancouver, Calgary, Winnipeg, Toronto, Ottawa, Montreal, Halifax. We will test drivers of ecosystem services at three scales within the cities, fine-scale (street level), medium-scale (neighbourhood level), and large-scale (city level).  

This repo contains the code and data for ongoing work. R scripts are organized in `script/`, raw data that cannot be downloaded can be found in `input/`, and downloaded raw data can be found in `large/` (which is not tracked due to file size). Figures can be found in `graphics/`, and cleaned data can be found in `large/` and `output/`.

Package dependencies include: `downloader`, `bit64`, `dplyr`, `plyr`, `tidyr`, `stringr`,  `readr`, `ggplot2`, `data.table`, `units`,`sf`, `geojsonio`.