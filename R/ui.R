# from usethis ui functions

ui_cat <- function(message, ...) {
	if (!getOption("EMODnetWFS.quiet", FALSE)) {
		cat(sprintf(message, ...))
	}
}

ui_info <- function(text) {
	ui_cat("%s %s", crayon::yellow(cli::symbol$info), text)
}

ui_done <- function(text) {
	ui_cat("%s %s", crayon::green(cli::symbol$tick), text)
}

ui_oops <- function(text) {
	ui_cat("%s %s", crayon::red(cli::symbol$cross), text)
}

ui_line <- function(text) {
	ui_cat(paste0("\n", text, "\n"))
}

format_field <- function(text) {
	crayon::green(text)
}

ui_field <- function(text) {
	ui_cat(format_field(text))
}

format_value <- function(text) {
	crayon::blue(encodeString(text, quote = "'"))
}

ui_value <- function(text) {
	ui_cat(format_value(text))
}

format_code <- function(text) {
	text <-  encodeString(text, quote = "`")
	text <- crayon::silver(text)
	text
}

ui_code <- function(text) {
	ui_cat(format_code(text))
}

abort <- function(message, ...) {
	rlang::abort(sprintf(message, ...))
}

warn <- function(message, ...) {
	rlang::warn(sprintf(message, ...))
}
