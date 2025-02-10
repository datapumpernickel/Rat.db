library(testthat)
library(httptest2)

httptest2::with_mock_dir("test_data", simplify = FALSE, {

  test_that("We can get data from atdb_get_data", {
    expect_no_error(resp <- atdb_get_data(start_year = 2000,
                                          end_year = 2001,
                                          verbose = FALSE))

    expect_true(is.data.frame(resp))
    expect_true(all(c("atdb_id", "supplier",
                      "recipient",
                      "designation",
                      "description")
                    %in% names(resp)))
    expect_true(length(names(resp))==17)
  })

  test_that("Column renaming works correctly with tidy_cols", {
    resp <- atdb_get_data(start_year = 2000,
                          end_year = 2001,
                          tidy_cols = TRUE)

    # Ensure no original column names remain
    expect_false(any(names(resp) %in% Rat.db::atdb_pretty_cols$from))

    # Ensure new column names match expected tidy format
    expect_true(all(names(resp) %in% Rat.db::atdb_pretty_cols$to))
  })

  test_that("Invalid arguments are rejected", {
    expect_error(atdb_get_data(start_year = "not_a_number", end_year = 2001))
    expect_error(atdb_get_data(start_year = 2020, end_year = "not_a_number"))
    expect_error(atdb_get_data(start_year = 2025, end_year = 2000)) # Reverse order
    expect_error(atdb_get_data(start_year = 2000, end_year = 2001, verbose = "not_logical"))
    expect_error(atdb_get_data(start_year = 2000, end_year = 2001, cache = "not_logical"))
    expect_error(atdb_get_data(start_year = 2000, end_year = 2001, tidy_cols = "not_logical"))
  })

  test_that("Returned data includes expected values", {
    resp <- atdb_get_data(start_year = 2000, end_year = 2001)

    expect_true(length(unique(resp$supplier)) > 50)  # At least 100 countries
    expect_true(all(unique(resp$delivery_year) %in% 1949:2024))
  })


})
