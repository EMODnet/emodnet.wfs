.emodnet_wfs <- function() {
	utils::read.csv(
		system.file("services.csv", package = "EMODnetWFS"),
		stringsAsFactors = FALSE
	)
}
#' Available EMODnet Web Feature Services
#'
#' @return Tibble of available EMODnet Web Feature Services
#'
#' @examples
#' emodnet_wfs()
#' @export
emodnet_wfs <- memoise::memoise(.emodnet_wfs)
