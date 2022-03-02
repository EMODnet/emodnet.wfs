with_mock_dir <- function(name, ...) {
    httptest::with_mock_dir(file.path("fixtures", name), ...)
}
