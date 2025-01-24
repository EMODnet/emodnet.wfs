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
    version <- as.character(utils::packageVersion("emodnet.wfs"))

    if (nzchar(Sys.getenv("EMODNETWFS_CI"))) {
        return(
            utils::URLencode(
                sprintf(
                    "emodnet.wfs R package %s CI https://github.com/EMODnet/emodnet.wfs",
                    version
                )
            )
        )
    }

    gh_username <- try(whoami::gh_username(), silent = TRUE)
    if (!inherits(gh_username, "try-error") &&
        gh_username %in% emodnetwfs_collaborators()) {
        return(
            utils::URLencode(
                sprintf(
                    "emodnet.wfs R package %s DEV https://github.com/EMODnet/emodnet.wfs",
                    version
                )
            )
        )
    }

    utils::URLencode(
        sprintf(
            "emodnet.wfs R package %s https://github.com/EMODnet/emodnet.wfs",
            version
        )
    )
}


utils::globalVariables(c("layer_name", "n"))

release_bullets <- function() { # nocov start
  c('update vignette with knitr::knit("vignettes/emodnet.wfs.Rmd.orig", output = "vignettes/emodnet.wfs.Rmd")') # nolint: line_length_linter
} # nocov end
