should_run_example <- function() {
    identical(Sys.getenv("IN_PKGDOWN"), "true") || interactive()
}
