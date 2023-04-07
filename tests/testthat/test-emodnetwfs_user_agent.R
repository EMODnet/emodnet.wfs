test_that("emodnetwfs_user_agent() works", {
  withr::local_envvar(EMODNETWFS_CI = "yes")
  expect_match(emodnetwfs_user_agent(), "CI")
  expect_no_match(emodnetwfs_user_agent(), "DEV")

  withr::local_envvar(EMODNETWFS_CI = "")
  withr::local_envvar(GITHUB_USERNAME = "salvafern")
  expect_match(emodnetwfs_user_agent(), "DEV")
  expect_no_match(emodnetwfs_user_agent(), "CI")

  withr::local_envvar(EMODNETWFS_CI = "")
  withr::local_envvar(GITHUB_USERNAME = "not-emodnetwfs-developer")
  expect_no_match(emodnetwfs_user_agent(), "DEV")
  expect_no_match(emodnetwfs_user_agent(), "CI")
})
