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
#' layer_attributes_summarise(service = "human_activities", layer = "maritimebnds")
layer_attributes_summarise <- function(layer, wfs = NULL,
                           service,
                           service_version = "2.0.0"){

    if(is.null(wfs)){
        wfs <- emodnet_init_wfs_client(service,
                                       service_version)
    }else{check_wfs(wfs)}


    summary(get_layer_features(layer, wfs))
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
#' layer_attributes_get_name(service = "human_activities", layer = "maritimebnds")
layer_attributes_get_name <- function(layer, wfs = NULL,
                                       service,
                                       service_version = "2.0.0"){

    if(is.null(wfs)){
        wfs <- emodnet_init_wfs_client(service,
                                       service_version)
    }else{check_wfs(wfs)}


    names(get_layer_features(layer, wfs))
}




#' Inspect layer attribute
#'
#' @inheritParams layer_attributes_summarise
#' @param attribute character string, name of layer attribute (variable).
#' @inheritParams emodnet_init_wfs_client
#' @inheritParams emodnet_get_wfs_info
#'
#' @return Detailed summary of individual attribute (variable). Particularly useful for inspecting
#' factor or character variable levels or unique values.
#' @export
#'
#' @examples
#' wfs <- EMODnetWFS::emodnet_init_wfs_client(service = "human_activities")
#' layer_attributes_get_name(wfs)
#' layer_attribute_inspect(wfs, layer = "maritimebnds", attribute = "sitename")
layer_attribute_inspect <- function(wfs = NULL,
                                    service,
                                    service_version = "2.0.0",
                                    layer, attribute) {

    if(is.null(wfs)){
        wfs <- emodnet_init_wfs_client(service,
                                       service_version)
    }else{check_wfs(wfs)}

    attribute <- match.arg(attribute, several.ok = FALSE,
                           choices = names(get_layer_features(layer, wfs)))

    attribute_type <- class(get_layer_features(layer, wfs)[[attribute]])

    switch(attribute_type,
           character = get_layer_features(layer, wfs)[[attribute]] %>% janitor::tabyl(),
           factor = janitor::tabyl(get_layer_features(layer, wfs)[[attribute]]),
           numeric = summary(get_layer_features(layer, wfs)[[attribute]]),
           integer = summary(get_layer_features(layer, wfs)[[attribute]]),
           double = summary(get_layer_features(layer, wfs)[[attribute]]),
           Date = summary(get_layer_features(layer, wfs)[[attribute]])#,
           #geometry =
               )

}



get_layer_metadata <- function(layer, wfs) {

    # check layers
    layer_info <- emodnet_get_wfs_info(wfs)
    layer <- match.arg(layer, several.ok = FALSE,
                       choices = layer_info$layer_name)

    layer_name <- paste(layer_info$layer_namespace[layer_info$layer_name == layer],
                        layer, sep = ":")

    wfs$getCapabilities()$findFeatureTypeByName(layer_name)

}



get_layer_features <- function(layer, wfs) {

    get_layer_metadata(layer, wfs)$features

}

get_layer_bbox <- function(layer, wfs) {
    sf::st_bbox(get_layer_metadata(layer, wfs))
}

get_layer_geom_name <- function(layer, wfs) {
    desc <- get_layer_attribute_descriptions(layer, wfs)
    desc$name[desc$type == "geometry"]
}

get_layer_default_crs <- function(layer, wfs) {
    crs_input <- get_layer_metadata(layer, wfs)$getDefaultCRS()$input
    regmatches(crs_input, regexpr('epsg.*$', crs_input))
}

get_layer_attribute_descriptions <- function(layer, wfs) {
    get_layer_metadata(layer, wfs)$getDescription(pretty = TRUE)
}
