testthat::test_that("sipri_process_response is cached", {
  testthat::expect_true(memoise::is.memoised(
    Rat.db:::atdb_process_response_cached))
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

})

if(length(list.files(tools::R_user_dir('Rat.db', which = 'cache')))==0){
  fs::dir_delete(tools::R_user_dir('Rat.db', which = 'cache'))
}
