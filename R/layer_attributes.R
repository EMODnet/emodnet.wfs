#' Get summaries of layer attributes (variables)
#'
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @param layer character sting of layer name. To get info on layers, including
#' `layer_name` use [emodnet_get_wfs_info()].
#'
#' @return output of `summary()` on the attributes (variables) in a given layer
#' for a given service.
#' @family attributes
#' @export
#'
#' @examplesIf should_run_example()
#' layer_attributes_summarise(
#'   service = "biology",
#'   layer = "mediseh_zostera_m_pnt"
#' )
layer_attributes_summarise <- function(
  wfs = NULL,
  service = NULL,
  service_version = NULL,
  layer
) {
  deprecate_msg_service_version(
    service_version,
    "layer_attributes_summarise"
  )
  summary(
    layer_attributes_tbl(
      wfs = wfs,
      service = service,
      layer = layer
    )
  )
}

#' @description Get layer attribute description
#'
#' @title Variables available in a dataset (layer) from a data source (service).
#'
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @inheritParams layer_attributes_summarise
#'
#' @return data.frame containing layer attribute descriptions (metadata).
#' @family attributes
#' @export
#'
#' @examplesIf should_run_example()
#' layer_attribute_descriptions(
#'   service = "biology",
#'   layer = "mediseh_zostera_m_pnt"
#' )
layer_attribute_descriptions <- function(
  wfs = NULL,
  service = NULL,
  service_version = NULL,
  layer
) {
  deprecate_msg_service_version(
    service_version,
    "layer_attribute_descriptions"
  )

  wfs <- wfs %||% emodnet_init_wfs_client(service)
  check_wfs(wfs)

  get_layer_metadata(layer, wfs)$getDescription(pretty = TRUE)
}


#' Names of variables (attributes) available from a dataset (layer)
#' in a data source (service).
#'
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @inheritParams layer_attributes_summarise
#'
#' @family attributes
#'
#' @return character vector of layer attribute (variable) names.
#' @export
#'
#' @examplesIf should_run_example()
#' layer_attributes_get_names(
#'   service = "biology",
#'   layer = "mediseh_zostera_m_pnt"
#' )
layer_attributes_get_names <- function(
  wfs = NULL,
  service = NULL,
  service_version = NULL,
  layer
) {
  deprecate_msg_service_version(
    service_version,
    "layer_attributes_get_names"
  )

  layer_attribute_descriptions(
    wfs = wfs,
    service = service,
    layer = layer
  )$name
}

#' @description Inspect layer attributes
#'
#' @title Summary of individual variable (attribute) in a dataset (layer) from a
#' data source (service).
#'
#' @inheritParams layer_attributes_summarise
#' @param attribute character string, name of layer attribute (variable). Use
#' [layer_attributes_get_names()] to get layer attribute names.
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#'
#' @return Detailed summary of individual attribute (variable). Particularly
#' useful for inspecting
#' factor or character variable levels or unique values.
#' @family attributes
#' @export
#'
#' @examplesIf should_run_example()
#' wfs <- emodnet_init_wfs_client(service = "biology")
#' layer_attributes_get_names(wfs, layer = "mediseh_zostera_m_pnt")
#' layer_attribute_inspect(
#'   wfs, layer = "mediseh_zostera_m_pnt",
#'   attribute = "country"
#' )
layer_attribute_inspect <- function(
  wfs = NULL,
  service = NULL,
  service_version = NULL,
  layer,
  attribute
) {
  deprecate_msg_service_version(service_version, "layer_attribute_inspect")

  wfs <- wfs %||% emodnet_init_wfs_client(service)
  check_wfs(wfs)

  layer <- match.arg(
    layer,
    several.ok = FALSE,
    choices = emodnet_get_wfs_info(wfs)$layer_name
  )
  namespaced_layer <- namespace_layer_names(wfs, layer)

  attribute <- match.arg(
    attribute,
    several.ok = FALSE,
    choices = layer_attributes_get_names(wfs, layer = layer)
  )

  attribute_vector <- wfs$getFeatures(
    namespaced_layer,
    PROPERTYNAME = attribute
  )[[attribute]]

  if (inherits(attribute_vector, "sfc")) {
    attribute_type <- "geometry"
  } else {
    attribute_type <- class(attribute_vector)
  }

  switch(
    attribute_type,
    character = tabyl(attribute_vector),
    factor = tabyl(attribute_vector),
    numeric = summary(attribute_vector),
    integer = summary(attribute_vector),
    double = summary(attribute_vector),
    Date = summary(attribute_vector),
    geometry = sf::st_geometry(attribute_vector)
  )
}

#' @description Get layer attribute values tibble
#'
#' @title Possible values of variables (attributes) in a dataset (layer)
#' from a data source (service).
#'
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @inheritParams layer_attributes_summarise
#'
#' @return tibble of layer attribute (variable) values
#' with geometry column removed.
#' @details Request excluding spatial information can be significantly faster.
#' Can be
#' useful for inspecting attribute values and constructing feature filters
#' for more
#' targeted and faster layer download.
#' @family attributes
#' @export
#'
#' @examplesIf should_run_example()
#' layer_attributes_tbl(service = "biology", layer = "mediseh_zostera_m_pnt")
layer_attributes_tbl <- function(
  wfs = NULL,
  service = NULL,
  service_version = NULL,
  layer
) {
  deprecate_msg_service_version(service_version, "layer_attributes_tbl")

  wfs <- wfs %||% emodnet_init_wfs_client(service)
  check_wfs(wfs)

  layer <- match.arg(
    layer,
    several.ok = FALSE,
    choices = emodnet_get_wfs_info(wfs)$layer_name
  )
  namespaced_layer <- namespace_layer_names(wfs, layer)

  layer_attr <- layer_attributes_get_names(wfs, layer = layer)
  layer_attr <- layer_attr[
    layer_attr != get_layer_geom_name(layer, wfs)
  ]

  wfs$getFeatures(
    namespaced_layer,
    PROPERTYNAME = paste(layer_attr, collapse = ",")
  ) |>
    sf::st_drop_geometry() |>
    tibble::as_tibble()
}

get_layer_metadata <- function(layer, wfs) {
  check_wfs(wfs)

  namespaced_layer <- namespace_layer_names(wfs, layer)

  wfs$getCapabilities()$findFeatureTypeByName(namespaced_layer)
}

get_layer_bbox <- function(layer, wfs) {
  get_layer_metadata(layer, wfs)$getBoundingBox()
}

get_layer_geom_name <- function(layer, wfs) {
  layer <- match.arg(
    layer,
    several.ok = FALSE,
    choices = emodnet_get_wfs_info(wfs)$layer_name
  )

  desc <- layer_attribute_descriptions(wfs, layer = layer)
  desc$name[desc$type == "geometry"]
}

get_layer_default_crs <- function(
  layer,
  wfs,
  output = c("crs", "epsg.text", "epsg.num")
) {
  check_wfs(wfs)
  output <- match.arg(output, several.ok = FALSE)

  layer <- match.arg(
    layer,
    several.ok = FALSE,
    choices = emodnet_get_wfs_info(wfs)$layer_name
  )

  crs <- get_layer_metadata(layer, wfs)$getDefaultCRS() # nolint: object_name_linter
  if (output == "crs") {
    return(crs)
  }

  epsg_text <- regmatches(
    # nolint: object_name_linter
    crs$input,
    regexpr("epsg\\:[[:digit:]]{4}", crs$input)
  )
  if (output == "epsg.text") {
    return(epsg_text)
  }
  if (output == "epsg.num") {
    as.numeric(
      regmatches(
        epsg_text,
        regexpr("[[:digit:]]{4}", epsg_text)
      )
    )
  }
}
