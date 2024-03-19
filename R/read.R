#' Retrieve a list of all assets
#'
#' Retrieve a list of assets from Porowhita Hauwhā. An asset is a structure that
#' provides shelter for the public...
#'
#' @param ... Optional expressions to filter the asset list, defied in terms of the
#' variables in the returned tibble.
#' @param test_db Retrieve this data from the test database? Defaults to FALSE.
#'
#' @return A tibble with eight variables.
#' @export
#'
#' @examples
#' # Retrieve a list of assets that are classed as rural halls from the test database
#' get_assets(designation == "Rural Hall", test_db = TRUE)
get_assets <- function(..., test_db = FALSE) {
  assets <- get_attributes("assets", test_db = test_db) |>
    prepare_facilities_data(...)

  return(assets)
}

#' Join Facilities With Their Attributes
#'
#' Given a facility type (assets, spaces, or entities), join them with the
#' facilities_attributes table.
#'
#' @param facility_type Is this query for the \code{assets}, \code{spaces}, or \code{entities} table?
#' @param test_db Retrieve this data from the test database? Defaults to \code{FALSE}.
#'
#' @return A data frame with same number of rows as the table declared in \code{facility_type}.
#'
#' @noRd
get_attributes <- function(facility_type = c("assets", "spaces", "entities"), test_db = FALSE) {
  conn <- connect_to_database(test_db = test_db)

  table_with_attributes <- DBI::dbGetQuery(
    conn,
    paste("SELECT * FROM ", match.arg(facility_type))
    ) |>
    left_join(
      DBI::dbGetQuery(conn, "SELECT * FROM facilities_attributes"),
      by = c("id" = "facility_id")
    )

  disconnect_from_database(conn, test_db = test_db, confirm = FALSE)

  return(table_with_attributes)
}

# get_change_log_entries <- function(..., test_db = FALSE) {
#   conn <- connect_to_database(test_db = test_db)
#
#   change_log_items <- DBI::dbGetQuery(
#     conn,
#     "SELECT * FROM facilities_attributes_bridge_table"
#   ) |>
#     filter(...) |>
#     collect()
#
#   disconnect_from_database(conn, confirm = FALSE)
#
#   return(change_log_items)
# }

#' Retrieve a list of all entities
#'
#' Retrieve a list of entities from Porowhita Hauwhā. An entity is a construct,
#' assigned by Auckland Council, that groups together assets, spaces, or
#' services.
#'
#' @param ... Optional expressions to filter the entities list, defied in terms of
#'   the variables in the returned tibble.
#' @param test_db Retrieve this data from the test database? Defaults to FALSE.
#'
#' @return A tibble with eight variables.
#' @export
#'
#' @examples
#' # Retrieve a list of entities that are classed as Community Hubs from the test database
#' get_entities(designation == "Community Hub", test_db = TRUE)
get_entities <- function(..., test_db = FALSE) {
  entities <- get_attributes(facility_type = "entities", test_db = test_db) |>
    left_join(get_entities_location(test_db = test_db), by = c("id" = "entity_id")) |>
    prepare_facilities_data(...)

  return(entities)
}

#' Get each entity's Local Board
#'
#' Join entities to their components and retrieve the Local Board, which is
#' usually (not not always) a one-to-one relationship
#'
#' @param test_db Retrieve this data from the test database? Defaults to FALSE.
#'
#' @return A \code{tibble} with as many rows as there are entity-location
#'   combinations
#'
#' @noRd
get_entities_location <- function(test_db) {
  conn <- connect_to_database(test_db = test_db)

  bridge_table <- DBI::dbGetQuery(conn, "SELECT * FROM entity_bridge_table") |>
    select("facility_type", "facility_id", "entity_id")

  assets_minimal <- DBI::dbGetQuery(conn, "SELECT * FROM assets") |>
    select(asset_id = "id", "physical_address", "local_board", "latitude", "longitude")

  asset_entities <- bridge_table |>
    filter(.data$facility_type == "asset") |>
    left_join(assets_minimal, by = c("facility_id" = "asset_id"))

  spaces_with_location <- DBI::dbGetQuery(conn, "SELECT * FROM spaces") |>
    left_join(assets_minimal, by = "asset_id") |>
    select(space_id = "id", "local_board", "physical_address", "latitude", "longitude")

  space_entities <- bridge_table |>
    filter(.data$facility_type == "space") |>
    left_join(spaces_with_location, by = c("facility_id" = "space_id"))

  disconnect_from_database(conn, test_db = test_db, confirm = FALSE)

  entities_with_local_board <- dplyr::bind_rows(asset_entities, space_entities) |>
    dplyr::distinct(.data$entity_id, .data$physical_address, .data$local_board, .data$latitude, .data$longitude)

  return(entities_with_local_board)
}

#' Retrieve a list of all facilities
#'
#' Returns a list of all facilities in the database, with key information about
#' each. For more information about how facilities are classified in the
#' database, please consult the documentation that accompanies the test data.
#'
#' @param ... List of attribute-value pairs with which to filter the list of
#'   returned facilities.
#' @param test_db Retrieve this data from the test database? Defaults to
#'   \code{FALSE}.
#'
#' @return A tibble with one facility per row, and one column per attribute for
#'   each facility.
#' @export
#'
#' @examples
#' # Return a list of all community-led facilities in the database
#' get_facilities(delivery_model == "Community-led facility", test_db = TRUE)
get_facilities <- function(..., test_db = FALSE) {
  facility_tables <- get_facility_tables(test_db = test_db)

  facilities <- dplyr::bind_rows(facility_tables) |>
    filter(!.data$designation %in% c("Room", "Hybrid", "Building")) |>
    filter(...)

  return(facilities)
}

#' Create a List of the Three Facility Tables
#'
#' Facilities can be found in either the assets, spaces, or entities tables. This
#' function returns each of these tables as items in a list.
#'
#' @param test_db Retrieve this data from the test database?
#'
#' @return A list of three tibbles: a tibble of assets, a tibble of spaces, and
#'   a table of entities.
#'
#' @noRd
get_facility_tables <- function(test_db = FALSE) {
  assets <- get_assets(test_db = test_db)
  spaces <- get_spaces(test_db = test_db)
  entities <- get_entities(test_db = test_db)

  facility_tables <- list(assets, spaces, entities)

  return(facility_tables)
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


#' Return a dataframe of community libraries
#'
#' @param test_db Retrieve this data from the test database? Defaults to
#'   \code{FALSE}.
#'
#' @return A tibble with one library per row, and one column per attribute for
#'   each library.
#'
#' @export
get_libraries <- function(test_db = FALSE) {
  libraries <- get_facilities(designation == "Community Library")

  conn <- connect_to_database(test_db = test_db)

  entity_bridge_tbl <- DBI::dbGetQuery(conn, paste0("SELECT entity_id, facility_id FROM entity_bridge_table"))
  entities <- DBI::dbGetQuery(conn, paste0("SELECT * FROM entities"))
  facilities_attributes <- DBI::dbGetQuery(conn, paste0("SELECT * FROM facilities_attributes"))

  disconnect_from_database(conn, test_db = test_db, confirm = FALSE)

  libraries_and_hubs <- dplyr::left_join(libraries, entity_bridge_tbl, by = "facility_id") |>
    dplyr::left_join(entities, by = c("entity_id" = "id")) |>
    select(facility_name = name.x, community_hub_name = name.y, everything(), -entity_id)

  return(libraries_and_hubs)
}

#' Find Facility Names and Aliases in the Database
#'
#' Call this function without passing any arguments to return the entire content
#' of the names table, otherwise filter the table by any of its variables for a
#' more specific response.
#'
#' @param ... Optional arguments passed to the \code{get_names} to filter the
#'   names returned.
#' @param test_db Retrieve this data from the test database (\code{TRUE}) or
#'   not (\code{FALSE}). Defaults to \code{FALSE}.
#'
#' @return A tibble.
#'
#' @export
#'
#' @examples
#' # Search for a facility and return any aliases
#' get_names(value == "Buckland Community Centre", test_db = TRUE)
get_names <- function(..., test_db = FALSE) {
  conn <- connect_to_database(test_db)

  all_names <- DBI::dbGetQuery(conn, "SELECT * FROM names") |>
    as_tibble() |>
    collect()

  disconnect_from_database(conn, test_db, confirm = FALSE)

  filtered_names <- all_names |>
    filter(...)

  if(nrow(all_names) == nrow(filtered_names)) {
    return(all_names)
  } else {
    names <- all_names |>
      filter(
        .data$facilities_attributes_id %in% (filtered_names |> pull(.data$facilities_attributes_id))
      )

    return(names)
  }
}

#' Return the record that was just added to a database table
#'
#' @param conn The database instance used to connect to the database.
#' @param tbl_name The name of the table to which a record was just added.
#' @param new_id The ID of the record that was just added to the table.
#'
#' @return A data frame with one row.
#'
#' @noRd
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
#'
#' @noRd
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

#' Retrieve a List of All Partners
#'
#' Returns a list of partners from the database, plus the names and IDs of any
#' facilities they're associated with.
#'
#' @param ... List of attribute-value pairs with which to filter the list of
#'   returned partners.
#' @param test_db Retrieve this data from the test database? Defaults to
#'   \code{FALSE}.
#'
#' @return A tibble containing 9 columns, where each row is a partner.
#' @export
#'
#' @examples
#' charitable_trusts <- get_partners(type = "Charitable Trust", test_db = TRUE)
#' charitable_trusts
#'
get_partners <- function(..., test_db = FALSE) {
  conn <- connect_to_database(test_db = test_db)

  partners_table <- DBI::dbGetQuery(conn, "SELECT * FROM partners") |>
    left_join(
      DBI::dbGetQuery(conn, "SELECT partner_id, facility_type, facility_id FROM partners_bridge_table"),
      by = c("id" = "partner_id")
    )
  facilities_minimal <- get_facilities(test_db = test_db) |>
    select(facility_name = "name", "facility_type", "facility_id", "facility_attribute_id")

  partners <- partners_table |>
    left_join(facilities_minimal, by = c("facility_id", "facility_type")) |>
    collect() |>
    tibble::as_tibble()

  disconnect_from_database(conn, test_db = test_db, confirm = FALSE)

  return(partners)
}

#' Retrieve a list of all spaces
#'
#' Retrieve a list of spaces from Porowhita Hauwhā. A space is an area in which
#' services are delivered to the public, located within an asset
#'
#' @param ... Optional expressions to filter the space list, defied in terms of
#'   the variables in the returned tibble.
#' @param test_db Retrieve this data from the test database? Defaults to FALSE.
#'
#' @return A tibble with eight variables.
#' @export
#'
#' @examples
#' # Retrieve a list of spaces that are classed as community libraries from the test database
#' get_spaces(designation == "Community Library", test_db = TRUE)
get_spaces <- function(..., test_db = FALSE) {
  conn <- connect_to_database(test_db = test_db)

  assets_minimal <- DBI::dbGetQuery(conn, "SELECT * FROM assets") |>
    select(asset_id = "id", "physical_address", "local_board", "latitude", "longitude")

  disconnect_from_database(conn, test_db = test_db, confirm = FALSE)

  spaces <- get_attributes("spaces", test_db = test_db) |>
    left_join(
      assets_minimal,
      by = "asset_id"
    ) |>
    prepare_facilities_data(...)

  return(spaces)
}

#' Prepare the facilities data for binding
#'
#' Given a facilities-with-attributes dataset, choose the user-specified rows
#' and select standard columns
#'
#' @param df A facilities-with-attributes dataset
#' @param ... Optional expressions to filter the asset list, defied in terms of the
#' variables in the returned tibble.
#'
#' @return A tibble
#'
#' @noRd
prepare_facilities_data <- function(df, ...) {
  facilities_data <- df |>
    filter(...) |>
    select("facility_type", facility_id = "id", facility_attribute_id = "id.y", "name", "physical_address", "local_board", "latitude", "longitude", "designation", "delivery_model", "facility_ownership", "closed", "staffed", "leased", "entry_access_type") |>
    tibble::as_tibble() |>
    collect()

  return(facilities_data)
}
