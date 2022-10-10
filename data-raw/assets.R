con <- porowhitahauwha::connect_to_database()

assets <- tbl(con, "assets") |> collect()

disconnect_from_database(con)

usethis::use_data(assets, internal = TRUE, overwrite = TRUE)
