#' @keywords internal
#' @importFrom rlang .data `%||%`
"_PACKAGE"

## usethis namespace: start
#' @importFrom lifecycle deprecated
## usethis namespace: end
NULL

emodnetwfs_collaborators <- function() {
  readLines(system.file("collaborators.txt", package = "EMODnetWFS"))
}

emodnetwfs_user_agent <- function() {
  version <- as.character(utils::packageVersion("EMODnetWFS"))

  if (nzchar(Sys.getenv("EMODNETWFS_CI"))) {
  	return(
  		sprintf(
  			"EMODnetWFS R package %s CI https://github.com/EMODnet/EMODnetWFS",
  			version
  		)
  	)
  }

  gh_username <- try(whoami::gh_username(), silent = TRUE)
  if (!inherits(gh_username, "try-error") &&
  		gh_username %in% emodnetwfs_collaborators()) {
  	return(
  		sprintf(
  			"EMODnetWFS R package %s DEV https://github.com/EMODnet/EMODnetWFS",
  			version
  		)
  	)
  }

  sprintf(
  	"EMODnetWFS R package %s https://github.com/EMODnet/EMODnetWFS",
  	version
  )
}

globalVariables(c("layer_name", "n"))

release_bullets <- function() {
	c('update vignette with knitr::knit("vignettes/EMODnetWFS.Rmd.orig", output = "vignettes/EMODnetWFS.Rmd")')
}
