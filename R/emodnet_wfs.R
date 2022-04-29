.emodnet_wfs <- function() {
    readr::read_csv(
        system.file("services.csv", package = "EMODnetWFS"),
        col_types = readr::cols(
            service_name = readr::col_character(),
            service_url = readr::col_character()
        )
    )
}
#' Available EMODnet Web Feature Services
#'
#' @return Tibble of available EMODnet Web Feature Services
#'
#' @examples
#' emodnet_wfs()
#'
#' @export
emodnet_wfs <- memoise::memoise(.emodnet_wfs)

