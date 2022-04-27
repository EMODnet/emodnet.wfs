test_that("categorical filters work -- biology", {
    skip_if_offline()
    wfs <- create_biology_wfs()
    with_mock_dir("Malta-Israele", {
        simple_filter_sf <- emodnet_get_layers(
            wfs = wfs,
            layers = "mediseh_cymodocea_pnt",
            cql_filter = "country='Israele'",
            reduce_layers = TRUE
        )

        or_filter_sf <- emodnet_get_layers(
            wfs = wfs,
            layers = "mediseh_cymodocea_pnt",
            cql_filter = "country='Malta' OR country=='Israele'",
            reduce_layers = TRUE
        )
    })
    expect_equal(unique(simple_filter_sf$country), 'Israele')
    expect_equal(unique(or_filter_sf$country), c("Israele", "Malta"))
})

test_that("numeric filters work -- biology", {
    skip_if_offline()
    wfs <- create_biology_wfs()
    with_mock_dir("nodata", {
        num_filter_sf <- emodnet_get_layers(
            wfs = wfs, layers = "mediseh_posidonia_nodata",
            cql_filter = "km>400",
            reduce_layers = TRUE
        )
    })
    expect_true(min(num_filter_sf$km) > 400)
})
