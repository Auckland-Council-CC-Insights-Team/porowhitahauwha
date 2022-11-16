#' Update a Facility's Postal Address
#'
#' @param facility_name The name of the facility. Must be the primary name.
#' @param new_address The new postal address for this facility.
#' @param test_db Is this a connection to the test database? Defaults
#' to \code{FALSE}.
#'
#' @return A tibble with one row showing the updated address.
#'
#' @noRd
update_address <- function(facility_name, new_address, test_db = FALSE) {
  updated_address <- update_asset(
    facility_name,
    field = "physical_address",
    value = new_address,
    test_db = test_db
  )

  return(updated_address)

}

#' Update the assets Table
#'
#' @param facility_name The name of the facility. Must be the primary name.
#' @param field A field name you wish to update.
#' @param value A value you wish to change.
#' @param test_db Is this a connection to the test database? Defaults
#' to \code{FALSE}.
#'
#' @return A tibble with one row showing the updated asset.
#'
#' @noRd
update_asset <- function(facility_name, field, value, test_db = FALSE) {
  asset_id <- get_assets(test_db = test_db) |>
    filter(.data$name == facility_name) |>
    pull(.data$facility_id)
  updates <- paste0(field, "='", value, "'")
  record_to_update = paste0("id='", asset_id, "'")

  updated_asset <- update_record(updates, record_to_update, test_db = test_db, tbl_name = "assets")

  return(updated_asset)
}

#' Update the facilities_attributes Table
#'
#' @param facility_name The name of the facility. Must be the primary name.
#' @param field A list of field names whose values you wish to change. Should
#'   align with \code{value}.
#' @param value A list of values you wish to change. Should align with
#'   \code{field}.
#' @param test_db Is this a connection to the test database? Defaults to
#'   \code{FALSE}.
#'
#' @return A tibble with one row showing the updated facilities_attributes
#'   record.
#'
#' @noRd
update_facilities_attributes <- function(facility_name, field, value, test_db = FALSE) {
  facility_id <- verify_facility_update(facility_name, field, value, test_db) |>
    pull(facility_id)

    updates <- paste0(field, "='", value, "'") |> paste(collapse = ",")
    record_to_update <- paste0("facility_id = '", facility_id, "'")

    updated_attributes <- update_record(
      updates,
      record_to_update,
      test_db = test_db,
      tbl_name = "facilities_attributes"
      )

  return(updated_attributes)
}

#' Update a Facility in the Database
#'
#' Given a facility name, a list of fields, and a corresponding list of values,
#' update facility information in the database.
#'
#' @param facility_name The name of the facility. Must be the primary name.
#' @param field A list of field names whose values you wish to change. Should
#'   align with \code{value}.
#' @param value A list of values you wish to change. Should align with
#'   \code{field}.
#' @param test_db Is this a connection to the test database? Defaults to
#'   \code{FALSE}.
#'
#' @return A tibble with one row containing the record of the updated facility.
#' @export
#'
#' @examples
#'   update_facility(
#'   facility_name = "Buckland Community Centre",
#'   field = list("physical_address", "designation"),
#'   value = list("Corner Logan and Buckville Road", "Community Centre"),
#'   test_db = TRUE
#'   )
update_facility <- function(facility_name = NULL, field, value, test_db = FALSE) {
  location_update <- update_location(facility_name, field, value, test_db = test_db)

  if(length(location_update) > 0) {
    field <- field[-location_update]
    value <- value[-location_update]
  }

  if(length(field) > 0) {
    update_facilities_attributes(facility_name, field, value, test_db = test_db)
  }

  updated_facility <- get_facilities(.data$name == facility_name, test_db = test_db)

  # facility_change_log_entries <- verify_facility_change_log_entry(
  #   facility_id == {{facility_id}},
  #   test_db = test_db
  #   )
  #
  # prepare_change_log_items()

  return(updated_facility)
}

#' Update a Facility's Local Board
#'
#' @param facility_name The name of the facility. Must be the primary name.
#' @param new_local_board The new Local Board for this facility.
#' @param test_db Is this a connection to the test database? Defaults to
#'   \code{FALSE}.
#'
#' @return A tibble with one row showing the updated Local Board.
#'
#' @noRd
update_local_board <- function(facility_name, new_local_board, test_db = FALSE) {
  updated_local_board <- update_asset(
    facility_name,
    field = "local_board",
    value = new_local_board,
    test_db = test_db
  )

  return(updated_local_board)
}

#' Update Postal Address and Local Board Information
#'
#' @param facility_name The name of the facility. Must be the primary name.
#' @param field A list of field names whose values you wish to change. Should
#'   align with \code{value}.
#' @param value A list of values you wish to change. Should align with
#'   \code{field}.
#' @param test_db Is this a connection to the test database? Defaults to
#'   \code{FALSE}.
#'
#' @return A numeric vector identifying the indices of the location fields in
#'   \code{field}, which could be of length zero if no location fields were
#'   updated. This is used in \code{update_facility}.
#'
#' @noRd
#'
update_location <- function(facility_name, field, value, test_db = test_db) {
  new_local_board <- find_field("local_board", field)
  if(new_local_board != FALSE) {
    update_local_board(facility_name, value[[new_local_board]], test_db = test_db)
  }

  new_address <- find_field("physical_address", field)
  if(new_address != FALSE) {
    update_address(facility_name, value[[new_address]], test_db = test_db)
  }

  positions <- setdiff(c(new_local_board, new_address), 0)

  return(positions)

}

#' Update a Record in the Database
#'
#' A generic function for updating any number of fields for a single record
#' anywhere in the database.
#'
#' @param updates A string containing field-value pairs in the form
#'   \code{"field1='value1',field2='value2'"}
#' @param record_to_update A string containing an id_field_name-id pair in the
#'   form \code{"id_field_name='id'"}
#' @param test_db Is this a connection to the test database? Defaults to
#'   \code{FALSE}.
#' @param tbl_name The name of the table in which a record is being updated.
#'
#' @return A tibble containing one row with the newly-updated record.
#'
#' @noRd
update_record <- function(updates, record_to_update, test_db = FALSE, tbl_name = NULL) {
  conn <- connect_to_writable_database(test_db)

  sql_statement <- paste0("UPDATE ", tbl_name, " SET ", updates, " WHERE ", record_to_update)
  DBI::dbExecute(conn, sql_statement)
  updated_record <- DBI::dbGetQuery(
    conn,
    paste0("SELECT * FROM ", tbl_name, " WHERE ", record_to_update)
    ) |>
    tibble::as_tibble()

  disconnect_from_database(conn, test_db = test_db, confirm = FALSE)

  return(updated_record)
}
