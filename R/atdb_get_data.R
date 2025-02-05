#' Get data from SIPRI Arms Transfer Database (ATDB)
#'
#' The `atdb_get_data` function retrieves arms transfer data from the
#' SIPRI arms transfer database (ATDB).
#'
#' @param verbose Logical. If TRUE, prints additional details about the query
#' process. Default is FALSE.
#' @param start_year Numeric. Start of date range to query.
#' @param end_year Numeric. End of date range to query.
#' @param cache Logical. If TRUE, caches the response and processed
#' data to avoid re-querying. Default is FALSE
#' @param tidy_cols Logical. If TRUE, formats the column headers to a tidy
#' format. Default is TRUE
#'
#' @return A tibble containing the requested data.
#'
#'
#' @export
atdb_get_data <- function(verbose = FALSE,
                          start_year,
                          end_year,
                          cache = FALSE,
                          tidy_cols = TRUE) {


  if(!rlang::is_bool(verbose)){
    rlang::abort(message = "verbose must be a logical value")
  }
  if (!is.numeric(start_year) || !is.numeric(end_year)) {
    rlang::abort(message = "start_year and end_year must be numeric values")
  }
  if (start_year > end_year) {
    rlang::abort(message = "start_year must be less than or equal to end_year")
  }
  if(!rlang::is_bool(cache)){
    rlang::abort(message = "cache must be a logical value")
  }


  req <- atdb_build_request(verbose,
                             start_year,
                             end_year)

  if(cache){
    resp <- atdb_perform_request_cached(req)
    data <- atdb_process_response_cached(resp, tidy_cols)

  } else {
    resp <- atdb_perform_request(req)
    data <- atdb_process_response(resp, tidy_cols)
  }

  return(data)

}


