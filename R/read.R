#' Create a connection to the database
#'
#' Creates a read-only connection to the DuckDB database that can be called later if
#' this function call is stored in an object.
#'
#' @param db_file the full path to the .duckdb file. By default assumes this is stored
#' in the Insights Team's SharePoint, sync'd to your local machine.
#' @param read_only choose whether the connection is read-only or not. Read-only by default.
#'
#' @return Returns an S4 object. This object is used to communicate with the
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

#' Retrieve the full path to the Porowhita Hauwhā .duckdb file
#'
#' Reads your .Renviron file to get the path to the team's SharePoint Document Library,
#' as sync'd to your local machine. Appends to this the name of the .duckdb file,
#' thus returning the full path to the database file to use in the connect_to_database()
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
