#' Get EMODnet WFS layers
#'
#' Performs an WFS getFeature request for layers from a `wfs` object or specified EMODnet Service. Filtering
#' of layer features can also be handled via ECQL language filters.
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @param layers a character vector of layer names. To get info on layers, including
#' `layer_name` use [emodnet_get_wfs_info()].
#' @param crs integer. An EPSG code for the output crs. Defaults to 4326, corresponding to `"+proj=longlat +datum=WGS84 +no_defs"`,
#' @param cql_filter character. Features returned can be filtered using valid Extended Common Query Language (ECQL)
#' filtering statements (<https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html>). Should be one of:
#'  \itemize{
#'   \item{character string or character vector of length 1. Filter will be recycled across all layers requested}
#'   \item{character vector of length equal to the length of layers. Filter will be matched to layers sequentially.
#'   Elements containing `NA` are ignored}
#'   \item{named character vector. Each filter will be applied to the layer corresponding to the filter name.
#'   Filters with names that do not correspond to any layers are ignored. Layers without corresponding filters are returned whole }
#' }
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
#' emodnet_get_layers(service = "human_activities", layers = "maritimebnds",
#'     cql_filter = "sitename='Territory sea (12 nm)'" )
emodnet_get_layers <- function(wfs = NULL,
                               service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                               service_version = "2.0.0", layers, crs = 4326,
                               cql_filter = NULL, reduce_layers = FALSE,
                               suppress_warnings = FALSE) {
    checkmate::assert_int(crs)

    if(is.null(wfs)){
        wfs <- emodnet_init_wfs_client(service,
                                       service_version)
    }else{check_wfs(wfs)}

    # check layers
    layers <- match.arg(layers, several.ok = TRUE,
                       choices = emodnet_get_wfs_info(wfs)$layer_name)

    # check filter vector
    if(!is.null(cql_filter)){
        checkmate::testCharacter(cql_filter, min.len = 1)
        if(length(cql_filter) == 1 & length(layers) > 1){
            cql_filter <- rep(cql_filter, times = length(layers))
            usethis::ui_info('{usethis::ui_field("cql_filter")} {usethis::ui_code(cql_filter)} recycled across all layers')
        }
        if(checkmate::test_named(cql_filter)){
            cql_filter <- cql_filter[layers]
            }
        checkmate::assert_character(cql_filter, len = length(layers))
    }else{
        cql_filter <- rep(NA, times = length(layers))
    }

        # get features
    out <- purrr::map2(.x = layers, .y = cql_filter, ~ews_get_layer(.x, wfs, cql_filter = .y), wfs,
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

ews_get_layer <- function(x, wfs, suppress_warnings = FALSE, cql_filter = NULL){
    layer <- NULL
    if(is.na(cql_filter)){cql_filter <- NULL}
    if(is.null(cql_filter)){
        # get layer without cql_filter
        tryCatch(
            layer <- wfs$getFeatures(x),
            error = function(e) {
                usethis::ui_warn("Download of layer {usethis::ui_value(x)} failed: {usethis::ui_field(e)}")
                }
        )
    }else{
        # get layer using cql_filter
        tryCatch(
            layer <- wfs$getFeatures(x, cql_filter = utils::URLencode(cql_filter)),
            error = function(e) {
                usethis::ui_warn("Download of layer {usethis::ui_value(x)} failed: {usethis::ui_field(e)}")
                }
        )


    }
    return(layer)
}
