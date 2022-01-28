with_mock_dir("get_layers_direct", {
  test_that("get layers works on server", {
    l_data <- emodnet_get_layers(service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                                 layers = c("dk003069", "dk003070"))
    l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()

    expect_length(l_crs, 1)
    expect_equal(3857, l_crs)
    expect_equal(length(l_data), 2)
    expect_type(l_data, "list")
    expect_s3_class(l_data[[1]], class = c("sf", "data.frame"))
    expect_s3_class(l_data[[2]], class = c("sf", "data.frame"))
    expect_gt(nrow(l_data[[1]]), 0)
    expect_gt(nrow(l_data[[2]]), 0)

  })
})
with_mock_dir("crs_trasform_direct", {
  test_that("crs trasform works from server", {
    l_data <- emodnet_get_layers(service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                                 layers = "dk003070", crs = 4326)
    l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()
    expect_length(l_crs, 1)
    expect_equal(4326, l_crs)
  })
})

with_mock_dir("get_layers_wfs", {
  test_that("get layers works on wfs object", {
    wfs_cml <- emodnet_init_wfs_client("chemistry_marine_litter")
    layers <- c("sl_fishing", "sl_plasticbags")

    l_data <- emodnet_get_layers(wfs = wfs_cml, layers = layers)
    l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()

    expect_length(l_crs, 1)
    expect_equal(4326, l_crs)
    expect_equal(length(l_data), 2)
    expect_type(l_data, "list")
    expect_s3_class(l_data[[1]], class = c("sf", "data.frame"))
    expect_s3_class(l_data[[2]], class = c("sf", "data.frame"))
    expect_gt(nrow(l_data[[1]]), 0)
    expect_gt(nrow(l_data[[2]]), 0)
  })
})
with_mock_dir("crs_trasform_wfs", {
  test_that("crs trasform works from wfs object", {
    wfs_cml <- emodnet_init_wfs_client("chemistry_marine_litter")
    layers <- c("sl_fishing", "sl_plasticbags")

    l_data <- emodnet_get_layers(wfs = wfs_cml, layers = layers, crs = 3857)
    l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()
    expect_length(l_crs, 1)
    expect_equal(3857, l_crs)
  })
})
with_mock_dir("get_layer_correct_crs", {
  test_that("crs checking from wfs service works correctly", {
    l_data <- emodnet_get_layers(service="geology_seabed_substrate_maps",
                                 layers = "seabed_substrate_1m",
                                 cql_filter = "country='Baltic Sea'")

    expect_equal(sf::st_crs(l_data[[1]])$input, "+init=epsg:3034")
  })
})

with_mock_dir("random_layer_fail", {
  test_that("random layers fail", {
    expect_error(emodnet_get_layers(layers = c("randomlayer")))
  })
})
with_mock_dir("reduce", {
  test_that("reduce works", {
    sf_data <- emodnet_get_layers(
      service = "seabed_habitats_individual_habitat_map_and_model_datasets",
      layers = c("dk003069", "dk003070"),
      reduce_layers = TRUE)
    expect_s3_class(sf_data, class = c("sf", "data.frame"))
    expect_gt(nrow(sf_data), 0)
  })
})

with_mock_dir("reduce_single_layer", {
  test_that("reduce layers on single layer returns sf", {
    sf_data <- emodnet_get_layers(service="geology_seabed_substrate_maps",
                                  layers = "seabed_substrate_1m",
                                  cql_filter = "country='Baltic Sea'",
                                  reduce_layers = TRUE)

    expect_s3_class(sf_data, c("sf", "data.frame"))
  })
})

