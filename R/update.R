name_update_check <- function(field) {
  if(field == "name") {
    rlang::abort(
      "You cannot update the facility's primary name this way. Please use insert_name() instead."
    )
  }

  return(TRUE)
}

record_count_check <- function(facility_to_update) {
  if(nrow(facility_to_update) != 1) {
    rlang::abort(
      "You must update exactly one facility when calling this function."
    )
  }

  return(TRUE)
}

update_address <- function(facility_name, value, test_db = FALSE) {
  updated_address <- update_asset(
    facility_name,
    field = "physical_address",
    value = value,
    test_db = test_db
  )

  return(updated_address)

}

update_asset <- function(facility_name, field, value, test_db = FALSE) {
  asset_id <- get_assets(test_db = test_db) |>
    filter(name == facility_name) |>
    pull(facility_id)
  updates <- paste0(field, "='", value, "'")
  record_to_update = paste0("id='", asset_id, "'")

  updated_asset <- update_record(updates, record_to_update, test_db = test_db, tbl_name = "assets")

  return(updated_asset)
}

update_facilities_attributes <- function(facility_name, field, value, test_db = FALSE) {
  facility_id <- verify_facility_update(facility_name, field, value, test_db) |>
    pull(facility_id)

  updated_attributes <- purrr::map2_dfr(
    purrr::map2_chr(field, value, ~paste0(.x, "='", .y, "'")),
    paste0("facility_id = '", facility_id, "'"),
    ~update_record(updates = .x, record_to_update = .y, test_db = test_db, tbl_name = "facilities_attributes")
  )

  return(updated_attributes)
}

update_facility <- function(facility_name = NULL, field = list(...), value = list(...), test_db = FALSE) {
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

  updated_facility <- get_facilities(name == facility_name, test_db = test_db)

  return(updated_facility)
}

update_local_board <- function(facility_name, value, test_db = FALSE) {
  updated_local_board <- update_asset(
    facility_name,
    field = "local_board",
    value = value,
    test_db = test_db
  )

  return(updated_local_board)

}

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

verify_facility_name <- function(facility_name, test_db = FALSE) {
  facility <- get_facilities(test_db = test_db) |>
    filter(name == facility_name)

  if(nrow(facility) == 0) {
    rlang::abort("Sorry, this facility doesn't exist in the database.")
  }

  return(TRUE)
}

verify_facility_update <- function(facility_name, field, value, test_db = FALSE) {
  verify_facility_name(facility_name, test_db = test_db)

  field |>
    purrr::walk(verify_field) |>
    purrr::walk(name_update_check)

  facility_to_update <- get_facilities(test_db = test_db) |>
    filter(name == facility_name)

  record_count_check(facility_to_update)

  return(facility_to_update)
}

verify_field <- function(field) {
  modifiable_columns <- get_facilities() |> colnames()

  if(!field %in% modifiable_columns) {
    rlang::abort(
      "This field doesn't exist in the facilities table. Did you spell it correctly?"
      )
  }

  return(TRUE)
}

find_field <- function(to_match, field_list) {
  matching_field <- match(to_match, field_list)

  if(is.na(matching_field)) {
    return(FALSE)
  }

  return(matching_field)
}
