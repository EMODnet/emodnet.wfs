.emodnet_wfs <- function() {
  data <- utils::read.csv(
    system.file("services.csv", package = "emodnet.wfs"),
    stringsAsFactors = FALSE
  )
  tibble::as_tibble(data)
}
#' @description Available EMODnet Web Feature Services
#'
#' @title Which data sources (services) are available?
#'
#' @return Tibble of available EMODnet Web Feature Services
#'
#' @examplesIf identical(Sys.getenv("IN_PKGDOWN"), "true") || interactive()
#' emodnet_wfs()
#' @export
emodnet_wfs <- memoise::memoise(.emodnet_wfs)
