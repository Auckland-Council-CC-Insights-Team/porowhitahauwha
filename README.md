
<!-- README.md is generated from README.Rmd. Please edit that file -->

# porowhitahauwha

<!-- badges: start -->

[![R-CMD-check](https://github.com/Auckland-Council-CC-Insights-Team/porowhitahauwha/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Auckland-Council-CC-Insights-Team/porowhitahauwha/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of porowhitahauwha is to provide a code-based interface for
staff at Auckland Council to work with the Porowhita Hauwhā database.

The Porowhita Hauwhā database can be thought of as a quadrant of
information: it contains data about kaimahi (staff), hoa (partners),
hangatanga (buildings), and ratonga (services) that fall within the
remit of the Connected Communities department at Te Kunihera o Tāmaki
Makaurau (Auckland Council).

Porowhita hauwhā is a kupu (word) in te Reo Māori which means
“quadrant”.

## Installation

You can install the development version of porowhitahauwha from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Auckland-Council-CC-Insights-Team/porowhitahauwha")
```

## Example

This is a basic example which shows you how to retrieve a list of all
asset-type facilities from the test database that is provided with the
package:

``` r
library(porowhitahauwha)
get_assets(test_db = TRUE)
#> # A tibble: 2 × 5
#>   facility_id name                      local_board designation delivery_model  
#>   <chr>       <chr>                     <chr>       <chr>       <chr>           
#> 1 A26         Buckland Community Centre Franklin    Rural Hall  Community-led f…
#> 2 A58         Franklin The Centre       Franklin    Hybrid      Council-led fac…
```

A vignette is being written that will explain the conceptual framework
that was designed to inform how the data was modeled. This will define,
in technical parlance, what is an asset, a space, an entity, and how the
three are related.

## Terms of use

Only authorised kaimahi at Auckland Council are able to access the
production database for which this package provides a code-based
interface, but anyone can freely use and adapt the code contained in
this package for their own purposes.

This package comes bundled with test data, which anyone can access and
use as they see fit. The test data only features data that is already
publicly available elsewhere, and any information about real individuals
has been replaced with fake data. You may find the help files for test
data tables useful if you are tasked with modelling similar data, for
example in local government.
