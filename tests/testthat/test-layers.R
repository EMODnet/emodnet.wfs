test_that("get layers works on server", {
    skip_if_offline()
    with_mock_dir("layers-biology", {
        l_data <- emodnet_get_layers(
            service = "biology",
            layers = c("mediseh_zostera_m_pnt", "mediseh_posidonia_nodata"))
        l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()
    })

    expect_length(l_crs, 1)
    expect_equal(l_crs, 4326)
    expect_type(l_data, "list")
    expect_length(l_data, 2)
    expect_s3_class(l_data[[1]], class = c("sf", "data.frame"))
    expect_s3_class(l_data[[2]], class = c("sf", "data.frame"))
    expect_gt(nrow(l_data[[1]]), 0)
    expect_gt(nrow(l_data[[2]]), 0)

})

test_that("crs transform works from server", {
    skip_if_offline()
    with_mock_dir("layers-biology2", {
        l_data <- emodnet_get_layers(
            service = "biology",
            layers = "mediseh_zostera_m_pnt",
            crs = 4326
        )
        l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()
    })
    expect_length(l_crs, 1)
    expect_equal(l_crs, 4326)
})

test_that("get layers works on wfs object", {
    skip_if_offline()
    with_mock_dir("layers-biology3", {
        wfs_cml <- emodnet_init_wfs_client("biology")
        layers <- c("mediseh_zostera_m_pnt", "mediseh_posidonia_nodata")
        l_data <- emodnet_get_layers(wfs = wfs_cml, layers = layers)
        l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()
    })
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
    skip_if_offline()
    with_mock_dir("layers-biology4", {
        wfs_cml <- emodnet_init_wfs_client("biology")
        layers <- c("mediseh_zostera_m_pnt", "mediseh_posidonia_nodata")
        l_data <- emodnet_get_layers(wfs = wfs_cml, layers = layers, crs = 3857)
        l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()
    })
    expect_length(l_crs, 1)
    expect_equal(l_crs, 3857)
})

test_that("crs checking from wfs service works correctly", {
    skip_if_offline()
    with_mock_dir("layers-biology5", {
        l_data <- emodnet_get_layers(
            service = "biology",
            layers = "mediseh_zostera_m_pnt",
            cql_filter = "country='Grecia'"
        )
    })

    expect_equal(sf::st_crs(l_data[[1]])$input, "epsg:4326")
})


test_that("reduce layers on single layer returns sf", {
    skip_if_offline()
    with_mock_dir("layers-biology5", {
        sf_data <- emodnet_get_layers(
            service = "biology",
            layers = "mediseh_zostera_m_pnt",
            cql_filter = "country='Grecia'",
            reduce_layers = TRUE
        )
    })

    expect_s3_class(sf_data, c("sf", "data.frame"))
})

test_that("emodnet_get_layers errors well when no service nor wfs", {
    expect_snapshot_error(emodnet_get_layers(layers = c("randomlayer")))
})

test_that("emodnet_get_layers errors well when bad wfs", {
    expect_snapshot_error(emodnet_get_layers(wfs = "a service"))
})

test_that("emodnet_get_layers errors well when bad layer", {
    with_mock_dir("layers-biology-error", {
        expect_snapshot_error(emodnet_get_layers(service = "biology", layers = "blop"))
    })
})

test_that("reduce works", {
    skip_if_offline()
    with_mock_dir("reduce", {
        sf_data <- emodnet_get_layers(
            service = "seabed_habitats_individual_habitat_map_and_model_datasets",
            layers = c("dk003069", "dk003070"),
            reduce_layers = TRUE)
    })
    expect_s3_class(sf_data, class = c("sf", "data.frame"))
    expect_gt(nrow(sf_data), 0)
})

#test_that("Failing layers handled correctly", {
#        expect_warning(emodnet_get_layers(layers = "be000071"))
#    expect_null(suppressWarnings(emodnet_get_layers(
#        layers = "be000071"))[[1]])
#})



