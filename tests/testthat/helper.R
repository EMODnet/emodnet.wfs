library(httptest)

forget_all <- function() {
  memoise::forget(emodnet_wfs)
  memoise::forget(emodnet_get_layer_info)
  memoise::forget(emodnet_get_wfs_info)
}

with_mock_dir <- function(name, ...) {
  httptest::with_mock_dir(file.path("../fixtures", name), ...)
}

create_biology_wfs <- function() {
  with_mock_dir("wfs-biology", {
    emodnet_init_wfs_client(service = "biology")
  })
}
