test_that("get layers works on server", {
  skip_if_offline()
  wfs <- create_biology_wfs()
  l_data <- emodnet_get_layers(
    wfs = wfs,
    layers = c("mediseh_zostera_m_pnt", "mediseh_posidonia_nodata")
  )
  expect_type(l_data, "list")
  expect_length(l_data, 2L)
  expect_s3_class(l_data[[1]], class = c("sf", "data.frame"))
  expect_s3_class(l_data[[2]], class = c("sf", "data.frame"))
  expect_gt(nrow(l_data[[1]]), 0L)
  expect_gt(nrow(l_data[[2]]), 0L)

  l_crs <- purrr::map_int(l_data, ~ sf::st_crs(.x)$epsg) %>% unique()
  expect_length(l_crs, 1L)
  expect_identical(l_crs, 4326L)
})

test_that("crs transform works from server", {
  skip_if_offline()
  wfs <- create_biology_wfs()
  l_data <- emodnet_get_layers(
    wfs = wfs,
    layers = "mediseh_zostera_m_pnt",
    crs = 4326
  )
  l_crs <- purrr::map_int(l_data, ~ sf::st_crs(.x)$epsg) %>% unique()

  expect_length(l_crs, 1L)
  expect_identical(l_crs, 4326L)
})

test_that("get layers works on wfs object", {
  skip_if_offline()
  wfs <- create_biology_wfs()
  layers <- c("mediseh_zostera_m_pnt", "mediseh_posidonia_nodata")
  l_data <- emodnet_get_layers(wfs = wfs, layers = layers)
  expect_type(l_data, "list")
  expect_length(l_data, 2L)
  expect_s3_class(l_data[[1]], class = c("sf", "data.frame"))
  expect_s3_class(l_data[[2]], class = c("sf", "data.frame"))
  expect_gt(nrow(l_data[[1]]), 0L)
  expect_gt(nrow(l_data[[2]]), 0L)

  l_crs <- purrr::map_int(l_data, ~ sf::st_crs(.x)$epsg) %>% unique()

  expect_length(l_crs, 1L)
  expect_identical(l_crs, 4326L)
})

test_that("crs transform works from wfs object", {
  skip_if_offline()
  wfs <- create_biology_wfs()
  layers <- c("mediseh_zostera_m_pnt", "mediseh_posidonia_nodata")
  l_data <- emodnet_get_layers(wfs = wfs, layers = layers, crs = 3857)
  l_crs <- purrr::map_int(l_data, ~ sf::st_crs(.x)$epsg) %>% unique()

  expect_length(l_crs, 1L)
  expect_identical(l_crs, 3857L)
})

test_that("crs checking from wfs service works correctly", {
  skip_if_offline()
  wfs <- create_biology_wfs()
  l_data <- emodnet_get_layers(
    wfs = wfs,
    layers = "mediseh_zostera_m_pnt",
    cql_filter = "country='Grecia'"
  )

  expect_identical(sf::st_crs(l_data[[1]])$input, "epsg:4326")
})

test_that("simplify layers on single layer returns sf", {
  skip_if_offline()
  wfs <- create_biology_wfs()
  sf_data <- emodnet_get_layers(
    wfs = wfs,
    layers = "mediseh_zostera_m_pnt",
    cql_filter = "country='Grecia'",
    simplify = TRUE
  )
  expect_s3_class(sf_data, c("sf", "data.frame"))
})

test_that("emodnet_get_layers errors well when no service nor wfs", {
  expect_snapshot_error(emodnet_get_layers(layers = "randomlayer"))
})

test_that("emodnet_get_layers errors well when bad wfs", {
  expect_snapshot_error(emodnet_get_layers(wfs = "a service"))
})

test_that("emodnet_get_layers errors well when bad layer", {
  skip_if_offline()
  wfs <- create_biology_wfs()
  expect_snapshot_error(emodnet_get_layers(wfs = wfs, layers = "blop"))
})

test_that("simplify works", {
  skip_if_offline()
  skip("TODO very slow right now")
  sf_data <- emodnet_get_layers(
    service = "seabed_habitats_individual_habitat_map_and_model_datasets",
    layers = c("dk003069", "dk003070"),
    simplify = TRUE
  )

  expect_s3_class(sf_data, class = c("sf", "data.frame"))
  expect_gt(nrow(sf_data), 0L)
})

test_that("works when data.frame layer", {
  skip_if_offline()
  wfs <- create_biology_wfs()
  expect_snapshot_error(
    emodnet_get_layers(
      wfs,
      layers = c("OOPS_summaries", "OOPS_metadata"),
      simplify = TRUE
    )
  )
  result_list <- emodnet_get_layers(
    wfs,
    layers = c("OOPS_summaries", "OOPS_metadata")
  )
  expect_type(result_list, "list")
  expect_s3_class(result_list[[1]], "data.frame")
  expect_s3_class(result_list[[2]], "data.frame")
})
