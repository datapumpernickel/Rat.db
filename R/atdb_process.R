#' Process SIPRI ATDB Response
#'
#' Decodes the API response, extracts the CSV data, and loads it as a tibble.
#'
#' @param resp An `httr2` response object returned by `atdb_perform_request()`.
#' @return A tibble containing the processed SIPRI arms transfer data.
#' @keywords internal
atdb_process_response <- function(resp) {

  # Extract and decode the base64-encoded CSV content
  data <- resp |>
    httr2::resp_body_string() |>
    jsonlite::fromJSON() |>
    (\(x) x[["bytes"]])() |>
    base64enc::base64decode() |>
    rawToChar() |>
    readr::read_csv(skip = 11, show_col_types = FALSE) # Skip SIPRI metadata rows

  return(data)
}
