con <- porowhitahauwha::connect_to_database()

spaces <- tbl(con, "spaces") |> collect()

disconnect_from_database(con)

usethis::use_data(spaces, internal = TRUE, overwrite = TRUE)
