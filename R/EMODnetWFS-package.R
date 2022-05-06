#' @keywords internal
#' @importFrom rlang .data `%||%`
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

emodnetwfs_user_agent <- function() {
  if (whoami::gh_username() %in% c("annakrystalli", "salvafern", "maelle")) {
  	return("EMODnetWFS R package DEV https://github.com/EMODnet/EMODnetWFS")
  }
  if (nzchar(Sys.getenv("EMODNETWFS_CI"))) {
  	return("EMODnetWFS R package CI https://github.com/EMODnet/EMODnetWFS")
  }

  "EMODnetWFS R package https://github.com/EMODnet/EMODnetWFS"
}
