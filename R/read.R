#' Create a connection to the database
#'
#' Creates a read-only connection to the DuckDB database that can be used later if
#' this function call is stored in an object.
#'
#' @param db_file The full path to the .duckdb file. By default assumes this is stored
#' in the Insights Team's SharePoint, sync'd to your local machine.
#' @param read_only Declares  if the connection to the database is read-only.
#' If \code{read_only = TRUE} (the default), the connection is read-only and multiple
#' R processes can access the same database file at the same time.
#'
#' @return An S4 object. This object is used to communicate with the
#' database engine.
#' @export
#'
#' @examples
#' connect_to_database(db_file = ":memory:")
connect_to_database <- function(db_file = get_db_file_path(), read_only = TRUE) {
  con <- DBI::dbConnect(
    duckdb::duckdb(),
    dbdir = db_file,
    read_only = read_only
    )

  return(con)
}

#' Disconnect from the database
#'
#' Explicitly shuts down the database instance associated with the connection, \code{con}.
#'
#' @param con The database instance that was called using \code{connect_to_database}
#'
#' @return A confirmation statement printed to the console.
#' @export
#'
#' @examples
#' con <- connect_to_database(":memory:")
#' disconnect_from_database(con)
disconnect_from_database <- function(con) {
  DBI::dbDisconnect(con, shutdown=TRUE)

  print("Disconnected from the database.")
}

#' Retrieve the full path to Porowhita Hauwhā
#'
#' Reads your .Renviron file to get the path to the team's SharePoint Document Library,
#' as sync'd to your local machine. Appends to this the name of the .duckdb file,
#' thus returning the full path to the database file to use in the \code{connect_to_database()}
#' function.
#'
#' @return A character string containing a file path
#'
get_db_file_path <- function() {
  db_file <- paste0(
    get_file_storage_path(),
    "/porowhita_hauwha.duckdb"
    )

  return(db_file)
}
