#' Construct SIPRI ATDB Request
#'
#' Prepares an HTTP POST request to the SIPRI Arms Transfer Database (ATDB) API.
#'
#' @param verbose Logical. If TRUE, prints detailed information about the request.
#' @param start_year Numeric. Start of the date range for querying data.
#' @param end_year Numeric. End of the date range for querying data.
#' @return An `httr2` request object.
#' @keywords internal
atdb_build_request <- function(verbose = FALSE, start_year, end_year){

  # Construct JSON request body
  req_body <- glue::glue(
    '{{"filters":[
      {{"field":"Delivery year","condition":"contains","value1":{start_year},"value2":{end_year},"listData":[]}},
      {{"field":"Order year","condition":"contains","value1":0,"value2":{end_year},"listData":[]}},
      {{"field":"opendeals","condition":"","value1":"","value2":"","listData":[]}},
      {{"field":"exportOption","condition":"","value1":"","value2":"","listData":[]}}
    ],"logic":"AND"}}'
  )

  # Build request
  req <- httr2::request("https://atbackend.sipri.org/api/p/trades/trade-register-csv/") |>
    httr2::req_method("POST") |>
    httr2::req_user_agent("Rat.db (https://github.com/datapumpernickel/Rat.db)") |>
    httr2::req_body_raw(req_body, type = "application/json")


  if(verbose){
    req <- req |>
      httr2::req_verbose()
  }
  return(req)
}

#' Perform a request and retrieve response
#'
#' Executes an HTTP request and retrieves the response.
#'
#' @param req An `httr2` request object created by `atdb_build_request`.
#' @return An `httr2` response object containing the server's response.
#' @keywords internal
atdb_perform_request<- function(req){
  resp <- httr2::req_perform(req)
  return(resp)
}
