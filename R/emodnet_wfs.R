.emodnet_wfs <- function() {
  data <- utils::read.csv(
    system.file("services.csv", package = "emodnet.wfs"),
    stringsAsFactors = FALSE
  )
  tibble::as_tibble(data)
}
#' Available EMODnet Web Feature Services
#'
#' @return Tibble of available EMODnet Web Feature Services
#'
#' @examples
#' emodnet_wfs()
#' @export
emodnet_wfs <- memoise::memoise(.emodnet_wfs)
