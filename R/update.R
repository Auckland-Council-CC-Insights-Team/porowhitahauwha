#' Checks if the field is the 'name' field
#'
#' @param field The value of the field name to check.
#'
#' @return Returns an error message if \code{field} is equal to 'name',
#'   otherwise returns \code{TRUE}
#'
#' @noRd
name_update_check <- function(field) {
  if(field == "name") {
    rlang::abort(
      "You cannot update the facility's primary name this way. Please use insert_name() instead."
    )
  }

  return(TRUE)
}

#' Checks if more than one facility is being updated
#'
#' @param facility_to_update A data frame containing facilities.
#'
#' @return Returns an error message if \code{facility_to_update} is not equal to
#'   1, otherwise returns \code{TRUE}
#'
#' @noRd
record_count_check <- function(facility_to_update) {
  if(nrow(facility_to_update) != 1) {
    rlang::abort(
      "You must update exactly one facility when calling this function."
    )
  }

  return(TRUE)
}

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

    updates <- purrr::map2_chr(field, value, ~paste0(.x, "='", .y, "'")) |>
      paste(collapse = ",")
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
  new_local_board <- find_field("local_board", field)
  if(new_local_board != FALSE) {
    update_local_board(facility_name, value[[new_local_board]], test_db = test_db)
    field <- field[-new_local_board]
    value <- value[-new_local_board]
  }

  new_address <- find_field("physical_address", field)
  if(new_address != FALSE) {
    update_address(facility_name, value[[new_address]], test_db = test_db)
    field <- field[-new_address]
    value <- value[-new_address]
  }

  if(length(field) > 0) {
    update_facilities_attributes(facility_name, field, value, test_db = test_db)
  }

  updated_facility <- get_facilities(.data$name == facility_name, test_db = test_db)

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

#' Check That a Facility Exists in the Database
#'
#' @param facility_name The name of the facility. Must be the primary name.
#' @param test_db Is this a connection to the test database? Defaults to
#'   \code{FALSE}.
#'
#' @return Returns an error message if the facility is not found based on its
#'   primary name, otherwise returns \code{TRUE}
#'
#' @noRd
verify_facility_name <- function(facility_name, test_db = FALSE) {
  facility <- get_facilities(test_db = test_db) |>
    filter(.data$name == facility_name)

  if(nrow(facility) == 0) {
    rlang::abort("Sorry, this facility doesn't exist in the database.")
  }

  return(TRUE)
}

#' Check That It's Possible to Update the Facility
#'
#' Does the facility exist? Does the field you're trying to update exist? Are
#' you trying to update a name? Are trying to update more than one facility at a
#' time?
#'
#' @param facility_name The name of the facility. Must be the primary name.
#' @param field A list of field names whose values you wish to change. Should
#'   align with \code{value}.
#' @param value A list of values you wish to change. Should align with
#'   \code{field}.
#' @param test_db Is this a connection to the test database? Defaults to
#'   \code{FALSE}.
#'
#' @return A tibble containing one row with the record of the facility you wish
#'   to update.
#'
#' @noRd
verify_facility_update <- function(facility_name, field, value, test_db = FALSE) {
  verify_facility_name(facility_name, test_db = test_db)

    purrr::walk(field, ~verify_field(.x, test_db = test_db)) |>
      purrr::walk(name_update_check)

  facility_to_update <- get_facilities(test_db = test_db) |>
    filter(.data$name == facility_name)

  record_count_check(facility_to_update)

  return(facility_to_update)
}

#' Check That This is a Genuine Facilities Field
#'
#' @param field The name of a field that relates to facilities.
#' @param test_db Is this a connection to the test database? Defaults to
#'   \code{FALSE}.
#'
#' @return Returns an error message if the field doesn't exist, otherwise
#'   returns \code{TRUE}
#'
#' @noRd
verify_field <- function(field, test_db = FALSE) {
  modifiable_columns <- get_facilities(test_db = test_db) |> colnames()

  if(!field %in% modifiable_columns) {
    rlang::abort(
      "This field doesn't exist in the facilities table. Did you spell it correctly?"
      )
  }

  return(TRUE)
}

#' Find the Position of a Field
#'
#' Given a list of field names, find the index of a particular field in the
#' list.
#'
#' @param to_match The name of the field you're trying to locate in the list.
#' @param field_list A character vector containing genuine field names.
#'
#' @return Returns \code{FALSE} if the field name isn't found in the list,
#'   otherwise returns the index of the field name in the list.
#'
#' @noRd
find_field <- function(to_match, field_list) {
  matching_field <- match(to_match, field_list)

  if(is.na(matching_field)) {
    return(FALSE)
  }

  return(matching_field)
}
