
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Rat.db

<!-- badges: start -->

[![R-CMD-check](https://github.com/datapumpernickel/Rat.db/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/datapumpernickel/Rat.db/actions/workflows/R-CMD-check.yaml)

[![codecov](https://codecov.io/gh/datapumpernickel/Rat.db/graph/badge.svg?token=J3JZD1O6AQ)](https://codecov.io/gh/datapumpernickel/Rat.db)
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

## 💲🔁️ Usage

### Retrieving Arms Transfer Data

The core function of `Rat.db` is `atdb_get_data()`, which retrieves arms
transfer data from SIPRI’s ATDB.

``` r
library(Rat.db)
atdb_get_data(verbose = FALSE, start_year, end_year, cache = TRUE)
```

#### Parameters:

- `verbose`: Logical. If `TRUE`, prints additional details about the
  query process. Default is `FALSE`.
- `start_year`: Numeric. The start of the date range to query.
- `end_year`: Numeric. The end of the date range to query.
- `cache`: Logical. If `TRUE`, caches the response to avoid redundant
  requests. Default is `FALSE`.
- `tidy_cols` Logical. If TRUE, formats the column headers to a tidy
  format. Default is `TRUE`

#### Example Usage:

``` r
# Retrieve data from 2000 to 2020, using cache
arms_data <- atdb_get_data(start_year = 2000, end_year = 2020)

# Retrieve data without using cache
arms_data_no_cache <- atdb_get_data(start_year = 2000, end_year = 2020, cache = TRUE)
```

## 🗄️ Caching Behavior

By default, `Rat.db` uses a disk-based caching system to store API
responses. This prevents redundant queries to the SIPRI database,
improving performance and reducing server load. However, keep in mind
that this could prevent you from getting the most recent data, if the
SIPRI data has been renewed, but you are still using cached data. This
is why caching is by default disabled.

#### Default Cache Settings:

- **Maximum Cache Size**: `1GB` (1024 \* 1024^2 bytes)
- **Maximum Cache Age**: `1 year` (60\*60\*24\*365 seconds)
- **Maximum Cached Entries**: Unlimited (`Inf`)

#### Changing Cache Settings:

Users can override the default cache settings by setting environment
variables before loading the package:

``` r
Sys.setenv(RATDB_CACHE_MAX_SIZE = "500 * 1024^2")  # Set max cache size to 500MB
Sys.setenv(RATDB_CACHE_MAX_AGE = "60*60*24*180")  # Set max cache age to 180 days
Sys.setenv(RATDB_CACHE_MAX_N = "500")             # Limit cache to 500 entries
```

#### Clearing the Cache

If needed, users can manually prune the cache by running:

``` r
cachem::cache_disk(dir = tools::R_user_dir('Rat.db', which = 'cache'))$prune()
```

This will remove expired entries, ensuring that outdated data is not
used in queries. However, this also happens automatically with every
request where `cache = TRUE`.

You can also run `destroy()` to fully delete the cache. Note however,
this requires a session restart to work with the package again
afterwards.

``` r
cachem::cache_disk(dir = tools::R_user_dir('Rat.db', which = 'cache'))$destroy()
```

## 📝 Sources and Methods

- Always verify a few data points manually on the SIPRI website.
- The dataset may have limitations; consult the SIPRI [**Sources and
  Methods**](https://www.sipri.org/databases/armstransfers/sources-and-methods)
  for details.
- TIV values are not comparable to actual prices of weapons, SIPRI
  writes: *SIPRI TIV figures do not represent sales prices for arms
  transfers. They should therefore not be directly compared with gross
  domestic product (GDP), military expenditure, sales values or the
  financial value of export licences in an attempt to measure the
  economic burden of arms imports or the economic benefits of exports.
  They are best used as the raw data for calculating trends in
  international arms transfers over periods of time, global percentages
  for suppliers and recipients, and percentages for the volume of
  transfers to or from particular states.*

## 🔒 Copyright

The Stockholm International Peace Research Institute limits the copying
and redistribution of its data to the following two use-cases:

- the excerption of SIPRI copyrighted material for such purposes as
  criticism, comment, news reporting, teaching, scholarship or research
  in which the use is for non-commercial purposes
- the reproduction of less than 10 per cent of a published data set.

Hence, this package does **not** contain any SIPRI data itself. It
merely automatizes the access through the website, by making the
corresponding POST request and cleaning the resulting xlsx file into
tidy formats.

## 🤝 Citation

Please make sure to cite SIPRI when using their data with:

*Information from the Stockholm International Peace Research Institute
(SIPRI) Arms Transfers Database*

You can get a citation for the package with:

``` r
citation('Rat.db')
```

------------------------------------------------------------------------

For more information, refer to the [SIPRI ATDB
website](https://armstransfers.sipri.org/ArmsTransfer/).
