#' Get EMODnet WFS datasets (layers)
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
#'
#'  - character string or character vector of length 1.
#'   Filter will be recycled across all layers requested.
#'  - character vector of length equal to the length of layers.
#'   Filter will be matched to layers sequentially.
#'   Elements containing `NA` are ignored
#'   - named character vector. Each filter will be applied to the layer
#'   corresponding to the filter name.
#'   Filters with names that do not correspond to any layers are ignored.
#'   Layers without corresponding filters are returned whole.
#'
#' @param simplify whether to reduce output layers to a single `sf` object.
#' This only works if the column names are the same.
#' @param reduce_layers `r lifecycle::badge("deprecated")` use `simplify`.
# nolint start: line_length_linter
#' @param ... additional vendor parameter arguments passed to
#' [`ows4R::GetFeature()`](https://docs.geoserver.org/stable/en/user/services/wfs/reference.html#getfeature).
#' For example, including `count = 1` returns the first available feature.
#' Or `outputFormat = "CSV"` (or `outputFormat = "JSON"`) might help downloading
#' bigger datasets.
# nolint end
#' @return If `simplify = FALSE` (default), a list of `sf`
#' objects, one element for each layer. Any layers for which download was
#' unsuccessful will be NULL. If `simplify = TRUE`, all layers are
#' reduced (if possible: if all
#' column names are the same) to a single `sf` containing data for all layers.
#' `NULL` layers are ignored. `simplify = TRUE` can also be used to return
#' an `sf` out of a single layer request instead of a list of length 1.
#' @export
#'
#' @examplesIf should_run_example()
#' # Layers as character vector
#' emodnet_get_layers(
#'   service = "biology",
#'   layers = c("mediseh_zostera_m_pnt", "mediseh_posidonia_nodata")
#' )
#'
#'
#' # Usage of cql_filter
#' emodnet_get_layers(
#'   service = "biology",
#'   layers = "mediseh_zostera_m_pnt",
#'   cql_filter = "country = 'Francia'"
#' )
#' # Usage of vendor parameter
#' emodnet_get_layers(
#'   service = "biology",
#'   layers = "mediseh_zostera_m_pnt",
#'   count = 1
#' )
#'
#' # Usage of csv output
#' data <- emodnet_get_layers(
#'     service = "biology_occurrence_data",
#'     layers = "abiotic_observations",
#'     outputFormat = "CSV"
#' )
#' str(data[["abiotic_observations"]])
#'
#' @section Big downloads:
#'
# nolint start: line_length_linter
#' If a layer is really big (like `"abiotic_observations"` of the
#' `"biology_occurrence_data"` service),
#' you might consider a combination of these ideas:
#' - using [`outputFormat = "CSV"`](https://docs.geoserver.org/stable/en/user/services/wfs/reference.html#getfeature);
#' - filtering using [`cql_filters`](https://docs.ropensci.org/emodnet.wfs/articles/ecql_filtering.html) or
#' [bounding boxes](https://docs.ropensci.org/emodnet.wfs/articles/request-params.html#limit-spatial-extent-using-a-boundary-box)
#' (possibly splitting the area of interests into several requests);
#' - Using [EMODnet's download toolbox](https://emodnet.ec.europa.eu/geoviewer/).
# nolint end
emodnet_get_layers <- function(
  wfs = NULL,
  service = NULL,
  service_version = NULL,
  layers,
  crs = NULL,
  cql_filter = NULL,
  simplify = FALSE,
  reduce_layers = deprecated(),
  ...
) {
  deprecate_msg_service_version(service_version, "emodnet_get_layers")

  if (lifecycle::is_present(reduce_layers)) {
    lifecycle::deprecate_soft(
      "2.0.3",
      "emodnet_get_layers(reduce_layers = )",
      "emodnet_get_layers(simplify = )"
    )
    simplify <- reduce_layers
  }
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
    choices = sort(emodnet_get_wfs_info(wfs)$layer_name)
  )

  formats <- purrr::map_chr(layers, get_layer_format, wfs)
  if (any(formats != "sf") && simplify) {
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
    .x = layers,
    .y = cql_filter,
    .f = function(x, y, wfs, ...) {
      ews_get_layer(
        x,
        wfs = wfs,
        cql_filter = y,
        ...
      )
    },
    wfs,
    ...
  ) |>
    stats::setNames(layers)

  # if simplify = TRUE, reduce to single sf --------------------------------
  if (simplify) {
    tryCatch(
      out <- purrr::reduce(out, rbind), # nolint: implicit_assignment_linter
      error = function(e) {
        cli::cli_abort(
          c(
            "Cannot reduce layers.",
            i = "Try again with {.code simplify = FALSE}"
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

  layer_sf
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
  } else if (!is.null(crs)) {
    sf <- sf::st_transform(sf, crs)
    cli_alert_info("{.field crs} transformed to {.val {crs}}.")
  }

  sf
}

standardise_crs <- function(out, crs = NULL) {
  if (checkmate::test_class(out, "list")) {
    purrr::map(out, checkmate_crs, crs = crs)
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
  layer
}

namespace_layer_names <- function(wfs, layers) {
  info <- emodnet_get_wfs_info(wfs)
  layers <- match.arg(layers, choices = info$layer_name, several.ok = TRUE)

  # get layer namespace from info and concatenate with layer name. Otherwise
  # empty list returned in capabilities$findFeatureTypeByName
  info[
    info$layer_name %in% layers,
    c("layer_namespace", "layer_name")
  ] |>
    apply(1L, FUN = paste0, collapse = ":")
}

get_layer_format <- function(layer, wfs) {
  layers <- emodnet_get_wfs_info(wfs)
  layers$format[layers$layer_name == layer]
}
