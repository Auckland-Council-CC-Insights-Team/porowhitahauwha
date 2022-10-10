con <- porowhitahauwha::connect_to_database()

assets <- tbl(con, "assets") |> collect()
spaces <- tbl(con, "spaces") |> collect()
entities <- tbl(con, "entities") |> collect()
entity_bridge_table <- tbl(con, "entity_bridge_table") |> collect()
facilities_attributes <- tbl(con, "facilities_attributes") |> collect()
names <- tbl(con, "names") |> collect()

disconnect_from_database(con)

usethis::use_data(
  assets,
  spaces,
  entities,
  entity_bridge_table,
  facilities_attributes,
  names,
  internal = TRUE,
  overwrite = TRUE
  )
