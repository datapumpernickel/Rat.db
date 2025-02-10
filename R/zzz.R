.onLoad <- function(libname, pkgname) {
  max_size_env <- Sys.getenv("RATDB_CACHE_MAX_SIZE")
  max_age_env <- Sys.getenv("RATDB_CACHE_MAX_AGE")
  max_n_env <- Sys.getenv("RATDB_CACHE_MAX_N")

  max_size <- ifelse(nzchar(max_size_env), eval(parse(text = max_size_env)),
                     1024 * 1024^2)
  max_age <- ifelse(nzchar(max_age_env), eval(parse(text = max_age_env)), 60*60*24*365)
  max_n <- ifelse(nzchar(max_n_env), eval(parse(text = max_n_env)), Inf)

  cache <- cachem::cache_disk(dir = tools::R_user_dir('Rat.db',
                                                      which = 'cache'),
                              max_size = max_size,
                              max_age = max_age,
                              max_n = max_n)

  env <- rlang::ns_env("Rat.db")

  # Unlock and reassign atdb_perform_request_cached
  if (exists("atdb_perform_request_cached", envir = env)) {
    if (bindingIsLocked("atdb_perform_request_cached", env)) {
      unlockBinding("atdb_perform_request_cached", env)
    }
  }
  atdb_perform_request_cached <- memoise::memoise(atdb_perform_request, cache = cache)
  assign("atdb_perform_request_cached", atdb_perform_request_cached, envir = env)
  lockBinding("atdb_perform_request_cached", env)  # Re-lock after assignment

  # Unlock and reassign atdb_process_response_cached
  if (exists("atdb_process_response_cached", envir = env)) {
    if (bindingIsLocked("atdb_process_response_cached", env)) {
      unlockBinding("atdb_process_response_cached", env)
    }
  }
  atdb_process_response_cached <- memoise::memoise(atdb_process_response, cache = cache)
  assign("atdb_process_response_cached", atdb_process_response_cached, envir = env)
  lockBinding("atdb_process_response_cached", env)  # Re-lock after assignment

  # Unlock and reassign cache
  if (exists("cache", envir = env)) {
    if (bindingIsLocked("cache", env)) {
      unlockBinding("cache", env)
    }
  }
  assign("cache", cache, envir = env)
  lockBinding("cache", env)  # Re-lock after assignment
}
