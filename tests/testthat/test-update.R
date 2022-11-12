test_that("we receive an error message when we pass a field called 'name'", {
  expect_error(name_update_check(field = "name"))
  expect_true(name_update_check(field = "field_name"))
})

test_that("the fields we want to update do exist in the facilities_attributes table", {
  expect_error(verify_field(field = "made_up_field", test_db = TRUE))
  expect_true(verify_field(field = "delivery_model", test_db = TRUE))
})

test_that("we're only able to update one record at a time", {
  many_facilities <- get_facilities(test_db = TRUE)
  one_facility <- many_facilities |> head(1)

  expect_error(record_count_check(many_facilities))
  expect_true(record_count_check(one_facility))
})

test_that("we can verify that the facility exists in the database", {
  fake_facility <- "Narnia Library"
  real_facility <- "Franklin Arts Centre"

  expect_error(verify_facility_name(fake_facility, test_db = TRUE))
  expect_true(verify_facility_name(real_facility, test_db = TRUE))
})

test_that("we can prepare a facility record for updating", {

  facility_name = "Buckland Community Centre"
  field = list("physical_address", "closed")
  value = list("Corner Logan and Buckville Road", TRUE)

  facility_to_update <- verify_facility_update(facility_name, field, value, test_db = TRUE)

  expect_equal(facility_to_update |> pull(name), facility_name)

})

test_that("we can find a field from a list of field names", {
  local_board_included <- list("facility_name", "local_board", "delivery_model")
  local_board_not_included <- list("delivery_model", "closed")

  expect_false(find_field("local_board", local_board_not_included))
  expect_equal(find_field("local_board", local_board_included), 2)
})

test_that("we can update a field in the assets table", {
  facility_name <- "Buckland Community Centre"
  field <- "physical_address"
  value <- "Corner Logan and Buckville Road"

  updated_asset <- update_asset(facility_name, field, value, test_db = TRUE)

  expect_equal(updated_asset |> pull(physical_address), "Corner Logan and Buckville Road")
})

test_that("we can successfully update the Local Board", {
  updated_asset <- update_local_board("Buckland Community Centre", "Rodney", test_db = TRUE)

  expect_equal(updated_asset |> pull(local_board), "Rodney")
})

test_that("we can successfully update the physical address", {
  updated_asset <- update_address("Buckland Community Centre", "Corner Logan and Buckville Road", test_db = TRUE)

  expect_equal(updated_asset |> pull(physical_address), "Corner Logan and Buckville Road")
})

test_that("we can update the facilities_attributes table", {
  facility_name <- "Buckland Community Centre"
  field <- list("closed", "designation")
  value <- list(TRUE, "Community Centre")

  updated_attributes <- update_facilities_attributes(facility_name, field, value, test_db = TRUE)

  expect_equal(updated_attributes |> pull(designation), "Community Centre")
  expect_equal(updated_attributes |> pull(closed), TRUE)
})

test_that("we can update information about a facility", {
  facility_name <- "Buckland Community Centre"
  field <- list("physical_address", "designation")
  value <- list("Corner Logan and Buckville Road", "Community Centre")

  updated_facility <- update_facility(facility_name, field, value, test_db = TRUE)

  expect_equal(updated_facility |> nrow(), 1)
})

# TEST UPDATE_LOCATION
