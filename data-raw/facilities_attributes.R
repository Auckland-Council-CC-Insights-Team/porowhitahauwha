con <- porowhitahauwha::connect_to_database()

facilities_attributes <- tbl(con, "facilities_attributes") |> collect()

disconnect_from_database(con)

usethis::use_data(facilities_attributes, internal = TRUE, overwrite = TRUE)
