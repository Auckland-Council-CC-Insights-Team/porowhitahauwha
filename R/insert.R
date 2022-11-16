#' Add a New Entry to the \code{assets} Table
#'
#' @param name The name of the asset-type facility.
#' @param local_board The Local Board where the asset-type facility is located.
#' @param postal_address The postal address of the asset-type facility.
#' @param test_db Is this change being applied to a facility in the test
#'   database (\code{TRUE}) or not (\code{FALSE})? Defaults to \code{FALSE}.
#'
#' @return A tibble with 1 row and 9 columns showing the newly-added asset-type
#'   facility.
#'
#' @noRd
insert_asset <- function(name, local_board, postal_address, test_db = FALSE) {
  new_asset <- insert_record(
    name = name,
    local_board = local_board,
    physical_address = postal_address,
    asset_type = "Standalone Building",
    latitude = NA,
    longitude = NA,
    land_ownership = NA,
    image = NA,
    tbl_name = "assets",
    test_db = test_db
  )

  return(new_asset)
}

#' Add An Item to the Facilities Change Log
#'
#' Inserts a new row into the facilities_attributes_bridge_table, where changes
#' to the various facilities tables are recorded.
#'
#' @param facility_attribute_id The value of the facility_attribute_id for the
#'   facility whose change you're recording.
#' @param facility_type Is the facility an asset, a space, or an entity?
#' @param facility_id The value of the facility_id field for the facility whose
#'   change you're recording
#' @param attribute The attribute, or field name, that is affected by the
#'   change.
#' @param value The new value that is being supplied for this facility.
#' @param valid_from From when did this change take effect?
#' @param valid_to Until when is this change valid?
#' @param notes Explanatory notes for the change, such as the justification for
#'   the change, the meaning of the change, and/or the person who authorised
#'   this change.
#' @param test_db Is this change being applied to a facility in the test
#'   database (\code{TRUE}) or not (\code{FALSE})? Defaults to \code{FALSE}.
#'
#' @return A tibble with 1 row and 9 columns showing the log entry you supplied
#'   as recorded in the database.
#' @export
#'
#' @examples
#' change <- insert_change_log(
#' facility_attribute_id = "FA601",
#' facility_type = "Space",
#' facility_id = "S374",
#' attribute = "bookable",
#' value = "Y",
#' valid_from = Sys.Date(),
#' notes = "This room can now be booked by members of the public.",
#' test_db = TRUE
#' )
#'
#' change
insert_change_log <- function(facility_attribute_id, facility_type, facility_id, attribute, value, valid_from = NA, valid_to = NA, notes = NULL, test_db = FALSE) {
  change_item <- insert_record(
    facility_attribute_id = facility_attribute_id,
    facility_type = facility_type,
    facility_id = facility_id,
    attribute = attribute,
    value = value,
    valid_from = valid_from,
    valid_to = valid_to,
    notes = notes,
    test_db = test_db,
    tbl_name = "facilities_attributes_bridge_table"
    )

  return(change_item)
}

#' Add a New Entry to the facilities_attributes Table
#'
#' @param facility_id The id of the facility for these attributes, whether it's
#'   an asset, a space, or an entity.
#' @param facility_type Is this an asset, a space, or an entity?
#' @param designation What is the purpose of this facility? How do we classify
#'   it?
#' @param delivery_model Is this a Council-led facility or a community-led
#'   facility?
#' @param facility_ownership Is this facility owned by Council or is it
#'   privately owned?
#' @param staffed Is this facility staffed during opening hours? Defaults to
#'   \code{FALSE}.
#' @param leased  Is this a community lease facility? Defaults to \code{FALSE}.
#' @param test_db Is this facility being added to the test database
#'   (\code{TRUE}) or not (\code{FALSE})? Defaults to \code{FALSE}.
#'
#' @return A tibble with 1 row and 12 columns containing the newly-added entry
#'   to the facilities_attributes table.
#'
#' @noRd
insert_facility_attributes <- function(
    facility_id,
    facility_type,
    designation = c(
      "Venue for Hire",
      "Community Centre",
      "Rural Hall",
      "Arts & Culture",
      "Community Library",
      "Rural Library",
      "Multipurpose facility",
      "Research Centre",
      "Community Hub",
      "Special Collections"
    ),
    delivery_model = c("Community-led facility", "Council-led facility"),
    facility_ownership = c("Council-owned", "Privately-owned"),
    staffed = FALSE,
    leased = FALSE,
    test_db = FALSE
    ) {

  new_facility_attributes <- insert_record(
    property_code = NA,
    provider_legal_status_number = NA,
    entry_access_type = NA,
    facility_type = facility_type,
    facility_id = facility_id,
    designation = match.arg(designation),
    delivery_model = match.arg(delivery_model),
    facility_ownership = match.arg(facility_ownership),
    staffed = staffed,
    closed = FALSE,
    leased = leased,
    tbl_name = "facilities_attributes",
    test_db = test_db
  )

  return(new_facility_attributes)
}

#' Add a new facility name to the database
#'
#' Given a name and an ID for that facility in the \code{facilities_attributes}
#' table, insert a new record into the \code{names} table.
#'
#' @param new_name The name of the facility that is being added.
#' @param role Is this an alternate name for the facility, or its primary name? Defaults to alternate.
#' @param facilities_attributes_id The matching ID in the \code{facilities_attributes} table for the facility whose name is being supplied.
#' @param test_db Is this connection to the test database (\code{TRUE}) or not (\code{FALSE})? Defaults to \code{FALSE}.
#'
#' @return A tibble with one row containing the newly-added record.
#' @export
#'
#' @examples
#' insert_name(
#'     new_name = "Hobbiton Hall",
#'     facilities_attributes_id = "FA174",
#'     test_db = TRUE
#' )
insert_name <- function(new_name = NULL, role = c("alternate", "primary"), facilities_attributes_id = NULL, test_db = FALSE) {
  if(is.null(new_name) | is.null(facilities_attributes_id)) {
    print("You need to provide a name for the facility, as well as its ID in the facilities_attributes table.")
  } else {
    if(nrow(get_names(.data$value == {{new_name}}, test_db = test_db)) > 0) {
      print("That name has already been added to the database.")
    } else {
      new_entry <- insert_record(
        value = new_name,
        role = match.arg(role),
        facilities_attributes_id = facilities_attributes_id,
        test_db = test_db,
        tbl_name = 'names'
      )

      return(new_entry)
    }
  }
}

#' Add a new partner into the database
#'
#' If supplied with at least a name, create a new record for a partner in
#' the database.
#'
#' @param name The name of the partner that is being added to the database. This is the minimum information that should be supplied.
#' @param type Is this partner a Charitable Trust, an Incorporated Society, or Other? Default to Charitable Trust.
#' @param facility_owner Does this partner own the facility in which they operate (\code{TRUE}) or not (\code{FALSE})? Defaults to \code{TRUE}.
#' @param service_provider Does this partner provide services (\code{TRUE}) or not (\code{FALSE})? Defaults to \code{TRUE}.
#' @param legal_status_number The Legal Status Number for this partner, if available.
#' @param test_db Is this connection to the test database (\code{TRUE}) or not (\code{FALSE})? Defaults to \code{FALSE}.
#'
#' @return A data frame with one row containing the newly-added entry.
#' @export
#'
#' @examples
#' insert_partner(name = "Hobbiton Charitable Trust", facility_owner = FALSE, test_db = TRUE)
insert_partner <- function(name = NA, type = c("Charitable Trust", "Incorporated Society", "Other"), facility_owner = TRUE, service_provider = TRUE, legal_status_number = NA, test_db = FALSE) {
  if(!is.na(name)) {
    new_entry <- insert_record(
      name = name,
      type = match.arg(type),
      facility_owner = facility_owner,
      service_provider = service_provider,
      legal_status_number = legal_status_number,
      test_db = test_db,
      new_id_prefix = "P",
      tbl_name = 'partners'
    )

    return(new_entry)
  } else {
    print("You need to supply a name for this partner before adding it to the database.")
  }
}

#' Add a new record into a database table
#'
#' This is a generic function for inserting a new record into one of the tables
#' in the database.
#'
#' @param ... List of values to add include in the new record.
#' @param test_db Is this connection to the test database (\code{TRUE}) or not (\code{FALSE})? Defaults to \code{FALSE}.
#' @param new_id_prefix An optional ID prefix for the new record (e.g. "A" in the assets table).
#' @param tbl_name The name of the table into which this record is being inserted.
#'
#' @return a tibble with one row containing the newly-inserted record.
insert_record <- function(..., test_db = FALSE, new_id_prefix = NULL, tbl_name = NULL) {
  conn <- connect_to_writable_database(test_db)
  new_id <- paste0(new_id_prefix, get_new_id(conn, tbl_name = tbl_name))
  columns <- list(...)
  question_marks <- paste(replicate(length(columns), "?, "), collapse = "")
  sql_statement <- paste0("INSERT INTO ", tbl_name, " VALUES (", paste0(question_marks, "?"), ")")
  values <- append(list(id = new_id), columns)

  DBI::dbExecute(
    conn,
    sql_statement,
    unname(values)
    )

  new_entry <- get_new_entry(conn, tbl_name = tbl_name, new_id = new_id) |>
    collect()

  disconnect_from_database(conn, test_db = test_db, confirm = FALSE)

  return(new_entry)
}
