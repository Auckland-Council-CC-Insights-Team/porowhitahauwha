test_that("we can retrieve a list of assets from the test database", {
  asset_sample <- c('Buckland Community Centre', 'Franklin The Centre')
  all_assets <- get_assets(test_db = TRUE) |> dplyr::pull(name)

  expect_true(
    setdiff(asset_sample, all_assets) |>
      length() == 0
  )
})

test_that("we can retrieve a name from the names table", {
  retrieved_names <- get_names(names = 'Buckland Hall', test_db = TRUE)

  expect_equal(retrieved_names |> pull(value), 'Buckland Hall')
})
