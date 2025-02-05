
<!-- README.md is generated from README.Rmd. Please edit that file -->

{r, include = FALSE} knitr::opts_chunk\$set( collapse = TRUE, comment =
“\#\>”, fig.path = “man/figures/README-”, out.width = “100%” )

# Rat.db

<!-- badges: start -->

[![R-CMD-check](https://github.com/datapumpernickel/Rat.db/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/datapumpernickel/Rat.db/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of Rat.db is to make it easy to query the arms transfer
database (ATDB) from the [Stockholm International Peace Research
Institute](https://www.sipri.org/databases/milex). They offer the most
up-to-date, openly available data on arms transfers among states.

## 🚧 Under construction 🚧

- ⚠️ Please verify a few data points of downloaded data with the SIPRI
  website to make sure that everything works, as this is currently under
  construction.
- ⚠️ Please cite SIPRI when using the data and read the Sources and
  Methods section on their website concerning limitations linked below
  ⬇️.

## ⚙️ Installation

You can install the development version of Rat.db from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("datapumpernickel/Rat.db")
```

## 📌 Using `Rat.db`

### Retrieving Arms Transfer Data

The core function of `Rat.db` is `atdb_get_data()`, which retrieves arms
transfer data from SIPRI’s ATDB.

#### Function Signature

``` r
atdb_get_data(verbose = FALSE, start_year, end_year, cache = TRUE)
```

#### Parameters:

- `verbose`: Logical. If `TRUE`, prints additional details about the
  query process. Default is `FALSE`.
- `start_year`: Numeric. The start of the date range to query.
- `end_year`: Numeric. The end of the date range to query.
- `cache`: Logical. If `TRUE`, caches the response to avoid redundant
  requests. Default is `TRUE`.

#### Example Usage:

``` r
# Retrieve data from 2000 to 2020, using cache
arms_data <- atdb_get_data(start_year = 2000, end_year = 2020)

# Retrieve data without using cache
arms_data_no_cache <- atdb_get_data(start_year = 2000, end_year = 2020, cache = FALSE)
```

### 🗄️ Caching Behavior

By default, `Rat.db` uses a disk-based caching system to store API
responses. This prevents redundant queries to the SIPRI database,
improving performance and reducing server load.

#### Default Cache Settings:

- **Maximum Cache Size**: `1GB` (1024 \* 1024^2 bytes)
- **Maximum Cache Age**: `1 year` (60*60*24\*365 seconds)
- **Maximum Cached Entries**: Unlimited (`Inf`)

#### Changing Cache Settings:

Users can override the default cache settings by setting environment
variables before loading the package:

``` r
Sys.setenv(RATDB_CACHE_MAX_SIZE = "500 * 1024^2")  # Set max cache size to 500MB
Sys.setenv(RATDB_CACHE_MAX_AGE = "60*60*24*180")  # Set max cache age to 180 days
Sys.setenv(RATDB_CACHE_MAX_N = "500")             # Limit cache to 500 entries
```

### Clearing the Cache

If needed, users can manually clear the cache by running:

``` r
cachem::cache_disk(dir = tools::R_user_dir('Rat.db', which = 'cache'))$prune()
```

This will remove expired entries, ensuring that outdated data is not
used in queries.

### Notes on Data Validity

- Always verify a few data points manually on the SIPRI website.
- The dataset may have limitations; consult the SIPRI **Sources and
  Methods** for details.

### Additional Considerations

- **Rate Limits**: The SIPRI API may enforce rate limits. If
  experiencing issues, consider adding delays between queries.
- **Data Processing**: The retrieved data is automatically processed
  into a structured `tibble`, making it easier to analyze in R.

------------------------------------------------------------------------

For more information, refer to the [SIPRI ATDB
website](https://www.sipri.org/databases/milex).
