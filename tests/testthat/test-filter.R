test_that("categorical filters work", {
    skip_on_cran()
    with_mock_dir("mediseh_cymodocea_pnt-Grecia", {
        wfs <- emodnet_init_wfs_client(service = "biology")
        simple_filter_sf <- emodnet_get_layers(
            wfs = wfs,
            layers = "mediseh_cymodocea_pnt",
            cql_filter = "country='Grecia'",
            reduce_layers = TRUE
        )
    })
    expect_equal(unique(simple_filter_sf$country), 'Grecia')

    with_mock_dir("mediseh_cymodocea_pnt-Francia-Grecia", {
        wfs <- emodnet_init_wfs_client(service = "biology")
        or_filter_sf <- emodnet_get_layers(
            wfs = wfs,
            layers = "mediseh_cymodocea_pnt",
            cql_filter = "country='Francia' OR country=='Grecia'",
            reduce_layers = TRUE
        )
    })
    expect_equal(unique(or_filter_sf$country), c("Francia", "Grecia"))
})


test_that("numeric filters work", {
    skip_on_cran()
    with_mock_dir("mediseh_posidonia_nodata", {
    wfs <- emodnet_init_wfs_client(service = "biology")
        num_filter_sf <- emodnet_get_layers(
            wfs = wfs, layers = "mediseh_posidonia_nodata",
            cql_filter = "km>400",
            reduce_layers = TRUE
        )
    })
    expect_true(min(num_filter_sf$km) > 400)
})
