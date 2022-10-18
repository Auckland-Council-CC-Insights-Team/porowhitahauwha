#' Retrieve a list of all assets
#'
#' Retrieve a list of assets from Porowhita Hauwhā. An asset is a structure that
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
#' get_assets(designation == "Rural Hall", test_db = TRUE)
get_assets <- function(..., test_db = FALSE) {
  conn <- connect_to_database(test_db = test_db)

  assets <- DBI::dbGetQuery(conn, "SELECT * FROM assets") |>
    left_join(
      DBI::dbGetQuery(conn, "SELECT * FROM facilities_attributes"),
      by = c("id" = "facility_id"),
      suffix = c(".assets", ".facilities_attributes")
      ) |>
    filter(...) |>
    select(facility_id = "id", "name", "local_board", "designation", "delivery_model") |>
    tibble::as_tibble() |>
    collect()

  disconnect_from_database(conn, test_db = test_db, confirm = FALSE)

  return(assets)
}

#' Retrieve the full path to a file in File Storage
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

#' Find a facility name in the database
#'
#' @param names The facility name(s) that you're looking for in the database
#' @param test_db Retrieve this data from the test database (\code{TRUE}) or not(\code{FALSE}). Defaults to \code{FALSE}.
#'
#' @return A tibble.
get_names <- function(names, test_db = FALSE) {
  conn <- connect_to_database(test_db)

  names <- DBI::dbGetQuery(conn, "SELECT * FROM names") |>
    filter(.data$value == names) |>
    collect()

  disconnect_from_database(conn, test_db, confirm = FALSE)

  return(names)
}

#' Return the record that was just added to a database table
#'
#' @param conn The database instance used to connect to the database.
#' @param tbl_name The name of the table to which a record was just added.
#' @param new_id The ID of the record that was just added to the table.
#'
#' @return A data frame with one row.
get_new_entry <- function(conn, tbl_name, new_id) {
  new_entry <- DBI::dbGetQuery(conn, paste0("SELECT * FROM ", tbl_name)) |>
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
  max_id <- DBI::dbGetQuery(conn, paste0("SELECT * FROM ", tbl_name)) |>
    mutate(
      id_nums = stringr::str_remove_all(.data$id, "[A-Z]+"),
      id_numeric = as.numeric(.data$id_nums)
    ) |>
    dplyr::pull(.data$id_numeric) |>
    max()

  new_id <- as.character(max_id + 1)

  return(new_id)
}
