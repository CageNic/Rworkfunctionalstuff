# does read.csv auto create a tibble or data frame

weather <- as_tibble(read.csv("weather.csv", stringsAsFactors = FALSE))
weather
#> # A tibble: 22 × 35
#>   id       year month element    d1    d2    d3    d4    d5    d6    d7    d8
#>   <chr>   <int> <int> <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 MX17004  2010     1 tmax       NA  NA    NA      NA  NA      NA    NA    NA
#> 2 MX17004  2010     1 tmin       NA  NA    NA      NA  NA      NA    NA    NA
#> 3 MX17004  2010     2 tmax       NA  27.3  24.1    NA  NA      NA    NA    NA
#> 4 MX17004  2010     2 tmin       NA  14.4  14.4    NA  NA      NA    NA    NA
#> 5 MX17004  2010     3 tmax       NA  NA    NA      NA  32.1    NA    NA    NA
#> 6 MX17004  2010     3 tmin       NA  NA    NA      NA  14.2    NA    NA    NA
#> # ℹ 16 more rows
#> # ℹ 23 more variables: d9 <lgl>, d10 <dbl>, d11 <dbl>, d12 <lgl>, d13 <dbl>,
#> #   d14 <dbl>, d15 <dbl>, d16 <dbl>, d17 <dbl>, d18 <lgl>, d19 <lgl>,
#> #   d20 <lgl>, d21 <lgl>, d22 <lgl>, d23 <dbl>, d24 <lgl>, d25 <dbl>,
#> #   d26 <dbl>, d27 <dbl>, d28 <dbl>, d29 <dbl>, d30 <dbl>, d31 <dbl>
