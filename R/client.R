
#' Initialise an EMODnet Seabed Habitats WFS client
#'
#' @param service the EMODnet OGC WFS service URL. Defaults to the EMODnet Seabed
#' Habitats WFS.
#' @param service_version the WFS service version. Defaults to "2.0.0".
#'
#' @return A `WFSClient` R6 object with methods for interfacing an OGC Web Feature Service.
#' @export
#'
#' @seealso `WFSClient` in package `ows4R`.
#' @examples
#' wfs <- emodnet_init_wfs_client()
emodnet_init_wfs_client <- function(service = "https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs",
                                    service_version = "2.0.0") {
    wfs <- ows4R::WFSClient$new(service,
                         serviceVersion = service_version)

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
