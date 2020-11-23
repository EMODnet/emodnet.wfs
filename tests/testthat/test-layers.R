test_that("get layers works on server", {
  l_data <- emodnet_get_layers(layers = c("dk003069", "dk003070"))
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

test_that("crs trasform works from server", {
  l_data <- emodnet_get_layers(layers = "dk003070", crs = 3857)
  l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()
  expect_length(l_crs, 1)
  expect_equal(3857, l_crs)
})



wfs_cml <- emodnet_init_wfs_client("chemistry_marine_litter")
layers <- c("bl_fishing_cleaning",
            "bl_beacheslocations_2001_2008_monitoring")

test_that("get layers works on wfs object", {
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

test_that("crs trasform works from wfs object", {
  l_data <- emodnet_get_layers(wfs = wfs_cml, layers = layers, crs = 3857)
  l_crs <- purrr::map_int(l_data, ~sf::st_crs(.x)$epsg) %>% unique()
  expect_length(l_crs, 1)
  expect_equal(3857, l_crs)
})


test_that("random layers fail", {
  expect_error(emodnet_get_layers(layers = c("randomlayer")))
})

test_that("reduce works", {
    sf_data <- emodnet_get_layers(
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



