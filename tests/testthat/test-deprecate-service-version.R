test_that("deprecate_message_service_version() works", {
  expect_silent(deprecate_message_service_version(NULL, "blop"))
  expect_snapshot(deprecate_message_service_version("1.1", "blop"))
})
