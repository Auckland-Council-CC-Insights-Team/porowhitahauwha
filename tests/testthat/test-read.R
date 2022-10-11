test_that("it's possible to connect to the test database", {
  test_conn <- connect_to_database(test_db = TRUE)
  expect_s4_class(test_conn, "DBIConnection")
  disconnect_from_database(test_conn, test = TRUE, confirm = FALSE)
})

test_that("we can retrieve a list of assets from the test database", {
  asset_sample <- c("Buckland Community Centre", "Franklin The Centre")
  all_assets <- get_assets(test_db = TRUE) |> dplyr::pull(name)

  expect_true(
    setdiff(asset_sample, all_assets) |>
      length() == 0
  )
})
