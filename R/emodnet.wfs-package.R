#' @keywords internal
#' @importFrom lifecycle deprecated
#' @importFrom rlang .data `%||%`
"_PACKAGE"

## usethis namespace: start
#' @importFrom lifecycle deprecated
## usethis namespace: end
NULL

emodnetwfs_collaborators <- function() {
  readLines(system.file("collaborators.txt", package = "emodnet.wfs"))
}

emodnetwfs_user_agent <- function() {
  emodnetwfs_version <- as.character(utils::packageVersion("emodnet.wfs"))

  if (nzchar(Sys.getenv("EMODNETWFS_CI"))) {
    return(
      sprintf(
        "emodnet.wfs R package %s CI https://github.com/EMODnet/emodnet.wfs",
        emodnetwfs_version
      )
    )
  }

  gh_username <- try(whoami::gh_username(), silent = TRUE)
  if (
    !inherits(gh_username, "try-error") &&
      gh_username %in% emodnetwfs_collaborators()
  ) {
    return(
      sprintf(
        "emodnet.wfs R package %s DEV https://github.com/EMODnet/emodnet.wfs",
        emodnetwfs_version
      )
    )
  }

  sprintf(
    "emodnet.wfs R package %s https://github.com/EMODnet/emodnet.wfs",
    emodnetwfs_version
  )
}

utils::globalVariables(c("layer_name", "n"))

release_bullets <- function() {
  # nocov start
  # nolint start: line_length_linter
  c(
    'update vignette with knitr::knit("vignettes/emodnet.wfs.Rmd.orig", output = "vignettes/emodnet.wfs.Rmd")',
    'update article 1 with knitr::knit("vignettes/articles/request-params.Rmd.orig", output = "vignettes/articles/request-params.Rmd")',
    'update article 2 with knitr::knit("vignettes/articles/ecql_filtering.Rmd.orig", output = "vignettes/articles/ecql_filtering.Rmd")'
  )
  # nolint end
} # nocov end
