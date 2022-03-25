test_that("categorical filters work -- biology", {
    skip_if_offline()
    wfs <- create_biology_wfs()
    with_mock_dir("mediseh_cymodocea_pnt-Francia-Grecia", {
        simple_filter_sf <- emodnet_get_layers(
            wfs = wfs,
            layers = "mediseh_cymodocea_pnt",
            cql_filter = "country='Grecia'",
            reduce_layers = TRUE
        )

        or_filter_sf <- emodnet_get_layers(
            wfs = wfs,
            layers = "mediseh_cymodocea_pnt",
            cql_filter = "country='Francia' OR country=='Grecia'",
            reduce_layers = TRUE
        )
    })
    expect_equal(unique(simple_filter_sf$country), 'Grecia')
    expect_equal(unique(or_filter_sf$country), c("Francia", "Grecia"))
})

test_that("categorical filters work -- geology_seabed_substrate_maps", {
    wfs <- create_geology_seabed_substrate_maps_wfs()

    expect_equal(emodnet_get_layers(wfs = wfs,
        layers = "seabed_substrate_1m",
        cql_filter = "country='Baltic Sea'",
        reduce_layers = TRUE)$country %>% unique(), 'Baltic Sea')


    or_filter_sf <- emodnet_get_layers(wfs = wfs, layers = "seabed_substrate_1m",
        cql_filter = "country='Baltic Sea' OR country='Bulgaria'",
        reduce_layers = TRUE )

    expect_equal(or_filter_sf$country %>% unique(), c("Bulgaria", "Baltic Sea"))
})


test_that("numeric filters work -- biology", {
    skip_if_offline()
    wfs <- create_biology_wfs()
    with_mock_dir("mediseh_posidonia_nodata", {
        num_filter_sf <- emodnet_get_layers(
            wfs = wfs, layers = "mediseh_posidonia_nodata",
            cql_filter = "km>400",
            reduce_layers = TRUE
        )
    })
    expect_true(min(num_filter_sf$km) > 400)
})

test_that("numeric filters work -- geology_seabed_substrate_maps", {
    wfs <- create_geology_seabed_substrate_maps_wfs()

    num_filter_sf <- emodnet_get_layers(wfs = wfs, layers = "seabed_substrate_1m",
        cql_filter = "country='Bulgaria' AND shape_length>1",
        reduce_layers = TRUE )

    expect_equal(num_filter_sf$country %>% unique(), c("Bulgaria"))
    expect_true(min(num_filter_sf$shape_length) > 1)


    num_filter_sf <- emodnet_get_layers(wfs = wfs, layers = "seabed_substrate_1m",
        cql_filter = "(country='Baltic Sea' OR country='Bulgaria') AND shape_length<1",
        reduce_layers = TRUE )

    expect_equal(num_filter_sf$country %>% unique(), c("Bulgaria", "Baltic Sea"))
    expect_true(min(num_filter_sf$shape_length) < 1)

})
