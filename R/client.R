
#' Initialise an EMODnet Seabed Habitats WFS client
#'
#' @param service the EMODnet OGC WFS service name. Defaults to the EMODnet Seabed
#' Habitats WFS `"seabed_habitats_individual_habitat_map_and_model_datasets"`. For
#' available services, see `emodnet_wfs`.
#' @param service_version the WFS service version. Defaults to "2.0.0".
#'
#' @return A `WFSClient` R6 object with methods for interfacing an OGC Web Feature Service.
#' @export
#'
#' @seealso `WFSClient` in package `ows4R`.
#' @examples
#' wfs <- emodnet_init_wfs_client()
emodnet_init_wfs_client <- function(service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                                    service_version = "2.0.0") {


    wfs <- suppressWarnings(ows4R::WFSClient$new(get_service_url(service),
                         serviceVersion = service_version))

    check_wfs(wfs)
    usethis::ui_done("WFS client created succesfully")
    usethis::ui_info("Service: {usethis::ui_value(wfs$getUrl())}")
    usethis::ui_info("Version: {usethis::ui_value(wfs$getVersion())}")

    wfs
}

check_wfs <- function(wfs) {
    checkmate::assertR6(wfs, classes = c("WFSClient",
                                         "OWSClient",
                                         "OGCAbstractObject",
                                         "R6"))
}

get_service_url <- function(service) {
    service <- match.arg(service,
                         choices = EMODnetWFS::emodnet_wfs$service_name)

    EMODnetWFS::emodnet_wfs$service_url[EMODnetWFS::emodnet_wfs$service_name == service]
}

get_service_name <- function(service_url) {
    service_url <- match.arg(service_url,
                         choices = EMODnetWFS::emodnet_wfs$service_url)

    EMODnetWFS::emodnet_wfs$service_name[EMODnetWFS::emodnet_wfs$service_url == service_url]
}

