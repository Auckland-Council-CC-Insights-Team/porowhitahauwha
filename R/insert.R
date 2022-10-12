#' Create a connection to Porowhita Hauwhā
#'
#' Creates a connection to either the live version or the test version
#' of the Porowhita Hauwhā database. This can be used later if this function call
#' is stored in an object. The connection to the database is not read-only,
#' and as a result only one such connection is allowed at a time.
#'
#' @param test_db Is this a connection to the test database? Defaults
#' to \code{FALSE}.
#'
#' @return An S4 object. This object is used to communicate with the
#' database engine, either live or test.
connect_to_writable_database <- function(test_db = FALSE) {
  if(test_db == TRUE) {
    conn <- connect_to_test_database()
  } else {
    conn <- connect_to_production_database(read_only = FALSE)
  }

  return(conn)
}

#' Create a new ID for a table in the database
#'
#' Removes any letters from the values in the field called \code{id}, converts the
#' values to numeric, then extracts the maximum value and returns it as a character.
#'
#' @param conn The database instance used to connect to the database.
#' @param tbl_name The name of the database table.
#'
#' @return A character string
get_new_id <- function(conn, tbl_name) {
  max_id <- tbl(conn, tbl_name) |>
    mutate(
      id_nums = stringr::str_remove_all(.data$id, "[A-Z]+"),
      id_numeric = as.numeric(.data$id_nums)
    ) |>
    dplyr::pull(.data$id_numeric) |>
    max()

  new_id <- as.character(max_id + 1)

  return(new_id)
}

# insert_partners <- function(name = NULL, type = NULL, facility_owner = TRUE, service_provider = TRUE, legal_status_number = NULL, test_db = FALSE) {
#   conn <- connect_to_writable_database(test_db)
#   partner_id <- paste0("P", get_new_id(conn, "partners"))
#
#   query <- DBI::dbExecute(
#     conn,
#     "INSERT INTO partners VALUES (?, ?, ?, ?, ?, ?)",
#     list(partner_id, name, type, facility_owner, service_provider, legal_status_number)
#     )
# }
