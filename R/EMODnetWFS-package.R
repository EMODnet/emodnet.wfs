#' @keywords internal
#' @importFrom rlang .data `%||%`
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

emodnetwfs_collaborators <- function() {
  readLines(system.file("collaborators.txt", package = "EMODnetWFS"))
}

emodnetwfs_user_agent <- function() {
  version <- as.character(packageVersion("EMODnetWFS"))

  if (nzchar(Sys.getenv("EMODNETWFS_CI"))) {
  	return(sprintf("EMODnetWFS R package %s CI https://github.com/EMODnet/EMODnetWFS", version))
  }

  if (whoami::gh_username(fallback = "not-an-emodnetwfs-dev") %in% emodnetwfs_collaborators()) {
  	return(sprintf("EMODnetWFS R package %s DEV https://github.com/EMODnet/EMODnetWFS", version))
  }

  sprintf("EMODnetWFS R package %s https://github.com/EMODnet/EMODnetWFS", version)
}
