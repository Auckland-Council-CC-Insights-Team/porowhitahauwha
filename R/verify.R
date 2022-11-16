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

# verify_facility_change_log_entry <- function(facility_id, field, test_db = FALSE) {
#   facility_change_log_entries <- get_change_log_entries(
#     facility_id == {{facility_id}},
#     test_db = test_db
#   ) |>
#     filter(attribute == {{field}})
#
#   if(facility_change_log_entries == FALSE) {
#     return(FALSE)
#   }
#
#   return(TRUE)
# }

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
