#' Create a connection to the database
#'
#' Creates a connection to the database that can be called later if this function
#' call is stored in an object.
#'
#' @return Returns an S4 object. This object is used to communicate with the database engine.
#' @export
connect_to_database <- function() {
  DBI::dbConnect(
    duckdb::duckdb(),
    paste0(get_file_storage_path(), "/porowhita_hauwha.duckdb")
    )
}

#' Retrieve a list of all facility names
#'
#' Retrieve a list of facility names, variants of the names, and an ID and
#' facility type classification (asset, space, or entity) for retrieving attributes.
#'
#' @return A tibble with four columns.
#' @export
get_facilities_names <- function() {
  con <- connect_to_database()

  names <- tbl(con, "names") |>
    left_join(tbl(con, "facilities_attributes"), by = c("facilities_attributes_id" = "id")) |>
    select(value, role, facilities_attributes_id, facility_type) |>
    collect()

  DBI::dbDisconnect(con, shutdown=TRUE)

  return(names)
}
