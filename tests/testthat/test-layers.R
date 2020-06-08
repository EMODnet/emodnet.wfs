test_that("layers download", {
    l_data <- emodnet_get_layers(layers = c("dk003069", "dk003070"))
  expect_equal(length(l_data), 2)
  expect_type(l_data, "list")
  expect_s3_class(l_data[[1]], class = c("sf", "data.frame"))
  expect_s3_class(l_data[[2]], class = c("sf", "data.frame"))
  expect_gt(nrow(l_data[[1]]), 0)
  expect_gt(nrow(l_data[[2]]), 0)
})

test_that("layers download", {
    sf_data <- emodnet_get_layers(
        layers = c("dk003069", "dk003070"),
        reduce_layers = TRUE)
    expect_s3_class(sf_data, class = c("sf", "data.frame"))
    expect_gt(nrow(sf_data), 0)
})

test_that("Failing layers handled correctly", {
        expect_warning(emodnet_get_layers(layers = "be000071"))
    expect_null(suppressWarnings(emodnet_get_layers(
        layers = "be000071"))[[1]])
})


