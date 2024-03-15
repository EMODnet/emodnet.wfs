test_that("deprecate_msg_service_version() works", {
  expect_silent(deprecate_msg_service_version(NULL, "blop"))
  expect_snapshot(deprecate_msg_service_version("1.1", "blop"))
})
