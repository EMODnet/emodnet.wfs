#' @description Initialise an EMODnet WFS client
#'
#' @title Connect to a data source (service)
#'
#' @param service the EMODnet OGC WFS service name.
#' For available services, see [`emodnet_wfs()`].
#' @param service_version `r lifecycle::badge('deprecated')`
#' the WFS service version. Now always "2.0.0".
#' @param logger the logger. Either `NULL` (no logging info), `"INFO"`
#' (log about ows4R requests)
#' or `"DEBUG"` (including curl details).
#'
#' @return An [`ows4R::WFSClient`] R6 object with methods for interfacing an
#' OGC Web Feature Service.
#' @export
#'
#' @seealso `WFSClient` in package `ows4R`.
#' @examplesIf emodnet.wfs:::should_run_example()
#' wfs <- emodnet_init_wfs_client(service = "bathymetry")
emodnet_init_wfs_client <- function(service,
                                    service_version = NULL,
                                    logger = NULL) {
  deprecate_msg_service_version(
    service_version,
    "emodnet_init_wfs_client"
  )

  check_service_name(service)

  service_url <- get_service_url(service)

  wfs <- suppressWarnings(
    ows4R::WFSClient$new(
      service_url,
      serviceVersion = "2.0.0",
      headers = c("User-Agent" = emodnetwfs_user_agent()),
      logger = logger
    )
  )

  check_wfs(wfs)
  cli_alert_success("WFS client created successfully")
  cli_alert_info("Service: {.val {wfs$getUrl()}}")
  cli_alert_info("Version: {.val {wfs$getVersion()}}")

  wfs
}

check_service_name <- function(service) {
  checkmate::assert_choice(service, emodnet_wfs()$service_name)
}

check_wfs <- function(wfs) {
  checkmate::assertR6(
    wfs,
    classes = c("WFSClient", "OWSClient", "OGCAbstractObject", "R6")
  )
}

get_service_url <- function(service) {
  emodnet_wfs()$service_url[emodnet_wfs()$service_name == service]
}

get_service_name <- function(service_url) {
  emodnet_wfs()$service_name[emodnet_wfs()$service_url == service_url]
}
