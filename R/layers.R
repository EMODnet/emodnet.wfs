
#' Get EMODnet WFS layers
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @param layers a character vector of layer names. To get info on layers, including
#' `layer_name` use `emodnet_get_wfs_info()`
#' @param reduce_layers whether to reduce output layers to a single `sf` object.
#'
#' @return either a single `sf` containing all layers (default) or a list of `sf`
#' objects, one for each layer (if `reduce_layers = TRUE`)
#' @export
#'
#' @examples
#' emodnet_get_layers(layers = c("dk003069", "dk003070"))
#' emodnet_get_layers(layers = c("dk003069", "dk003070"), reduce_layers = TRUE)
emodnet_get_layers <- function(wfs = NULL,
                               service = "https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs",
                               service_version = "2.0.0", layers, reduce_layers = FALSE) {
    if(is.null(wfs)){
        wfs <- emodnet_init_wfs_client(service, service_version)
    }else{check_wfs(wfs)}

    # check layers
    layer <- match.arg(layers, several.ok = TRUE,
                       choices = emodnet_get_wfs_info(wfs)$layer_name)


    # get features
    out <- purrr::map(layers, ~ews_get_layer(.x, wfs), wfs)

    # if reduce_layers = T, reduce to single sf
    if(reduce_layers){purrr::reduce(out, rbind)}else{out}
}

ews_get_layer <- function(x, wfs){
    try(wfs$getFeatures(x))
}
