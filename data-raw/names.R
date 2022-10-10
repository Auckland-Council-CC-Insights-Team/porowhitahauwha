con <- porowhitahauwha::connect_to_database()

names <- tbl(con, "names") |> collect()

disconnect_from_database(con)

usethis::use_data(names, internal = TRUE, overwrite = TRUE)
