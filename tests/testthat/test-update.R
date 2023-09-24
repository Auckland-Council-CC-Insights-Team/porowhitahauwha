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


test_that("we can successfully update the contact details", {
  updated_contact <- update_contact(contact_name = 'test123',
                                    email_address = 'test789@ac.govt.nz',
                                    partner_id = 'P1', role = 'Site contact',
                                    test_db = TRUE)

  expect_equal(updated_contact |> pull(email_address), 'test789@ac.govt.nz')
})
