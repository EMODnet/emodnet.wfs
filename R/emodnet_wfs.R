.emodnet_wfs <- function() {
    table <- readr::read_csv(
        system.file("services.csv", package = "EMODnetWFS"),
        col_types = readr::cols(
            service_name = readr::col_character(),
            service_url = readr::col_character()
        )
    )
    table$ok_on_linux <- !grepl("^geology_", table$service_name)
    table
}
#' Available EMODnet Web Feature Services
#'
#' @return Tibble of available EMODnet Web Feature Services
#'
#' @export
emodnet_wfs <- memoise::memoise(.emodnet_wfs)

