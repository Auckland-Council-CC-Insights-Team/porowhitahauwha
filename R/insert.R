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

#' Return the record that was just added to a database table
#'
#' @param conn The database instance used to connect to the database.
#' @param tbl_name The name of the table to which a record was just added.
#' @param new_id The ID of the record that was just added to the table.
#'
#' @return A data frame with one row.
get_new_entry <- function(conn, tbl_name, new_id) {
  new_entry <- tbl(conn, tbl_name) |>
    filter(.data$id == new_id)

  return(new_entry)
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

#' Add a new partner into the database
#'
#' If supplied with at least a name, create a new record for a partner in
#' the database.
#'
#' @param name The name of the partner that is being added to the database. This is the minimum information that should be supplied.
#' @param type Is this partner a Charitable Trust, an Incorporated Society, or Other? Default to Charitable Trust.
#' @param facility_owner Does this partner own the facility in which they operate (\code{TRUE}) or not (\code{FALSE})? Defaults to \code{TRUE}.
#' @param service_provider Does this partner provide services (\code{TRUE}) or not (\code{FALSE})? Defaults to \code{TRUE}.
#' @param legal_status_number The Legal Status Number for this partner, if available.
#' @param test_db Is this connection to the test database (\code{TRUE}) or not (\code{FALSE})? Defaults to \code{FALSE}.
#'
#' @return A data frame with one row containing the newly-added entry.
#' @export
#'
#' @examples
#' insert_partner(name = "Hobbiton Charitable Trust", facility_owner = FALSE, test_db = TRUE)
#'
insert_partner <- function(name = NA, type = c("Charitable Trust", "Incorporated Society", "Other"), facility_owner = TRUE, service_provider = TRUE, legal_status_number = NA, test_db = FALSE) {
  if(!is.na(name)) {
    conn <- connect_to_writable_database(test_db)
    partner_id <- paste0("P", get_new_id(conn, tbl_name = "partners"))

    DBI::dbExecute(
      conn,
      "INSERT INTO partners VALUES (?, ?, ?, ?, ?, ?)",
      list(partner_id, name, match.arg(type), facility_owner, service_provider, legal_status_number)
    )

    new_entry <- get_new_entry(conn, tbl_name = "partners", new_id = partner_id)

    return(new_entry)
  } else {
    print("You need to supply a name for this partner before adding it to the database.")
  }
}
