cli_alert_success <- function(...) {
	if (!getOption("EMODnetWFS.quiet", FALSE)) {
		cli::cli_alert_success(...)
	}
}

cli_alert_info <- function(...) {
	if (!getOption("EMODnetWFS.quiet", FALSE)) {
		cli::cli_alert_info(...)
	}
}

cli_alert_danger <- function(...) {
	if (!getOption("EMODnetWFS.quiet", FALSE)) {
		cli::cli_alert_danger(...)
	}
}
