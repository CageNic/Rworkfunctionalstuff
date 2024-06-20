weather2 <-
  pivot_longer(
    d1:d31,
    names_to = "day",
    values_to = "value",
    values_drop_na = TRUE
  )
weather2
#> # A tibble: 66 × 6
#>   id       year month element day   value
#>   <chr>   <int> <int> <chr>   <chr> <dbl>
#> 1 MX17004  2010     1 tmax    d30    27.8
#> 2 MX17004  2010     1 tmin    d30    14.5
#> 3 MX17004  2010     2 tmax    d2     27.3
#> 4 MX17004  2010     2 tmax    d3     24.1
#> 5 MX17004  2010     2 tmax    d11    29.7
#> 6 MX17004  2010     2 tmax    d23    29.9
#> # ℹ 60 more rows

For presentation, I’ve dropped the missing values, making them implicit rather than explicit. This is ok because we know how many days are in each month and can easily reconstruct the explicit missing values.
We’ll also do a little cleaning:
weather3 <- weather2 %>%
  mutate(day = as.integer(gsub("d", "", day))) %>%
  select(id, year, month, day, element, value)
weather3

#> # A tibble: 66 × 6
#>   id       year month   day element value
#>   <chr>   <int> <int> <int> <chr>   <dbl>
#> 1 MX17004  2010     1    30 tmax     27.8
#> 2 MX17004  2010     1    30 tmin     14.5
#> 3 MX17004  2010     2     2 tmax     27.3
#> 4 MX17004  2010     2     3 tmax     24.1
#> 5 MX17004  2010     2    11 tmax     29.7
#> 6 MX17004  2010     2    23 tmax     29.9
