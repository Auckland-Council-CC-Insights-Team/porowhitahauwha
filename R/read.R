#' Create a connection to the database
#'
#' Creates a read-only connection to a DuckDB database that can be used later if
#' this function call is stored in an object.
#'
#' @param db_file The name of the .duckdb file. By default assumes this is called
#' "Porowhita Hauwhā".
#' @param read_only Declares if the connection to the database is read-only.
#' If \code{read_only = TRUE} (the default), the connection is read-only and multiple
#' R processes can access the same database file at the same time.
#'
#' @return An S4 object. This object is used to communicate with the
#' database engine.
#' @export
#'
#' @examples
#' connect_to_database(db_file = ":memory:")
connect_to_database <- function(db_file = "porowhita_hauwha.duckdb", read_only = TRUE) {
  if(db_file == ":memory:") {
    dbdir = db_file
  } else {
    dbdir <- get_file_path(db_file)
  }

  con <- DBI::dbConnect(
    duckdb::duckdb(),
    dbdir = dbdir,
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

#' Retrieve the full path to a file in File Storage.
#'
#' Reads your .Renviron file to get the path to the team's SharePoint Document Library,
#' as sync'd to your local machine. Appends to this the name of the file,
#' thus returning the full path to the file to be used elsewhere.
#'
#' @param file_name The name of the file for which you're retrieving the full path.
#'
#' @return A character string containing a file path.
#'
get_file_path <- function(file_name) {
  file_path <- paste0(
    get_file_storage_path(),
    "/",
    file_name
    )

  return(file_path)
}
