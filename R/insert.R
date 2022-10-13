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
#'
insert_partner <- function(name = NA, type = c("Charitable Trust", "Incorporated Society", "Other"), facility_owner = TRUE, service_provider = TRUE, legal_status_number = NA, test_db = FALSE) {
  if(!is.na(name)) {
    conn <- connect_to_writable_database(test_db)
    partner_id <- paste0("P", get_new_id(conn, tbl_name = "partners"))

    DBI::dbExecute(
      conn,
      "INSERT INTO partners VALUES (?, ?, ?, ?, ?, ?)",
      list(partner_id, name, match.arg(type), facility_owner, service_provider, legal_status_number)
    )

    new_entry <- get_new_entry(conn, tbl_name = "partners", new_id = partner_id)

    return(new_entry)
  } else {
    print("You need to supply a name for this partner before adding it to the database.")
  }
}
