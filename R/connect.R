#' Create a connection to Porowhita Hauwhā
#'
#' Creates a connection to either the live version or the test version
#' of the Porowhita Hauwhā database. This can be used later if this function call
#' is stored in an object. The connection to the live database is read-only.
#'
#' @param test_db Is this a connection to the test database? Defaults to FALSE.
#'
#' @return An S4 object. This object is used to communicate with the
#' database engine, either live or test.
#' @export
#'
#' @examples
#' test_conn <- connect_to_database(test_db = TRUE)
#' dplyr::tbl(test_conn, "assets")
connect_to_database <- function(test_db = FALSE) {
  if(test_db == TRUE) {
    conn <- connect_to_test_database()
  } else {
    conn <- connect_to_production_database()
  }

  return(conn)
}

#' Create a connection to Porowhita Hauwhā
#'
#' Creates a read-only connection to the live version of the Porowhita Hauwhā
#' database.
#'
#' @param read_only Is the connection to the database read-only (\code{TRUE}) or
#' not (\code{FALSE})? Default is \code{TRUE}.
#'
#' @return An S4 object. This object is used to communicate with the
#' database engine.
connect_to_production_database <- function(read_only = TRUE) {
  dbdir <- get_file_path("porowhita_hauwha.duckdb")

  conn <- DBI::dbConnect(
    duckdb::duckdb(),
    dbdir = dbdir,
    read_only = read_only
  )

  return(conn)
}

#' Create a connection to a test version of Porowhita Hauwhā
#'
#' @return An S4 object. This object is used to communicate with the
#' database engine.
connect_to_test_database <- function() {
  test_conn <- DBI::dbConnect(
    duckdb::duckdb(),
    dbdir = ":memory:",
  )

  create_test_database(test_conn)

  return(test_conn)
}

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

#' Create a database with test data
#'
#' Replicates the structure of Porowhita Hauwhā but fills it with a small sample
#' of test data.
#'
#' @param test_conn The database instance used to connect to the in-memory database.
#'
#' @return An S4 object. This object is used to communicate with the
#' test database engine.
create_test_database <- function(test_conn) {
  DBI::dbWriteTable(test_conn, 'assets', porowhitahauwha::test_assets, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'spaces', porowhitahauwha::test_spaces, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'entities', porowhitahauwha::test_entities, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'facilities_attributes', porowhitahauwha::test_facilities_attributes, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'entity_bridge_table', porowhitahauwha::test_entity_bridge_table, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'names', porowhitahauwha::test_names, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'partners', porowhitahauwha::test_partners, overwrite = TRUE)

  return(test_conn)
}

#' Disconnect from the database
#'
#' Explicitly shuts down the database instance associated with the connection, \code{conn}.
#'
#' @param conn The database instance that was called using \code{connect_to_database()}
#' @param test_db Are you attempting to disconnect from the test database? Defaults to FALSE.
#' @param confirm Should the function print a confirmation message to the console? Defaults to TRUE.
#'
#' @return An optional confirmation statement printed to the console.
#' @export
#'
#' @examples
#' con <- connect_to_database(test_db = TRUE)
#' disconnect_from_database(con, test_db = TRUE)
disconnect_from_database <- function(conn, test_db = FALSE, confirm = TRUE) {
  DBI::dbDisconnect(conn, shutdown=TRUE)

  if(confirm == TRUE) {
    db_type <- dplyr::if_else(test_db == TRUE, "test", "live")
    print(paste0("Disconnected from the ", db_type, " database."))
  }
}
