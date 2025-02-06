#' Process SIPRI ATDB Response
#'
#' Decodes the API response, extracts the CSV data, and loads it as a tibble.
#'
#' @param resp An `httr2` response object returned by `atdb_perform_request()`.
#' @param tidy_cols Logical. If TRUE formats the columns of the dataset
#' to a tidy format. Default: TRUE.
#' @return A tibble containing the processed SIPRI arms transfer data.
#' @keywords internal
atdb_process_response <- function(resp, tidy_cols) {

  # Extract and decode the base64-encoded CSV content
  data <- resp |>
    httr2::resp_body_string() |>
    jsonlite::fromJSON() |>
    (\(x) x[["bytes"]])() |>
    base64enc::base64decode() |>
    rawToChar() |>
    readr::read_csv(skip = 11, show_col_types = FALSE) # Skip SIPRI metadata rows


  atdb_pretty_cols <- Rat.db::atdb_pretty_cols

  if (tidy_cols) {

    # Ensure the processed data is a dataframe
    stopifnot(is.data.frame(data))

    # Get current column names
    curr_cols <- colnames(data)

    # Check if all column names exist in the mapping
    if (!all(curr_cols %in% atdb_pretty_cols$from)) {
      err <- paste(curr_cols[!curr_cols %in% atdb_pretty_cols$from], collapse = ", ")
      rlang::abort(
        paste(
          "The following column headers in the input dataframe are not found in",
          "the SIPRI column mapping:",
          err
        )
      )
    }

    # Rename columns using the mapping
    colnames(data) <- purrr::map_chr(curr_cols, function(x) {
      atdb_pretty_cols$to[which(atdb_pretty_cols$from == x)]
    })
  }

  # Add metadata attributes
  if (!is.null(resp)) {
    attributes(data)$url <- resp$url
  }
  attributes(data)$time <- Sys.time()


  return(data)
}
