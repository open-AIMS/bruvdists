
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bruvdists <img src="man/figures/package-sticker.png" align="right" style="float:right; height:120px;"/>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/bruvdists)](https://CRAN.R-project.org/package=bruvdists)
[![R CMD
Check](https://github.com/open-AIMS/bruvdists/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/open-AIMS/bruvdists/actions/workflows/R-CMD-check.yaml)
[![Website](https://github.com/open-AIMS/bruvdists/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/open-AIMS/bruvdists/actions/workflows/pkgdown.yaml)
[![Test
coverage](https://github.com/open-AIMS/bruvdists/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/open-AIMS/bruvdists/actions/workflows/test-coverage.yaml)
[![codecov](https://codecov.io/gh/open-AIMS/bruvdists/branch/main/graph/badge.svg)](https://codecov.io/gh/open-AIMS/bruvdists)
[![License: GPL (\>=
2)](https://img.shields.io/badge/License-GPL%20%28%3E%3D%202%29-blue.svg)](https://choosealicense.com/licenses/gpl-2.0/)
[![Dependencies](https://img.shields.io/badge/dependencies-0/0-brightgreen?style=flat)](#)
<!-- badges: end -->

<p align="left">

• <a href="#overview">Overview</a><br> •
<a href="#features">Features</a><br> •
<a href="#installation">Installation</a><br> •
<a href="#get-started">Get started</a><br> •
<a href="#long-form-documentations">Long-form documentations</a><br> •
<a href="#citation">Citation</a><br> •
<a href="#contributing">Contributing</a><br> •
<a href="#acknowledgments">Acknowledgments</a><br> •
<a href="#references">References</a>
</p>

## Overview

The R package `bruvdists` is a research compendium to support the
development of a publication “Defining Statistical Distributions Based
on Functional Traits”

## Features

The main purpose of `bruvdists` is to explore appropriate statistical
distributions for ensuring robust inference of BRUV data.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
## Install < remotes > package (if not already installed) ----
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

## Install < bruvdists > from GitHub ----
remotes::install_github("open-AIMS/bruvdists")
```

Then you can attach the package `bruvdists`:

``` r
library("bruvdists")
```

## Get started

For an overview of the main features of `bruvdists`, please read the
[Get
started](https://open-AIMS.github.io/bruvdists/articles/bruvdists.html)
vignette.

## Long-form documentations

`bruvdists` provides **{{ NUMBER OF VIGNETTES }}** vignettes to learn
more about the package:

- the [Get
  started](https://open-AIMS.github.io/bruvdists/articles/bruvdists.html)
  vignette describes the core features of the package
- **{{ LIST ADDITIONAL VIGNETTES }}**

## Citation

Please cite `bruvdists` as:

> Fisher Rebecca (2025) bruvdists: An R package to **{{ TITLE }}**. R
> package version 0.0.0.9000. <https://github.com/open-AIMS/bruvdists/>

## Contributing

All types of contributions are encouraged and valued. For more
information, check out our [Contributor
Guidelines](https://github.com/open-AIMS/bruvdists/blob/main/CONTRIBUTING.md).

Please note that the `bruvdists` project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Acknowledgments

**{{ OPTIONAL SECTION }}**

## References

**{{ OPTIONAL SECTION }}**
