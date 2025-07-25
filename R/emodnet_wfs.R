.emodnet_wfs <- function() {
  emodnet_data <- utils::read.csv(
    system.file("services.csv", package = "emodnet.wfs"),
    stringsAsFactors = FALSE
  )
  tibble::as_tibble(emodnet_data)
}
#' @description Available EMODnet Web Feature Services
#'
#' @title Which data sources (services) are available?
#'
#' @format ## `emodnet_wfs`
#' \describe{
#'   \item{emodnet_thematic_lot}{EMODnet disciplinary themes - bathymetry,
#'   biology, chemistry, geology, human activities, physics and seabed habitats}
#'   \item{service_name}{Name of the specific service.
#'   Use in [emodnet_init_wfs_client].}
#'   \item{service_url}{
#'   [Web Feature Service (WFS)](https://www.ogc.org/standards/wfs/)
#'    URL endpoint for accessing the service.}
#' }
#'
#' @return Tibble of available EMODnet Web Feature Services
#'
#' @examplesIf should_run_example()
#' emodnet_wfs()
#' @export
emodnet_wfs <- memoise::memoise(.emodnet_wfs)
