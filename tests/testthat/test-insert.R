test_that("we can create a new ID for the assets table", {
  test_conn <- connect_to_writable_database(test_db = TRUE)
  current_ids <- DBI::dbGetQuery(test_conn, "SELECT * FROM assets") |> pull(id)
  new_id_num <- get_new_id(test_conn, 'assets')
  new_id <- paste0('A', new_id_num)

  expect_false(new_id %in% current_ids)

  disconnect_from_database(test_conn, test = TRUE, confirm = FALSE)
})

test_that("we can create a new ID for the facilities_attributes table", {
  test_conn <- connect_to_writable_database(test_db = TRUE)
  current_ids <- DBI::dbGetQuery(test_conn, "SELECT * FROM facilities_attributes") |> pull(id)
  new_id_num <- get_new_id(test_conn, 'facilities_attributes')
  new_id <- paste0('FA', new_id_num)

  expect_false(new_id %in% current_ids)

  disconnect_from_database(test_conn, test = TRUE, confirm = FALSE)
})

test_that("we can add a new record to the test database, using names as an example", {
  new_record <- insert_record(
    value = 'Buckland Community Hall',
    role = 'alternate',
    facilities_attributes_id = 'FA174',
    tbl_name = 'names',
    test_db = TRUE
    )

  expect_equal(new_record |> pull(value), "Buckland Community Hall")
})

test_that("we can add a new partner to the test database", {
  new_partner <- insert_partner(
    name = 'Hobbiton Charitable Trust',
    facility_owner = FALSE,
    test_db = TRUE
    )

  expect_equal(new_partner |> pull(name), "Hobbiton Charitable Trust")
})

test_that("we can add a new name to the names table", {
  new_record <- insert_name(
    new_name = 'Hobbiton Hall',
    facilities_attributes_id = 'FA174',
    test_db = TRUE
  )

  expect_equal(new_record |> pull(value), "Hobbiton Hall")
})

test_that("we can insert an entry into the facilities_attributes_bridge_table", {
  facility_name <- "Buckland Community Centre"
  field <- list("physical_address", "designation")
  value <- list("Corner Logan and Buckville Road", "Community Centre")

  updated_facility <- update_facility(facility_name, field, value, test_db = TRUE)

  note <- "Corrected the postal address, and converted the designation to Community Cetnre because of blah blah"

  change_log_entry <- insert_change_log(
    facility_attribute_id = updated_facility$facility_attribute_id,
    facility_type = "Asset",
    facility_id = updated_facility$facility_id,
    attribute = field[[1]],
    value = value[[1]],
    valid_from = as.Date("2022-11-14"),
    valid_to = as.Date("2022-11-15"),
    notes = note,
    test_db = TRUE
    )

  expect_equal(change_log_entry |> pull(notes), note)
})

test_that("we can add a new entry to the assets table", {
  name  <-  "Barad-dur"
  local_board  <-  "Mordor"
  postal_address  <-  "1 Dark Fortress Avenue, Mordor, 666"

  new_asset <- insert_asset(name, local_board, postal_address, test_db = TRUE)

  expect_equal(new_asset |> pull(name), "Barad-dur")
})

test_that("we can add a new entry to the facilities_attributes table", {
  facility_id <- "A1000"
  facility_type <-  "Asset"
  facility_ownership  <-"Council-owned"
  designation <-  "Rural Library"
  delivery_model  <-  "Community-led facility"
  staffed <- TRUE
  leased <- FALSE

  new_attributes <- insert_facility_attributes(
    facility_id,
    facility_type,
    designation,
    delivery_model,
    facility_ownership,
    staffed = staffed,
    leased = leased,
    test_db = TRUE
    )

  expect_equal(new_attributes |> pull(designation), "Rural Library")
})

test_that("we can add a new facility to the database", {
  name  <-  "Barad-dur"
  local_board  <-  "Mordor"
  postal_address  <-  "1 Dark Fortress Avenue, Mordor, 666"
  facility_ownership  <-"Council-owned"
  designation <-  "Rural Library"
  delivery_model  <-  "Community-led facility"
  staffed <- TRUE
  leased <- FALSE

  new_facility <- insert_facility(
    facility_type = "Asset",
    name = name,
    local_board = local_board,
    postal_address = postal_address,
    designation = designation,
    delivery_model = delivery_model,
    facility_ownership = facility_ownership,
    leased = leased,
    test_db = TRUE
  )

  expect_equal(new_facility |> pull(designation), "Rural Library")
})
