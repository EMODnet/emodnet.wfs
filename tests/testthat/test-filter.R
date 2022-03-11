
test_that("categorical filters work", {
    skip_on_os("linux")
    wfs <- emodnet_init_wfs_client(service = "geology_seabed_substrate_maps")

    expect_equal(emodnet_get_layers(wfs = wfs,
        layers = "seabed_substrate_1m",
        cql_filter = "country='Baltic Sea'",
        reduce_layers = TRUE)$country %>% unique(), 'Baltic Sea')


    or_filter_sf <- emodnet_get_layers(wfs = wfs, layers = "seabed_substrate_1m",
        cql_filter = "country='Baltic Sea' OR country='Bulgaria'",
        reduce_layers = TRUE )

    expect_equal(or_filter_sf$country %>% unique(), c("Bulgaria", "Baltic Sea"))

})


test_that("numeric filters work", {
    skip_on_os("linux")
    wfs <- emodnet_init_wfs_client(service = "geology_seabed_substrate_maps")

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



