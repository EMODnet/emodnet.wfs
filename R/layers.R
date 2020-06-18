#' Get EMODnet WFS layers
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @param layers a character vector of layer names. To get info on layers, including
#' `layer_name` use `emodnet_get_wfs_info()`
#' @param crs integer. An EPSG code for the outpur crs. Defaults to 4326, corresponsing to `"+proj=longlat +datum=WGS84 +no_defs"`
#' @param reduce_layers whether to reduce output layers to a single `sf` object.
#' @param suppress_warnings logical. Whether to suppress messages of layer
#' download failures.
#' @return If `reduce_layers = FALSE` (default), a list of `sf`
#' objects, one element for each layer. Any layers for which download was
#' unsuccessful will be NULL. If `reduce_layers = TRUE`, all layers are
#' reduced (if possible) to a single `sf` containing data for all layers.
#' `NULL` layers are ignored.
#' @export
#'
#' @examples
#' emodnet_get_layers(layers = c("dk003069", "dk003070"))
#' emodnet_get_layers(layers = c("dk003069", "dk003070"), reduce_layers = TRUE)
emodnet_get_layers <- function(wfs = NULL,
                               service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                               service_version = "2.0.0", layers, crs = 4326,
                               reduce_layers = FALSE, suppress_warnings = FALSE) {
    checkmate::assert_int(crs)

    if(is.null(wfs)){
        wfs <- emodnet_init_wfs_client(service,
                                       service_version)
    }else{check_wfs(wfs)}

    # check layers
    layer <- match.arg(layers, several.ok = TRUE,
                       choices = emodnet_get_wfs_info(wfs)$layer_name)

        # get features
    out <- purrr::map(layers, ~ews_get_layer(.x, wfs), wfs,
                      suppress_warnings) %>%
         stats::setNames(layers)

    # if reduce_layers = T, reduce to single sf
    if(reduce_layers){
        tryCatch(
            out <- purrr::reduce(out, rbind),
            error = function(e) {
                usethis::ui_stop("Cannot reduce layers.
                             Try again with {usethis::ui_code('reduce_layers = FALSE')}")
            }
        )
    }
    standardise_crs(out, crs)
}

checkmate_crs <- function(sf, crs = 4326){
    if(checkmate::test_null(sf)){
        return(sf)
    }
    if(is.na(sf::st_crs(sf)) | is.null(sf::st_crs(sf))){
        sf::st_crs(sf) <- crs
        usethis::ui_warn("{usethis::ui_field('crs')} missing. Set to default {usethis::ui_value(crs)}")
    }
    sf_crs <- sf::st_crs(sf)$epsg
    if(sf_crs != crs){
        sf <- sf::st_transform(sf, crs)
        usethis::ui_info("{usethis::ui_field('crs')} transformed from {usethis::ui_value(sf_crs)} to {usethis::ui_value(crs)}")
    }
    return(sf)
}


standardise_crs <- function(out, crs = 4326) {

    if(checkmate::test_class(out, "list")){
       purrr::map(out, ~checkmate_crs(.x, crs = crs))
    }else{
        checkmate_crs(out, crs = crs)
    }
}

ews_get_layer <- function(x, wfs, suppress_warnings = FALSE){
    layer <- NULL
    tryCatch(
       layer <- wfs$getFeatures(x),
        error = function(e) {
            usethis::ui_warn("Download of layer {usethis::ui_value(x)} failed: {usethis::ui_field(e)}")}
    )
    return(layer)
}
