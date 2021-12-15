
#' Initialise an EMODnet Seabed Habitats WFS client
#'
#' @param service the EMODnet OGC WFS service name. For
#' available services, see `emodnet_wfs`.
#' @param service_version the WFS service version. Defaults to "2.0.0".
#'
#' @return A `WFSClient` R6 object with methods for interfacing an OGC Web Feature Service.
#' @export
#'
#' @seealso `WFSClient` in package `ows4R`.
#' @examples
#' wfs <- emodnet_init_wfs_client(
#'        service = "seabed_habitats_individual_habitat_map_and_model_datasets")
emodnet_init_wfs_client <- function(service, service_version = "2.0.0") {

    service <- match.arg(service, choices = EMODnetWFS::emodnet_wfs$service_name)

    tryCatch(
        wfs <- suppressWarnings(ows4R::WFSClient$new(get_service_url(service),
                                                     serviceVersion = service_version)),
        error = function(e){
            resource <- subset(emodnet_wfs$service_monitor, emodnet_wfs$service_name == service)
            check_service(resource = resource)
        }

    )

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


check_service <- function(host = "monitor.emodnet.eu", resource){
    usethis::ui_info("Checking WFS service status:")

    # Is there internet connection?
    if(curl::has_internet()){
        usethis::ui_done("Internet connection available.")

        # Is the tool up?
        if(!is.null(curl::nslookup(host, error = FALSE))){
            msg <- paste("Monitor tool at", host, "is available")
            usethis::ui_done(msg)

            # Is the service working?
            service_url <- paste0("https://", host)
            service_json <- paste0(service_url, "/resource/", as.character(resource), "/json")
            service_response <- jsonlite::fromJSON(service_json)

            msg <- paste0(service_response$title, ". Last run: ", service_response$last_run, ".")

            if(service_response$status){
                msg <- paste("Service available:", msg)
                usethis::ui_done(msg)
                # out <- TRUE
            }else if(!service_response$status){
                msg <- paste("Service currently not available:", msg)
                usethis::ui_oops(msg)
            }else{stop()}


        }else{
            msg <- paste("Monitor tool at", host, "is currently not available.")
            usethis::ui_oops(msg)
        }

    }else{
        usethis::ui_oops("Internet connection not available.")
    }

    # Logical to indicate if service is currently available
    # if(!exists("out")){
    #     out <- FALSE
    # }
    #
    # return(out)

}

