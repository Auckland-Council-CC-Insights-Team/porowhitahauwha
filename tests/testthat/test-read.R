test_that("it's possible to connect to DuckDB in-memory", {
  con <- connect_to_database(db_file = ":memory:")
  expect_s4_class(con, "DBIConnection")
  DBI::dbDisconnect(con, shutdown=TRUE)
})

test_that("we can construct a file path to the .duckdb file", {
  expect_equal(
    sub('.*(?=.{84}$)', '', get_file_path("porowhita_hauwha.duckdb"), perl=T),
    "/Auckland Council/CC Insights & Analysis Team - File Storage/porowhita_hauwha.duckdb"
    )
})
