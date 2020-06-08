test_that("Default connection works", {
    wfs <- emodnet_init_wfs_client()
  expect_equal(class(wfs),
               c("WFSClient", "OWSClient", "OGCAbstractObject", "R6"))
  expect_equal(wfs$getUrl(),
               "https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs")
  })

test_that("Specified connection works", {
    wfs <- emodnet_init_wfs_client(service = "https://ows.emodnet-bathymetry.eu/wfs")
    expect_equal(class(wfs),
                 c("WFSClient", "OWSClient", "OGCAbstractObject", "R6"))
    expect_equal(wfs$getUrl(),
                 "https://ows.emodnet-bathymetry.eu/wfs")
})
