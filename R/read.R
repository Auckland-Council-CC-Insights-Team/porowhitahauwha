connect_to_database <- function() {
  dbConnect(duckdb::duckdb(), paste0(get_file_storage_path(), "/porowhita_hauwha.duckdb"))
}

get_facilities_names <- function() {
  con <- connect_to_database()

  names <- tbl(con, "names") |>
    left_join(tbl(con, "facilities_attributes"), by = c("facilities_attributes_id" = "id")) |>
    select(value, role, facilities_attributes_id, facility_type) |>
    collect()

  dbDisconnect(con, shutdown=TRUE)

  return(names)
}
