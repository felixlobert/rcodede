
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

    #> although coordinates are longitude/latitude, st_contains_properly assumes that they are planar
