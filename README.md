
<!-- README is generated from README.Rmd, edit ONLY that file if needed-->

# Data for Preceptor’s Primer for Bayesian Data Science

## About:

`PPBDS.data` provides the data used in *[Preceptor’s Primer for Bayesian
Data Science](https://davidkane9.github.io/PPBDS/)*, the textbook used
in [Gov 50:
Data](https://www.davidkane.info/files/gov_50_fall_2020.html) at Harvard
University.There are currently 5 different data sets to choose from that
span topics from a social experiment in the Boston, MA *“T”* stations to
an insurance plan in Mexico.

<!-- unsure if badges are available for use yet here -->

### CCES Data:

  - Sourced from [Kuriwaki (2018)](https://doi.org/10.7910/DVN/II2DB6).
  - Features ideological, demographic, educational, and other
    information from the *Cooperative Congressional Election Study*.

### NES Data:

  - Cleaned subset of data from the [National Election
    Survey](https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/).
  - Features ideological, demographic, educational, and other
    information from respondents. See
    [Codebooks](https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/)
    for questionnaire and other details.

### QSCORES Data:

  - Data from Harvard’s own student [course
    reviews](https://q.fas.harvard.edu/).
  - Students answer multiple choice and free response questions about
    their courses upon completion, and this is a subset of their
    responses.

### SPS Data:

  - Survey data from a randomized healthcare experiment done in several
    states in Mexico.
  - Sourced from [King et.
    al. (2009)](https://gking.harvard.edu/files/gking/files/pubpolforpoor.pdf).

### TRAINS Data:

  - Data from a study by [Enos
    (2016)](https://scholar.harvard.edu/files/renos/files/enostrains.pdf)
    who addressed exclusionary attitudes and cultural exposures.

## Installation:

As this package is not relaesed on CRAN, you can download it directly
from GitHub\!

``` r
remotes::install_github("davidkane9/PPBDS.data")
```

## Loading Preceptor’s Data:

After remote-installing the package, it loads as any package should.

``` r
library(tidyverse) # the tidyverse is your new best friend
library(PPBDS.data)

qscores
#> # A tibble: 748 x 8
#>    course_name department course_number term  enrollment workload overall
#>    <chr>       <chr>      <chr>         <chr>      <int>    <dbl>   <dbl>
#>  1 " Introduc~ AFRAMER    100Y          2019S         49      2.6     4.2
#>  2 " American~ AFRAMER    123Z          2019S         49      3.6     4.4
#>  3 " Urban In~ AFRAMER    125X          2019S         40      5.2     4.5
#>  4 " Richard ~ AFRAMER    130X          2019S         23      7.2     4.4
#>  5 " 19th cen~ AFRAMER    131Y          2019S         20      3.5     4.9
#>  6 " Social R~ AFRAMER    199X          2019S         19      7.2     4.8
#>  7 " Martin L~ AFRAMER    199Y          2019S         40      4.2     4.7
#>  8 " Elementa~ AFRIKAAN   AB            2019S         22      2.9     4.9
#>  9 " Elementa~ JAMAICAN   AB            2019S         18      1.5     4.9
#> 10 " Elementa~ WSTAFRCN   AB            2019S         29      2.6     4  
#> # ... with 738 more rows, and 1 more variable: prof_name <chr>
```

## Using the data

Once the library is loaded and you have confirmed that it can be
accessed in your local environment, the data sets can be called as
objects and used like any other data you would otherwise read in and
assign to an object manually. See the following example of a plot using
`PPBDS.data::qscores`.

``` r

library(ggplot2)

qscores %>%
  filter(department == "GOV") %>%
  ggplot(aes(y = workload, x = enrollment)) + 
  geom_point(aes(color = term)) + 
  labs(
    title = "Rudimentary Graphic to Test Function",
    subtitle = "Better graphic, potentially from 1005 work coming",
    caption = "Never forget to cite"
  )
```

<img src="man/README-quick.plot-1.png" width="100%" />
