testthat::test_that("sipri_process_response is cached", {


  testthat::expect_equal(Rat.db:::cache$info()$max_size, 1073741824)
  testthat::expect_equal(Rat.db:::cache$info()$max_age, 31536000)
  testthat::expect_equal(Rat.db:::cache$info()$max_n, Inf)
  testthat::expect_true(dir.exists(tools::R_user_dir('Rat.db',
                                                     which = 'cache')))
})

testthat::test_that("cache parameters are set correctly", {
  script_content <- "
    library(Rat.db)
    cache_info <- Rat.db:::cache$info()
    cat(paste(cache_info$max_size,
              cache_info$max_age, cache_info$max_n, sep = ','))
  "

  script_file <- tempfile()
  writeLines(script_content, script_file)

  output <- callr::rscript(script_file, env = c(
    RATDB_CACHE_MAX_SIZE = '1',
    RATDB_CACHE_MAX_AGE = '1',
    RATDB_CACHE_MAX_N = '1',
    R_USER_CACHE_DIR = 'cache_test'
  ))

  cache_values <- strsplit(output$stdout, ',')[[1]]
  cache_values <- as.numeric(cache_values)

  testthat::expect_equal(cache_values[1], 1) # max_size
  testthat::expect_equal(cache_values[2], 1) # max_age
  testthat::expect_equal(cache_values[3], 1) # max_n


  # Check that caching mechanism is set correctly
  testthat::expect_true(memoise::is.memoised(Rat.db:::atdb_perform_request_cached))
  testthat::expect_true(memoise::is.memoised(Rat.db:::atdb_process_response_cached))
})



testthat::skip_on_cran()

testthat::test_that("test .onLoad", {
  # collect options before and after loading the package
  # use different R subprocesses based on loading context
  output <- {
    if (testthat:::in_rcmd_check() || testthat:::in_covr()) {
      callr::r(function() {
        max_size_env <- Sys.getenv("RATDB_CACHE_MAX_SIZE")
        max_age_env <- Sys.getenv("RATDB_CACHE_MAX_AGE")
        max_n_env <- Sys.getenv("RATDB_CACHE_MAX_N")

        max_size <- ifelse(nzchar(max_size_env), eval(parse(text = max_size_env)), 1024 * 1024 ^
                             2)
        max_age <- ifelse(nzchar(max_age_env), eval(parse(text = max_age_env)), 60 *
                            60 * 24 * 365)
        max_n <- ifelse(nzchar(max_n_env), eval(parse(text = max_n_env)), Inf)
        library(Rat.db)
        Rat.db:::.onLoad(libname = "Rat.db", pkgname = "Rat.db")
        testthat::expect_equal(Rat.db:::cache$info()$max_size, max_size)
        testthat::expect_equal(Rat.db:::cache$info()$max_age, max_age)
        testthat::expect_equal(Rat.db:::cache$info()$max_n, max_n)
        testthat::expect_true(dir.exists(tools::R_user_dir('Rat.db', which = 'cache')))

        return(TRUE)

      })
    } else if (!testthat:::in_rcmd_check()) {
      callr::r(function() {
        max_size_env <- Sys.getenv("RATDB_CACHE_MAX_SIZE")
        max_age_env <- Sys.getenv("RATDB_CACHE_MAX_AGE")
        max_n_env <- Sys.getenv("RATDB_CACHE_MAX_N")

        max_size <- ifelse(nzchar(max_size_env), eval(parse(text = max_size_env)), 1024 * 1024 ^
                             2)
        max_age <- ifelse(nzchar(max_age_env), eval(parse(text = max_age_env)), 60 *
                            60 * 24 * 365)
        max_n <- ifelse(nzchar(max_n_env), eval(parse(text = max_n_env)), Inf)
        pkgload::load_all()
        Rat.db:::.onLoad(libname = "Rat.db", pkgname = "Rat.db")
        testthat::expect_equal(Rat.db:::cache$info()$max_size, max_size)
        testthat::expect_equal(Rat.db:::cache$info()$max_age, max_age)
        testthat::expect_equal(Rat.db:::cache$info()$max_n, max_n)
        testthat::expect_true(dir.exists(tools::R_user_dir('Rat.db', which = 'cache')))
        return(TRUE)

      })

    }
  }
  testthat::expect_true(output)
})

if(length(list.files(tools::R_user_dir('Rat.db', which = 'cache')))==0){
  fs::dir_delete(tools::R_user_dir('Rat.db', which = 'cache'))
}
