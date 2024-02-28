test_that("Specified connection works", {
  skip_if_offline()
  wfs <- create_biology_wfs()
  expect_s3_class(wfs, c("WFSClient", "OWSClient", "OGCAbstractObject", "R6"))
  expect_identical(wfs$getUrl(), "https://geo.vliz.be/geoserver/Emodnetbio/wfs")
})

test_that("Error when wrong service", {
  expect_snapshot_error(emodnet_init_wfs_client("blop"))
})
