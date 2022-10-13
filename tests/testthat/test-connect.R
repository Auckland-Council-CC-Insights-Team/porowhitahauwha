test_that("it's possible to connect to the test database", {
  test_conn <- connect_to_database(test_db = TRUE)
  expect_s4_class(test_conn, "DBIConnection")
  disconnect_from_database(test_conn, test = TRUE, confirm = FALSE)
})
