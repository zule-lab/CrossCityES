# Predictors of land-surface temperature and air pollution across Canadian cities are largely scale and city dependent

[![DOI](https://zenodo.org/badge/366469574.svg)](https://doi.org/10.5281/zenodo.17186245)

## Isabella C. Richmond, Nicole Yu, Alec Robitaille, Kayleigh Hutt-Taylor, Carly D. Ziter

**Abstract**

Problems of urban heat and air pollution have been increasing in Canadian cities over the past several decades. The distribution and level of temperature and air pollution are directly tied to the structure of cities, including aspects of vegetation, urban form, and sociodemographics. There are currently few studies that investigate patterns of urban heat and air pollution across multiple cities and/or scales in Canada. To address that gap, we use open-source data to predict patterns of temperature and air pollution within and across seven Canadian cities varying in geography and population size. Our goal is to identify the extent to which vegetation, urban form, and sociodemographic variables best predict temperature and air pollution. We are also particularly interested in the relative contributions of street trees due to their large contributions to the urban forest and provision of ecosystem services. We implemented random forest modelling and identified the important predictors and their relationships with temperature and air pollution metrics at the street, neighbourhood, and city scales. We found that there are very few generalizable patterns, with most important predictors unique to the response variable and scale. This emphasizes the importance of context dependent management and local expertise for predicting and understanding urban heat and air pollution. However, inequity was an important predictor of temperature and nitrogen dioxide at the city scale. This large-scale trend across Canadian cities indicates that it is a serious problem across our cities and we should take large-scale approaches to dealing with issues of inequity. Additionally, street tree variables appear as important predictors of temperature at the city scale and of temperature and ozone at the neighbourhood scale, though the metrics themselves are scale dependent. At the neighbourhood scale, both ozone and temperature are best predicted by street-tree related variables. These findings indicate that street trees are an important factor when predicting environmental conditions, despite comprising only a small portion of the urban forest. As one of few cross-city and cross-scale studies of its kind in Canada, our findings highlight the need for improved datasets and data accessibility. Our work demonstrates important patterns when predicting land-surface temperature and air pollution across Canadian cities, generating research questions for future investigation, and providing decision-makers in Canada with more information about our cities. 


**Repo Instructions**

This repository is built using a [targets](https://books.ropensci.org/targets/) workflow and has an `renv` environment. After activating and installing all packages, more instructions [here](https://pkgs.rstudio.com/renv/articles/renv.html), you can run the workflow using the following code:

```{r, eval = FALSE, echo = TRUE}
library(targets)
tar_make()
```

All required data is downloaded/included as part of the workflow. Data generated in Google Earth Engine can be found in the `ee/` folder with scripts. NDVI and temperature datasets must be unzipped before running the pipeline. 

The random forest models are very computationally expensive, the code is set up to be parallelized using the controller argument in `tar_option_set()`. Modify the number of workers depending on your system in `_targets.R`. If not parallelizing, keep the controller argument commented out.

For any questions or issues, please contact isabella.richmond@mail.concordia.ca
