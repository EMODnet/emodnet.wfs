#' Should we run this emodnet.wfs example?
#'
#' Determines whether we are in pkgdown or in an interactive session.
#' Do not use it in your own package!
#'
#' @return A Boolean indicating whether to run the example.
#'
#' @keywords internal
#' @export
#' @examples
#' should_run_example()
should_run_example <- function() {
    identical(Sys.getenv("IN_PKGDOWN"), "true") || interactive()
}
