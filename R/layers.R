#' Get EMODnet WFS layers
#'
#' Performs an WFS getFeature request for layers from a `wfs` object or
#' specified EMODnet Service. Filtering
#' of layer features can also be handled via ECQL language filters.
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @param layers a character vector of layer names. To get info on layers,
#' including
#' `layer_name` use [emodnet_get_wfs_info()].
#' @param crs integer. EPSG code for the output crs. If `NULL` (default), layers
#' are returned with original crs.
#' @param cql_filter character. Features returned can be filtered using valid
#' Extended Common Query Language (ECQL) filtering statements
#' (<https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html>).
#' Should be one of:
#'  \itemize{
#'   \item{character string or character vector of length 1.
#'   Filter will be recycled across all layers requested}
#'   \item{character vector of length equal to the length of layers.
#'   Filter will be matched to layers sequentially.
#'   Elements containing `NA` are ignored}
#'   \item{named character vector. Each filter will be applied to the layer
#'   corresponding to the filter name.
#'   Filters with names that do not correspond to any layers are ignored.
#'   Layers without corresponding filters are returned whole }
#' }
#' @param reduce_layers whether to reduce output layers to a single `sf` object.
#' @param ... additional vendor parameter arguments passed to
#' [`ows4R::GetFeature()`](https://docs.geoserver.org/stable/en/user/services/wfs/reference.html#getfeature).# nolint
#' For example, including `count=1` returns the first available feature.
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
#' )
#'
#' # Layers as character vector, layers to be reduced
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
#' # Usage of vendor parameter
#' emodnet_get_layers(
#'   service = "human_activities",
#'   layers = "maritimebnds",
#'   count = 1,
#'   reduce_layers = TRUE
#' )
#' }
emodnet_get_layers <- function(wfs = NULL,
                               service = NULL,
                               service_version = NULL,
                               layers,
                               crs = NULL,
                               cql_filter = NULL,
                               reduce_layers = FALSE,
                               ...) {
  deprecate_message_service_version(service_version, "emodnet_get_layers")
  # check wfs ----------------------------------------------------------------

  if (is.null(wfs) && is.null(service)) {
    cli::cli_abort(
      c(
        "Please provide a valid {.field service} name or {.field wfs} object.",
        x = "Both cannot be {.val NULL} at the same time."
      )
    )
  }

  wfs <- wfs %||% emodnet_init_wfs_client(service)

  check_wfs(wfs)

  # check layers -----------------------------------------
  layers <- match.arg(
    layers,
    several.ok = TRUE,
    choices = emodnet_get_wfs_info(wfs)$layer_name
  )

  formats <- purrr::map_chr(layers, get_layer_format, wfs)
  if (any(formats != "sf") && reduce_layers) {
    cli::cli_abort(
      c(
        "Can't reduce layers when one is a data.frame",
        i = 'data.frame layer(s): {.val {toString(layers[formats == "data.frame"])}}' # nolint
      )
    )
  }

  # check filter vector -----------------------------------------
  cql_filter <- cql_filter %||% rep(NA, times = length(layers))
  checkmate::assert_character(cql_filter, min.len = 1L, any.missing = TRUE)

  if (length(cql_filter) == 1L && length(layers) > 1L) {
    cql_filter <- rep(cql_filter, times = length(layers))
    cli_alert_info(
      "{.field cql_filter} {.code {cql_filter}} recycled across all layers"
    )
  }

  if (checkmate::test_named(cql_filter)) {
    cql_filter <- cql_filter[layers]
  }
  checkmate::assert_character(cql_filter, len = length(layers))


  # get features -------------------------------------------------------------
  # unnamed function and explicit passing of ellipses used
  # because of idiosyncratic use of ...
  # within purrr::map2 function.
  # See: https://stackoverflow.com/questions/48215325/passing-ellipsis-arguments-to-map-function-purrr-package-r # nolint
  out <- purrr::map2(
    .x = layers, .y = cql_filter,
    .f = function(x, y, wfs, ...) {
      ews_get_layer(
        x,
        wfs = wfs, cql_filter = y, ...
      )
    },
    wfs, ...
  ) %>%
    stats::setNames(layers)

  # if reduce_layers = T, reduce to single sf --------------------------------
  if (reduce_layers) {
    tryCatch(
      out <- purrr::reduce(out, rbind),
      error = function(e) {
        cli::cli_abort(
          c(
            "Cannot reduce layers.",
            i = "Try again with {.code reduce_layers = FALSE}"
          )
        )
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
    # If full crs object not available, try to get epsg number from identifier
    #  ofthe default CRS for this feature type in service description CRS
    wfs_crs <- get_layer_default_crs(layer, wfs, output = "epsg.num")
  }

  if (!is.na(wfs_crs) && !is.null(wfs_crs)) {
    # If full crs object not available, try to get epsg number from identifier
    #  ofthe default CRS for this feature type in service description CRS
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
    cli::cli_warn("{.field crs} missing from `sf` object.")

    if (!is.null(crs)) {
      sf::st_crs(sf) <- crs
      cli_alert_info("{.field crs} set to user specified CRS: {.val {crs}}.")
    }
  } else {
    if (!is.null(crs)) {
      sf <- sf::st_transform(sf, crs)
      cli_alert_info("{.field crs} transformed to {.val {crs}}.")
    }
  }
  return(sf)
}

standardise_crs <- function(out, crs = NULL) {
  if (checkmate::test_class(out, "list")) {
    purrr::map(out, ~ checkmate_crs(.x, crs = crs))
  } else {
    checkmate_crs(out, crs = crs)
  }
}

ews_get_layer <- function(x, wfs, cql_filter = NULL, ...) {
  # check and namespace layers -----------------------------------------------
  namespaced_x <- namespace_layer_names(wfs, x)

  layer <- NULL
  if (is.na(cql_filter)) {
    cql_filter <- NULL
  }
  if (is.null(cql_filter)) {
    # get layer without cql_filter
    tryCatch(
      {
        layer <- wfs$getFeatures(namespaced_x, ...)

        if (inherits(layer, "sf")) {
          layer <- check_layer_crs(layer, layer = x, wfs = wfs)
        }
      },
      error = function(e) {
        cli::cli_warn("Download of layer {.val {x}} failed: {.field {e}}")
      }
    )
  } else {
    # get layer using cql_filter
    tryCatch(
      {
        layer <- wfs$getFeatures(
          namespaced_x,
          cql_filter = utils::URLencode(cql_filter),
          ...
        )

        if (inherits(layer, "sf")) {
          layer <- check_layer_crs(layer, layer = x, wfs = wfs)
        }
      },
      error = function(e) {
        cli::cli_warn("Download of layer {.val {x}} failed: {.field {e}}")
      }
    )
  }
  return(layer)
}

namespace_layer_names <- function(wfs, layers) {
  info <- emodnet_get_wfs_info(wfs)
  layers <- match.arg(layers, choices = info$layer_name, several.ok = TRUE)

  # get layer namespace from info and concatenate with layer name. Otherwise
  # empty list returned in capabilities$findFeatureTypeByName
  info[
    info$layer_name %in% layers,
    c("layer_namespace", "layer_name")
  ] %>%
    apply(1L, FUN = function(x) {
      paste0(x, collapse = ":")
    })
}

get_layer_format <- function(layer, wfs) {
  layers <- emodnet_get_wfs_info(wfs)
  layers$format[layers$layer_name == layer]
}
