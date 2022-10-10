con <- porowhitahauwha::connect_to_database()

entity_bridge_table <- tbl(con, "entity_bridge_table") |> collect()

disconnect_from_database(con)

usethis::use_data(entity_bridge_table, internal = TRUE, overwrite = TRUE)
