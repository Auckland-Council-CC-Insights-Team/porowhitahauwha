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
  DBI::dbWriteTable(test_conn, 'assets', porowhitahauwha::test_assets, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'spaces', porowhitahauwha::test_spaces, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'entities', porowhitahauwha::test_entities, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'facilities_attributes', porowhitahauwha::test_facilities_attributes, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'entity_bridge_table', porowhitahauwha::test_entity_bridge_table, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'names', porowhitahauwha::test_names, overwrite = TRUE)
  DBI::dbWriteTable(test_conn, 'partners', porowhitahauwha::test_partners, overwrite = TRUE)

  return(test_conn)
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
