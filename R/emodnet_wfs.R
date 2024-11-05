.emodnet_wfs <- function() {
  utils::read.csv(
    system.file("services.csv", package = "emodnet.wfs"),
    stringsAsFactors = FALSE
  )
}
#' Available EMODnet Web Feature Services
#'
#' Which data sources (services) are available?
#'
#' @return Tibble of available EMODnet Web Feature Services
#'
#' @examplesIf interactive()
#' emodnet_wfs()
#' @export
emodnet_wfs <- memoise::memoise(.emodnet_wfs)
