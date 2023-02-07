#' Initialise an EMODnet WFS client
#'
#' @param service the EMODnet OGC WFS service name.
#' For available services, see [`emodnet_wfs()`].
#' @param service_version the WFS service version. Defaults to "2.0.0".
#' @param logger the logger. Either `NULL` (no logging info), `"INFO"` (log about ows4R requests)
#' or `"DEBUG"` (including curl details).
#'
#' @return An [`ows4R::WFSClient`] R6 object with methods for interfacing an OGC Web Feature Service.
#' @export
#'
#' @seealso `WFSClient` in package `ows4R`.
#' @examples
#' \dontrun{
#' wfs <- emodnet_init_wfs_client(service = "bathymetry")
#' }
emodnet_init_wfs_client <- function(service, service_version = "2.0.0", logger = NULL) {
  check_service_name(service)

  service_url <- get_service_url(service)

  create_client <- function() {

    wfs <- suppressWarnings(
        ows4R::WFSClient$new(
            service_url,
            serviceVersion = service_version,
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

  tryCatch(
    create_client(),
    error = function(e) {
      check_service(perform_http_request(service_url))
    }
  )
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

# Checks if there is internet and performs an HTTP GET request
perform_http_request <- function(service_url) {
 cli_alert_danger("WFS client creation failed.")
 cli_alert_info("Service: {.val {service_url}}", .envir = parent.frame(n = 2))

  has_internet <- function() {
    if (nzchar(Sys.getenv("NO_INTERNET_TEST_EMODNET"))) {
      return(FALSE)
    }
    curl::has_internet()
  }

  if (!has_internet()) {
    cli_alert_info("Reason: There is no internet connection")
    return(NULL)
  }

  service_url %>%
    paste0("?request=GetCapabilities") %>%
    httr::GET()
}

# Checks if there is internet connection and HTTP status of the service
check_service <- function(request) {
  if (is.null(request)) {
    cli::cli_abort("WFS client creation failed.")
  }

	if (httr::http_error(request)) {
		cli_alert_danger("HTTP Status: {httr::http_status(request)$message}")

		is_monitor_up <- !is.null(curl::nslookup("monitor.emodnet.eu", error = FALSE))
		if (interactive() && is_monitor_up) {
			browse_monitor <- utils::askYesNo("Browse the EMODnet OGC monitor?", FALSE, prompts = "yes/no/cancel")
			if (is.na(browse_monitor)) browse_monitor <- FALSE
			if (browse_monitor) {
				utils::browseURL("https://monitor.emodnet.eu/resources?lang=en&resource_type=OGC:WFS")
			}
		}

		cli::cli_abort("Service creation failed")

    # If no HTTP status, something else is wrong
  } else if (!httr::http_error(request)) {
  	cli_alert_info("HTTP Status: {.val {httr::http_status(request)$message}}")

  	cli::cli_abort(
  		c(
  			"An exception has occurred.",
  			i = "Please raise an issue in {packageDescription('EMODnetWFS')$BugReports}"
  		)
  	)
  }
}
