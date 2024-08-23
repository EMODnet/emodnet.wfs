test_that("cli_alert_success() works", {
  withr::local_options(emodnet.wfs.quiet = TRUE)
  expect_silent(cli_alert_success("hihihi"))

  withr::local_options(emodnet.wfs.quiet = FALSE)
  expect_snapshot(cli_alert_success("hihihi"))
})

test_that("cli_alert_info() works", {
  withr::local_options(emodnet.wfs.quiet = TRUE)
  expect_silent(cli_alert_info("hihihi"))

  withr::local_options(emodnet.wfs.quiet = FALSE)
  expect_snapshot(cli_alert_info("hihihi"))
})

test_that("cli_alert_danger() works", {
  withr::local_options(emodnet.wfs.quiet = TRUE)
  expect_silent(cli_alert_danger("hihihi"))

  withr::local_options(emodnet.wfs.quiet = FALSE)
  expect_snapshot(cli_alert_danger("hihihi"))
})
