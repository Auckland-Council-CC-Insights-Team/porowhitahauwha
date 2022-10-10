con <- porowhitahauwha::connect_to_database()

entities <- tbl(con, "entities") |> collect()

disconnect_from_database(con)

usethis::use_data(entities, internal = TRUE, overwrite = TRUE)
