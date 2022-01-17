test_that("Default connection works", {
    wfs <- emodnet_init_wfs_client(service = "seabed_habitats_individual_habitat_map_and_model_datasets")
  expect_equal(class(wfs),
               c("WFSClient", "OWSClient", "OGCAbstractObject", "R6"))
  expect_equal(wfs$getUrl(),
               "https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs")
  })

test_that("Specified connection works", {
    wfs <- emodnet_init_wfs_client(service = "bathymetry")
    expect_equal(class(wfs),
                 c("WFSClient", "OWSClient", "OGCAbstractObject", "R6"))
    expect_equal(wfs$getUrl(),
                 "https://ows.emodnet-bathymetry.eu/wfs")
})

test_that("Services down handled", {

    test_url <- "https://demo.geo-solutions.it/geoserver/ows?request=GetCapabilities"

    webmockr::httr_mock()

    z <- webmockr::stub_request('get', uri = test_url) %>%
         webmockr::wi_th(headers = list('Accept' = 'application/json, text/xml, application/xml, */*'))

    webmockr::to_return(z, status = 500)
    webmockr::to_return(z, status = 200)

    req_fail <- httr::GET(test_url)
    req_success <- httr::GET(test_url)

    # Test requests
    expect_true(httr::http_error(req_fail))
    expect_false(httr::http_error(req_success))

    # Test check_service behavior
    expect_null(EMODnetWFS:::check_service(req_fail))
    expect_error(EMODnetWFS:::check_service(req_success))

    webmockr::disable()

})
