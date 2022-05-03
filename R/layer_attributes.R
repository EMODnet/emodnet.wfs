#' Get summaries of layer attributes (variables)
#'
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @param layer character sting of layer name. To get info on layers, including
#' `layer_name` use [emodnet_get_wfs_info()].
#'
#' @return output of `summary()` on the attributes (variables) in a given layer for a given service.
#' @export
#'
#' @examples
#' \dontrun{
#' layer_attributes_summarise(service = "human_activities", layer = "maritimebnds")
#' }
layer_attributes_summarise <- function(wfs = NULL,
                                       service = NULL,
                                       service_version = "2.0.0", layer) {
    summary(
        layer_attributes_tbl(
            wfs = wfs,
            service = service,
            service_version = service_version,
            layer
        )
    )
}

#' Get layer attribute description
#'
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @inheritParams layer_attributes_summarise
#'
#' @return data.frame containing layer attribute descriptions (metadata).
#' @export
#'
#' @examples
#' \dontrun{
#' layer_attribute_descriptions(service = "human_activities", layer = "maritimebnds")
#' }
layer_attribute_descriptions <- function(wfs = NULL,
                                         service = NULL,
                                         service_version = "2.0.0", layer) {
  wfs <- wfs %||% emodnet_init_wfs_client(service, service_version)
  check_wfs(wfs)

  get_layer_metadata(layer, wfs)$getDescription(pretty = TRUE)
}


#' Get names of layer attributes
#'
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @inheritParams layer_attributes_summarise
#'
#' @return character vector of layer attribute (variable) names.
#' @export
#'
#' @examples
#' \dontrun{
#' layer_attributes_get_names(service = "human_activities", layer = "maritimebnds")
#' }
layer_attributes_get_names <- function(wfs = NULL,
                                       service = NULL,
                                       service_version = "2.0.0", layer) {
    layer_attribute_descriptions(
        wfs = wfs,
        service = service,
        service_version = service_version,
        layer = layer
    )$name
}

#' Inspect layer attributes
#'
#' @inheritParams layer_attributes_summarise
#' @param attribute character string, name of layer attribute (variable). Use
#' [layer_attributes_get_names()] to get layer attribute names.
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#'
#' @return Detailed summary of individual attribute (variable). Particularly useful for inspecting
#' factor or character variable levels or unique values.
#' @export
#'
#' @examples
#' \dontrun{
#' wfs <- emodnet_init_wfs_client(service = "human_activities")
#' layer_attributes_get_names(wfs, layer = "maritimebnds")
#' layer_attribute_inspect(wfs, layer = "maritimebnds", attribute = "sitename")
#' }
layer_attribute_inspect <- function(wfs = NULL,
                                    service = NULL,
                                    service_version = "2.0.0",
                                    layer, attribute) {
  wfs <- wfs %||% emodnet_init_wfs_client(service, service_version)
  check_wfs(wfs)

  layer <- match.arg(layer,
    several.ok = FALSE,
    choices = emodnet_get_wfs_info(wfs)$layer_name
  )
  namespaced_layer <- namespace_layer_names(wfs, layer)

  attribute <- match.arg(attribute,
    several.ok = FALSE,
    choices = layer_attributes_get_names(wfs, layer = layer)
  )

  attribute_vector <- wfs$getFeatures(namespaced_layer, PROPERTYNAME = attribute)[[attribute]]

  if (inherits(attribute_vector, "sfc")) {
    attribute_type <- "geometry"
  } else {
    attribute_type <- class(attribute_vector)
  }


  switch(attribute_type,
    character = attribute_vector %>% janitor::tabyl(),
    factor = attribute_vector %>% janitor::tabyl(),
    numeric = summary(attribute_vector),
    integer = summary(attribute_vector),
    double = summary(attribute_vector),
    Date = summary(attribute_vector),
    geometry = sf::st_geometry(attribute_vector)
  )
}


#' Get layer attribute values tibble
#'
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#' @inheritParams layer_attributes_summarise
#'
#' @return tibble of layer attribute (variable) values with geometry column removed.
#' @details Request excluding spatial information can be significantly faster. Can be
#' useful for inspecting attribute values and constructing feature filters for more
#' targeted and faster layer download.
#' @export
#'
#' @examples
#' \dontrun{
#' layer_attributes_tbl(service = "human_activities", layer = "maritimebnds")
#' }
layer_attributes_tbl <- function(wfs = NULL,
                                 service = NULL,
                                 service_version = "2.0.0", layer) {
  wfs <- wfs %||% emodnet_init_wfs_client(service, service_version)
  check_wfs(wfs)

  layer <- match.arg(layer,
    several.ok = FALSE,
    choices = emodnet_get_wfs_info(wfs)$layer_name
  )
  namespaced_layer <- namespace_layer_names(wfs, layer)

  attributes <- layer_attributes_get_names(wfs, layer = layer)
  attributes <- attributes[attributes != get_layer_geom_name(layer, wfs)]

  wfs$getFeatures(namespaced_layer, PROPERTYNAME = paste(attributes, collapse = ",")) %>%
    sf::st_drop_geometry() %>%
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
  layer <- match.arg(layer,
    several.ok = FALSE,
    choices = emodnet_get_wfs_info(wfs)$layer_name
  )

  desc <- layer_attribute_descriptions(wfs, layer = layer)
  desc$name[desc$type == "geometry"]
}

get_layer_default_crs <- function(layer, wfs, output = c("crs", "epsg.text", "epsg.num")) {
  check_wfs(wfs)
  output <- match.arg(output, several.ok = FALSE)

  layer <- match.arg(layer,
    several.ok = FALSE,
    choices = emodnet_get_wfs_info(wfs)$layer_name
  )

  crs <- get_layer_metadata(layer, wfs)$getDefaultCRS()
  if (output == "crs") {
    return(crs)
  }


  epsg.text <- regmatches(crs$input, regexpr("epsg\\:[[:digit:]]{4}", crs$input))
  if (output == "epsg.text") {
    return(epsg.text)
  }
  if (output == "epsg.num") {
    return(
      as.numeric(
        regmatches(
          epsg.text,
          regexpr("[[:digit:]]{4}", epsg.text)
        )
      )
    )
  }
}
