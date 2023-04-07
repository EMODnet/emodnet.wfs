test_that(".emodnet_wfs() works", {
  skip_if_offline()
  expect_s3_class(.emodnet_wfs(), "data.frame")
  expect_true(file.exists(emodnet_cache_file()))

  withr::local_options("emodnet.services.url" = "https://masalmon.eu/no.csv")
  expect_s3_class(.emodnet_wfs(), "data.frame")

  withr::local_options("emodnet.services.csv" = "no.csv")
  expect_snapshot_error(.emodnet_wfs())
})
