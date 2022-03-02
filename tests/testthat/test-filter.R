
test_that("categorical filters work", {
    wfs <- emodnet_init_wfs_client(service = "chemistry_marine_litter")

    simple_filter_sf <- emodnet_get_layers(
        wfs = wfs,
        layers = "sl_fishing",
        cql_filter = "country='Baltic Sea'",
        reduce_layers = TRUE
    )
    expect_equal(unique(simple_filter_sf$country), 'Baltic Sea')

    or_filter_sf <- emodnet_get_layers(
        wfs = wfs,
        layers = "sl_fishing",
        cql_filter = "country='Baltic Sea' OR country='Bulgaria'",
        reduce_layers = TRUE
    )
    expect_equal(unique(or_filter_sf$country), c("Bulgaria", "Baltic Sea"))
})


test_that("numeric filters work", {
    wfs <- emodnet_init_wfs_client(service = "chemistry_marine_litter")

    num_filter_sf <- emodnet_get_layers(
        wfs = wfs, layers = "sl_fishing",
        cql_filter = "country='Bulgaria' AND shape_length>1",
        reduce_layers = TRUE
    )
    expect_equal(unique(num_filter_sf$country), c("Bulgaria"))
    expect_true(min(num_filter_sf$shape_length) > 1)


    num_filter_sf <- emodnet_get_layers(
        wfs = wfs,
        layers = "sl_fishing",
        cql_filter = "(country='Baltic Sea' OR country='Bulgaria') AND shape_length<1",
        reduce_layers = TRUE
    )
    expect_equal(unique(num_filter_sf$country), c("Bulgaria", "Baltic Sea"))
    expect_true(min(num_filter_sf$shape_length) < 1)
})
