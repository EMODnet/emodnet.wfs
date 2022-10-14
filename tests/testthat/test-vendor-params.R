test_that("vendor param count works", {
  skip_if_offline()
  wfs <- create_biology_wfs()
  l_data <- emodnet_get_layers(
    wfs = wfs,
    layers = "mediseh_zostera_m_pnt",
    count = 1L, reduce_layers = TRUE
  )

  expect_identical(nrow(l_data), 1L)
})
