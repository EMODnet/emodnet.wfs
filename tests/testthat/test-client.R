with_mock_dir("seabed_habitats_client", {
  test_that("Default connection works", {
    wfs <- emodnet_init_wfs_client(service = "seabed_habitats_individual_habitat_map_and_model_datasets")
    expect_equal(class(wfs),
                 c("WFSClient", "OWSClient", "OGCAbstractObject", "R6"))
    expect_equal(wfs$getUrl(),
                 "https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs")
  })
})

with_mock_dir("bathymetry_client", {
  test_that("Specified connection works", {
    wfs <- emodnet_init_wfs_client(service = "bathymetry")
    expect_equal(class(wfs),
                 c("WFSClient", "OWSClient", "OGCAbstractObject", "R6"))
    expect_equal(wfs$getUrl(),
                 "https://ows.emodnet-bathymetry.eu/wfs")
  })
})

