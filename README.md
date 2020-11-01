
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rcodede

<!-- badges: start -->

<!-- badges: end -->

The goal of rcodede is to simpify the usage of the CODE-DE satellite
data repository with R and provide functions for basic processing steps
with the esa SNAP Graph Processing Tool.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
install.packages("devtools")
devtools::install_github("felixlobert/rcodede")
```

## Example

This is a basic example which shows you how to query available
Sentinel-1 scenes for a given area of interest and multiple filter
criteria:

``` r
library(rcodede)

# Create example AOI
aoi <- c(10.441054, 52.286959) %>%
  sf::st_point() %>%
  sf::st_sfc(crs = 4326)

# Query available scenes for the buffered AOI and given criteria
scenes <-
  getScenes(
    aoi = aoi,
    bufferDist = 100,
    startDate = "2019-01-01",
    endDate = "2019-01-31",
    productType = "SLC"
  )
```
