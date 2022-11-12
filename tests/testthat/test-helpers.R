test_that("we can find a field from a list of field names", {
  local_board_included <- list("facility_name", "local_board", "delivery_model")
  local_board_not_included <- list("delivery_model", "closed")

  expect_false(find_field("local_board", local_board_not_included))
  expect_equal(find_field("local_board", local_board_included), 2)
})
