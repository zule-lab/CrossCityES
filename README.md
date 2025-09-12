# Cross-city drivers of urban forest regulatory ecosystem services

## Authors: Isabella C. Richmond, Nicole Yu, Alec Robitaille, Kayleigh Hutt-Taylor, Carly D. Ziter

**Abstract**

WIP


**Repo Instructions**

This repository is built using a [targets](https://books.ropensci.org/targets/) workflow and has an `renv` environment. After activating and installing all packages, more instructions [here](https://pkgs.rstudio.com/renv/articles/renv.html), you can run the workflow using the following code:

```{r, eval = FALSE, echo = TRUE}
library(targets)
tar_make()
```

All required data is downloaded/included as part of the workflow. Data generated in Google Earth Engine can be found in the `ee/` folder with scripts, some datasets must be unzipped before running the pipeline. 

The random forest models are very computationally expensive, the code is set up to be parallelized using the controller argument in `tar_option_set()`. Modify the number of workers depending on your system in `_targets.R`. If not parallelizing, keep the controller argument commented out.

For any questions or issues, please contact isabella.richmond@mail.concordia.ca
