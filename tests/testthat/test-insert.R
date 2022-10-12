test_that("it's possible to connect to the test database", {
  test_conn <- connect_to_writable_database(test_db = TRUE)
  expect_s4_class(test_conn, "DBIConnection")
  disconnect_from_database(test_conn, test = TRUE, confirm = FALSE)
})

test_that("we can create a new ID for the assets table", {
  test_conn <- connect_to_writable_database(test_db = TRUE)
  current_ids <- tbl(test_conn, "assets") |> pull(id)
  new_id_num <- get_new_id(test_conn, "assets")
  new_id <- paste0("A", new_id_num)
  expect_false(new_id %in% current_ids)
  disconnect_from_database(test_conn, test = TRUE, confirm = FALSE)
})

test_that("we can create a new ID for the facilities_attributes table", {
  test_conn <- connect_to_writable_database(test_db = TRUE)
  current_ids <- tbl(test_conn, "facilities_attributes") |> pull(id)
  new_id_num <- get_new_id(test_conn, "facilities_attributes")
  new_id <- paste0("FA", new_id_num)
  expect_false(new_id %in% current_ids)
  disconnect_from_database(test_conn, test = TRUE, confirm = FALSE)
})

test_that("we can add a new partner to the test database", {
  test_conn <- connect_to_writable_database(test_db = TRUE)
  new_partner <- insert_partner(
    name = "Hobbiton Charitable Trust",
    facility_owner = FALSE,
    test_db = TRUE
    )
  expect_equal(new_partner |> pull(name), "Hobbiton Charitable Trust")
  disconnect_from_database(test_conn, test = TRUE, confirm = FALSE)
})
