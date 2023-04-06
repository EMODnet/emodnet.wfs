deprecate_message_service_version <- function(service_version, function_name) {
  if (!is.null(service_version)) {
    lifecycle::deprecate_soft(
      sprintf("%s(service_version)", function_name),
      when = "2.0.1",
      details = "All calls are made with service version 2.0.0.
			For more control, consider using {ows4r} directly."
    )
  }
}
