#' Get EMODnet WFS layers
#'
#' Performs an WFS getFeature request for layers from a `wfs` object or specified EMODnet Service. Filtering
#' of layer features can also be handled via ECQL language filters.
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @param layers a character vector of layer names. To get info on layers, including
#' `layer_name` use [emodnet_get_wfs_info()].
#' @param crs integer. EPSG code for the output crs. If `NULL` (default), layers are returned with original crs.
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
#' `NULL` layers are ignored. `reduce_layers = TRUE` can also be used to return
#' an `sf` out of a single layer request instead of a list of length 1.
#' @export
#'
#' @examples
#' \dontrun{
#' # Layers as character vector
#' emodnet_get_layers(
#'   service = "seabed_habitats_individual_habitat_map_and_model_datasets",
#'   layers = c("dk003069", "dk003070")
#'  )
#'
#'  # Layers as character vector, layers to be reduced
#' emodnet_get_layers(
#'   service = "seabed_habitats_individual_habitat_map_and_model_datasets",
#'   layers = c("dk003069", "dk003070"),
#'   reduce_layers = TRUE
#' )
#'
#' # Usage of cql_filter
#' emodnet_get_layers(
#'   service = "human_activities",
#'   layers = "maritimebnds",
#'   cql_filter = "sitename='Territory sea (12 nm)'",
#'   reduce_layers = TRUE
#' )
#' }
emodnet_get_layers <- function(wfs = NULL, service = NULL, service_version = "2.0.0",
    layers, crs = NULL, cql_filter = NULL,
    reduce_layers = FALSE, suppress_warnings = FALSE) {

    # check wfs ----------------------------------------------------------------

    if (is.null(wfs) & is.null(service)) {
        usethis::ui_stop(
            "Please provide a valid {usethis::ui_field('service')} name or {usethis::ui_field('wfs')} object.
         Both cannot be {usethis::ui_value('NULL')} at the same time."
        )
    }

    wfs <- wfs %||% emodnet_init_wfs_client(service, service_version)

    check_wfs(wfs)

    # check layers -----------------------------------------
    layers <- match.arg(
        layers,
        several.ok = TRUE,
        choices = emodnet_get_wfs_info(wfs)$layer_name
    )

    formats <- purrr::map_chr(layers, get_layer_format, wfs)
    if (any(formats != "sf") && reduce_layers) {
        rlang::abort(
            c(
                "Can't reduce layers when one is a data.frame",
                i = sprintf("data.frame layer(s): %s", toString(layers[formats == "data.frame"]))
            )

        )
    }

    # check filter vector -----------------------------------------
    cql_filter <- cql_filter %||% rep(NA, times = length(layers))
    checkmate::assert_character(cql_filter, min.len = 1, any.missing = TRUE)

    if (length(cql_filter) == 1 & length(layers) > 1) {
        cql_filter <- rep(cql_filter, times = length(layers))
        usethis::ui_info('{usethis::ui_field("cql_filter")} {usethis::ui_code(cql_filter)} recycled across all layers')
    }

    if (checkmate::test_named(cql_filter)) {
        cql_filter <- cql_filter[layers]
    }
    checkmate::assert_character(cql_filter, len = length(layers))


    # get features -------------------------------------------------------------
    out <- purrr::map2(
        .x = layers, .y = cql_filter,
        ~ews_get_layer(.x, wfs, cql_filter = .y),
        wfs, suppress_warnings
    ) %>%
        stats::setNames(layers)

    # if reduce_layers = T, reduce to single sf --------------------------------
    if (reduce_layers) {
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


check_layer_crs <- function(layer_sf, layer, wfs) {

    sf_crs <- sf::st_crs(layer_sf)
    if (!is.na(sf_crs) && !is.null(sf_crs)) {
        return(layer_sf)
    }

    # try to get the identifier of the default CRS for this feature type in
    # service description CRS
    wfs_crs <- get_layer_default_crs(layer, wfs)

    if (is.na(wfs_crs) || is.null(wfs_crs)) {
        # If full crs object not available, try to get epsg number from identifier of
        # the default CRS for this feature type in service description CRS
        wfs_crs <- get_layer_default_crs(layer, wfs, output = "epsg.num")
    }

    if (!is.na(wfs_crs) && !is.null(wfs_crs)) {
        # If full crs object not available, try to get epsg number from identifier of
        # the default CRS for this feature type in service description CRS
        sf::st_crs(layer_sf) <- wfs_crs
    }

    return(layer_sf)

}


checkmate_crs <- function(sf, crs = NULL) {

    if (checkmate::test_null(sf)) {
        return(sf)
    }

    # data.frame layers
    if (!inherits(sf, "sf")) {
        return(sf)
    }

    if (is.na(sf::st_crs(sf)) || is.null(sf::st_crs(sf))) {
        usethis::ui_warn("{usethis::ui_field('crs')} missing from `sf` object.")

        if (!is.null(crs)) {
            sf::st_crs(sf) <- crs
            usethis::ui_info("{{usethis::ui_field('crs')} set to user specified CRS: {usethis::ui_value(crs)}.")
        }
    } else {
        if (!is.null(crs)) {
            sf <- sf::st_transform(sf, crs)
            usethis::ui_info("{usethis::ui_field('crs')} transformed to {usethis::ui_value(crs)}.")
        }
    }
    return(sf)
}

standardise_crs <- function(out, crs = NULL) {

    if (checkmate::test_class(out, "list")) {
        purrr::map(out, ~checkmate_crs(.x, crs = crs))
    } else {
        checkmate_crs(out, crs = crs)
    }
}

ews_get_layer <- function(x, wfs, suppress_warnings = FALSE, cql_filter = NULL) {
    # check and namespace layers -----------------------------------------------
    namespaced_x <- namespace_layer_names(wfs, x)

    layer <- NULL
    if (is.na(cql_filter)) {cql_filter <- NULL}
    if (is.null(cql_filter)) {
        # get layer without cql_filter
        tryCatch({

            layer <- wfs$getFeatures(namespaced_x)
            if (inherits(layer, "sf")) {
                layer <- check_layer_crs(layer, layer = x, wfs = wfs)
            }
        },
            error = function(e) {
                usethis::ui_warn("Download of layer {usethis::ui_value(x)} failed: {usethis::ui_field(e)}")
            }
        )
    } else {
        # get layer using cql_filter
        tryCatch({
            layer <- wfs$getFeatures(namespaced_x, cql_filter = utils::URLencode(cql_filter))
            if (inherits(layer, "sf")) {
              layer <- check_layer_crs(layer, layer = x, wfs = wfs)
            }
                },
            error = function(e) {
                usethis::ui_warn("Download of layer {usethis::ui_value(x)} failed: {usethis::ui_field(e)}")
            }
        )
    }
    return(layer)
}

namespace_layer_names <- function(wfs, layers) {

    info <- emodnet_get_wfs_info(wfs)
    layers  <- match.arg(layers, choices = info$layer_name, several.ok = TRUE)

    # get layer namespace from info and concatenate with layer name. Otherwise
    # empty list returned in capabilities$findFeatureTypeByName
    info[info$layer_name %in% layers,
        c("layer_namespace", "layer_name")] %>%
        apply(1, FUN = function(x){paste0(x, collapse=":")})
}

get_layer_format <- function(layer, wfs) {
    layers <- emodnet_get_wfs_info(wfs)
    layers$format[layers$layer_name == layer]
}
