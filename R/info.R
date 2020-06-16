#' Get WFS available layer information
#'
#' @param wfs A `WFSClient` R6 object with methods for interfacing an OGC Web Feature Service.
#' @inheritParams emodnet_init_wfs_client
#' @importFrom rlang .data
#' @return a tibble summarising information on each layer available from the service
#' @export
#'
#' @examples
#' emodnet_get_wfs_info()
#'
emodnet_get_wfs_info <- function(wfs = NULL,
                                 service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                                 service_version = "2.0.0") {
    if(is.null(wfs)){
        wfs <- emodnet_init_wfs_client(service, service_version)
    }else{check_wfs(wfs)}

    caps <- wfs$getCapabilities()

    tibble::tibble(
        layer_name = purrr::map_chr(caps$getFeatureTypes(), ~.x$getName()),
        title = purrr::map_chr(caps$getFeatureTypes(), ~.x$getTitle()),
        abstract = purrr::map_chr(caps$getFeatureTypes(), ~getAbstractNull(.x)),
        class = purrr::map_chr(caps$getFeatureTypes(), ~.x$getClassName())
    ) %>%
        tidyr::separate(.data$layer_name, into = c("layer_namespace", "layer_name"),
                        sep = ":")

}

getAbstractNull <- function(x){
    abstract <- x$getAbstract()
    ifelse(is.null(abstract), "", abstract)
}

