#' Create a connection to Porowhita Hauwhā.
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
#' tbl(test_conn, "assets")
connect_to_database <- function(test_db = FALSE) {
  if(test_db == TRUE) {
    conn <- connect_to_test_database()
  } else {
    conn <- connect_to_production_database()
  }

  return(conn)
}

#' Create a connection to Porowhita Hauwhā.
#'
#' Creates a read-only connection to the live version of the Porowhita Hauwhā
#' database.
#'
#' @return An S4 object. This object is used to communicate with the
#' database engine.
connect_to_production_database <- function() {
  dbdir <- get_file_path("porowhita_hauwha.duckdb")

  conn <- DBI::dbConnect(
    duckdb::duckdb(),
    dbdir = dbdir,
    read_only = TRUE
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
  ) |>
    create_test_database()

  return(test_conn)
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
 DBI::dbWriteTable(test_conn, "assets", test_assets, overwrite = TRUE)
 DBI::dbWriteTable(test_conn, "spaces", test_spaces, overwrite = TRUE)
 DBI::dbWriteTable(test_conn, "entities", test_entities, overwrite = TRUE)
 DBI::dbWriteTable(test_conn, "facilities_attributes", test_facilities_attributes, overwrite = TRUE)
 DBI::dbWriteTable(test_conn, "entity_bridge_table", test_entity_bridge_table, overwrite = TRUE)
 DBI::dbWriteTable(test_conn, "names", test_names, overwrite = TRUE)

 return(test_conn)
}

#' Disconnect from the database
#'
#' Explicitly shuts down the database instance associated with the connection, \code{conn}.
#'
#' @param conn The database instance that was called using \code{connect_to_database()}
#' @param test Are you attempting to disconnect from the test database? Defaults to FALSE.
#' @param confirm Should the function print a confirmation message to the console? Defaults to TRUE.
#'
#' @return An optional confirmation statement printed to the console.
#' @export
#'
#' @examples
#' con <- connect_to_database(":memory:")
#' disconnect_from_database(con)
disconnect_from_database <- function(conn, test = FALSE, confirm = TRUE) {
  DBI::dbDisconnect(conn, shutdown=TRUE)

  if(confirm == TRUE) {
    db_type <- dplyr::if_else(test == TRUE, "test", "live")
    print(paste0("Disconnected from the ", db_type, " database."))
  }
}

#' Retrieve a list of all assets
#'
#' Retrieve a list of assets from Porowhitā Hauwha. An asset is a structure that
#' provides shelter for the public.
#'
#' @param ... Optional expressions to filter the asset list, defied in terms of the
#' variables in the returned tibble.
#' @param test_db Retrieve this data from the test database? Defaults to FALSE.
#'
#' @return A tibble with six variables.
#' @export
#'
#' @examples
#' # Retrieve a list of assets that are classed as rural halls from the test database
#' get_assets(designation == "Rural Hall", test = TRUE)
get_assets <- function(..., test = FALSE) {
  conn <- connect_to_database(test_db = test)

  assets <- tbl(conn, "assets") |>
    left_join(
      tbl(conn, "facilities_attributes"),
      by = c("id" = "facility_id"),
      suffix = c(".assets", "facilities_attributes")
      ) |>
    filter(...) |>
    select(facility_id = .data$id.assets, .data$name, .data$local_board, .data$designation, .data$delivery_model) |>
    collect()

  disconnect_from_database(conn, test = test, confirm = FALSE)

  return(assets)
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
    tere::get_file_storage_path(),
    "\\",
    file_name
    )

  return(file_path)
}
