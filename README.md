# Cross-city drivers of urban forest regulatory ecosystem services

## Authors: Isabella C. Richmond, Nicole Yu, Alec Robitaille, Kayleigh Hutt-Taylor, Carly D. Ziter

**Abstract**

WIP


**Repo Instructions**

This repository is built using a [targets](https://books.ropensci.org/targets/) workflow. You can run the workflow using the following code:

```{r, eval = FALSE, echo = TRUE}
library(targets)
tar_make()
```

All required data is downloaded/included as part of the workflow, *except for data generated in Google Earth Engine*.

To make the workflow run to completion, lines 115-136 in `input/link-values.R` need to be updated with the location of these data in your own Google Drive. 
The Google Earth Engine generated data can be obtained by making a [free GEE account](https://earthengine.google.com/) and using the assets/code provided in the `ee/` folder of this repository.
These data can also be obtained by downloading them from this repo's associated Zenodo repository.


For any questions or issues, please contact isabella.richmond@mail.concordia.ca
