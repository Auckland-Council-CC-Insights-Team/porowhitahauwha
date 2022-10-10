test_that("it's possible to connect to DuckDB in-memory", {
  con <- connect_to_database(db_file = ":memory:")
  expect_s4_class(con, "DBIConnection")
  DBI::dbDisconnect(con, shutdown=TRUE)
})

Sys.unsetenv("MY_SHAREPOINT_FILES")
readRenviron(here(".Renviron"))
if(identical(sub('.*(?=.{7}$)', '', Sys.getenv("MY_SHAREPOINT_FILES"), perl = T), "Storage")) {
  test_that("we can construct a file path to the .duckdb file", {
    expect_equal(
      sub('.*(?=.{84}$)', '', get_file_path("porowhita_hauwha.duckdb"), perl=T),
      "\\Auckland Council\\CC Insights & Analysis Team - File Storage\\porowhita_hauwha.duckdb"
    )
  })
}
Sys.unsetenv("MY_SHAREPOINT_FILES")

test_that("we can retrieve a list of assets", {
  con <- connect_to_database(":memory:")
  DBI::dbWriteTable(con, "assets", assets)
  DBI::dbWriteTable(con, "facilities_attributes", facilities_attributes)
  asset_sample <- c("Albany House", "Acacia Court Hall", "Buckland Community Centre")
  all_assets <- get_assets(con = con) |> dplyr::pull(name)
  DBI::dbDisconnect(con, shutdown=TRUE)

  expect_true(
    setdiff(asset_sample, all_assets) |>
      length() == 0
  )
})
