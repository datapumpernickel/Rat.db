testthat::test_that('test that build returns a httr2 request',{
  req <- Rat.db:::atdb_build_request(start_year = 2000, end_year = 2001)
  testthat::expect_equal(class(req),'httr2_request')

  testthat::expect_true(stringr::str_detect(req$url,
                                            'https://atbackend.sipri.org/api/p/trades/trade-register-csv/'))
  testthat::expect_true(stringr::str_detect(req$body$data,
                                            '"value2":2001'))
  testthat::expect_true(stringr::str_detect(req$body$data,
                                            '"value1":2000'))
})

httptest2::with_mock_dir("test_data",simplify = F, {
  testthat::test_that("We can get data", {
    resp <- Rat.db:::atdb_build_request(start_year = 2000, end_year = 2001) |>
      Rat.db:::atdb_perform_request()
    testthat::expect_equal(class(resp),'httr2_response')
  })
})
