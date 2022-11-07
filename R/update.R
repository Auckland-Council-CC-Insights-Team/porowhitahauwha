update_facility <- function(facility_name = NULL, field = c(...), value = c(...), test_db = FALSE) {

  modifiable_columns <- get_facilities() |> colnames()

  if(!field %in% modifiable_columns) {
    return("This field doesn't existing in the facilities table. Did you spell it correctly?")
  }

  if(field != "name") {
    facility_updated <- get_facilities(test_db = test_db) |>
      filter(name == facility_name) |>
      mutate(
        {{field}} := {{value}},
        modified = TRUE
        )
  } else {
    return("You cannot update the facility's primary name this way. Please use insert_name() insted to create an alias.")
  }

  if(nrow(facility_updated) == 1) {
    if(field == "local_board") {
      facility_tables <- get_facility_tables(test_db = test_db)

      assets_check <- left_join(
        facility_updated |> select("facility_id", "name"),
        facility_tables[[1]],
        by = c("facility_id", "name")
      )

      spaces_check <- left_join(
        facility_updated |> select("facility_id", "name"),
        facility_tables[[2]],
        by = c("facility_id", "name")
      )

      entities_check <- left_join(
        facility_updated |> select("facility_id", "name"),
        facility_tables[[3]],
        by = c("facility_id", "name")
      )

      return(assets_check)
    } else {
      facility_id <- facility_updated |> pull(facility_id)

      conn <- connect_to_production_database(read_only = FALSE)

      DBI::dbExecute(
        conn,
        paste0("UPDATE facilities_attributes SET ", field, "='", value, "' WHERE facility_id='", facility_id, "'")
        )

      disconnect_from_database(conn, confirm = FALSE)

      updated_facility <- get_facilities(facility_id == {{facility_id}})

      return(updated_facility)
    }
  } else {
    return("You must update exactly one facility when calling this function.")
  }
}
