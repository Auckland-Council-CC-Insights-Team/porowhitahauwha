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
  real_facility <- "Franklin The Centre"

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
