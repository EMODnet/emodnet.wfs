
## QUERY Each layer of each EMODnet WFS service (for maximum amount of secs set by timeout)
## and store layer size in bytes.

## Functions ----
get_layer_size <- function(service_url, layer_namespace, layer_name,
                           timeout_secs = 3){
    service_url %>%
        httr::parse_url() %>%
        purrr::list_merge(query = list(service = "wfs",
                                       request = "GetFeature",
                                       typeName = paste(layer_namespace,
                                                        layer_name,
                                                        sep = ":"))) %>%
        httr::build_url() %>%
        httr::GET(httr::timeout(timeout_secs)) %>%
        object.size() %>%
        as.numeric()
}

safe_get_layer_size <- purrr::safely(get_layer_size, otherwise = NA_real_)

compile_layer_size_info <- function(service_url, service_name, layer_namespace,
                                    layer_name, timeout_secs = 3){

    response <- safe_get_layer_size(service_url, layer_namespace,
                                    layer_name, timeout_secs)

    tibble::tibble(service_name, service_url, layer_namespace, layer_name,
                   layer_size_bytes = response$result,
                   error = response$error$message, timeout_secs)

}

## ----------- WORKFLOW  ####
all_layer_info <- EMODnetWFS::emodnet_get_all_wfs_info()

layer_map_data <- all_layer_info %>%
    dplyr::select(service_url, service_name, layer_namespace, layer_name) %>%
    dplyr::mutate(timeout_secs = 5) %>%
    # dplyr::slice(1:3) %>%
    identity()

readr::write_csv(layer_sizes, "attic/layer_sizes.csv")

