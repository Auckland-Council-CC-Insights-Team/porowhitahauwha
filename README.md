
<!-- README.md is generated from README.Rmd. Please edit that file -->

# porowhitahauwha

<!-- badges: start -->
<!-- badges: end -->

The goal of porowhitahauwha is to provide a code-based interface for the
Porowhita Hauwhā database.

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
