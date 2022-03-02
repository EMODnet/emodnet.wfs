test_that("get layers works on server", {
    skip_on_cran()
    l_data <- emodnet_get_layers(
        service = "seabed_habitats_individual_habitat_map_and_model_datasets",
        layers = c("dk003069", "dk003070"))
    l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()

    expect_length(l_crs, 1)
    expect_equal(l_crs, 3857)
    expect_type(l_data, "list")
    expect_length(l_data, 2)
    expect_s3_class(l_data[[1]], class = c("sf", "data.frame"))
    expect_s3_class(l_data[[2]], class = c("sf", "data.frame"))
    expect_gt(nrow(l_data[[1]]), 0)
    expect_gt(nrow(l_data[[2]]), 0)

})

test_that("crs transform works from server", {
    skip_on_cran()
    l_data <- emodnet_get_layers(
        service = "seabed_habitats_individual_habitat_map_and_model_datasets",
        layers = "dk003070",
        crs = 4326
    )
    l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()
    expect_length(l_crs, 1)
    expect_equal(l_crs, 4326)
})

test_that("get layers works on wfs object", {
    skip_on_cran()
    wfs_cml <- emodnet_init_wfs_client("chemistry_marine_litter")
    layers <- c("sl_fishing", "sl_plasticbags")
    l_data <- emodnet_get_layers(wfs = wfs_cml, layers = layers)
    l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()

    expect_length(l_crs, 1)
    expect_equal(l_crs, 4326)
    expect_type(l_data, "list")
    expect_length(l_data, 2)
    expect_s3_class(l_data[[1]], class = c("sf", "data.frame"))
    expect_s3_class(l_data[[2]], class = c("sf", "data.frame"))
    expect_gt(nrow(l_data[[1]]), 0)
    expect_gt(nrow(l_data[[2]]), 0)
})

test_that("crs transform works from wfs object", {
    skip_on_cran()
    wfs_cml <- emodnet_init_wfs_client("chemistry_marine_litter")
    layers <- c("sl_fishing", "sl_plasticbags")
    l_data <- emodnet_get_layers(wfs = wfs_cml, layers = layers, crs = 3857)
    l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()
    expect_length(l_crs, 1)
    expect_equal(l_crs, 3857)
})

test_that("crs checking from wfs service works correctly", {
    skip_on_cran()
    l_data <- emodnet_get_layers(
        service = "chemistry_marine_litter",
        layers = "sl_fishing",
        cql_filter = "country='Baltic Sea'"
    )

    expect_equal(sf::st_crs(l_data[[1]])$input, "WGS 84")
})


test_that("reduce layers on single layer returns sf", {
    skip_on_cran()
    sf_data <- emodnet_get_layers(
        service = "chemistry_marine_litter",
        layers = "sl_fishing",
        cql_filter = "country='Baltic Sea'",
        reduce_layers = TRUE
    )

    expect_s3_class(sf_data, c("sf", "data.frame"))
})

test_that("emodnet_get_layers errors well when no service nor wfs", {
    expect_snapshot_error(emodnet_get_layers(layers = c("randomlayer")))
})

test_that("emodnet_get_layers errors well when bad wfs", {
    expect_snapshot_error(emodnet_get_layers(wfs = "a service"))
})

test_that("emodnet_get_layers errors well when bad layer", {
    expect_snapshot_error(emodnet_get_layers(service = "human_activities", layers = "blop"))
})

test_that("reduce works", {
    skip_on_cran()
    sf_data <- emodnet_get_layers(
        service = "seabed_habitats_individual_habitat_map_and_model_datasets",
        layers = c("dk003069", "dk003070"),
        reduce_layers = TRUE)
    expect_s3_class(sf_data, class = c("sf", "data.frame"))
    expect_gt(nrow(sf_data), 0)
})

#test_that("Failing layers handled correctly", {
#        expect_warning(emodnet_get_layers(layers = "be000071"))
#    expect_null(suppressWarnings(emodnet_get_layers(
#        layers = "be000071"))[[1]])
#})



