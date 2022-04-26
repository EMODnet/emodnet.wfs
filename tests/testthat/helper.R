library(httptest)

with_mock_dir <- function(name, ...) {
    httptest::with_mock_dir(file.path("../fixtures", name), ...)
}

create_biology_wfs <- function() {
    with_mock_dir("wfs-biology", {
        emodnet_init_wfs_client(service = "biology")
    })
}
