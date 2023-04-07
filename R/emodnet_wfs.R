emodnet_cache_file <- function() {
  cache_dir <- rappdirs::user_cache_dir("EMODnetWFS")
  if (!dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE)
  }

  getOption("emodnet.services.csv") %||%
    file.path(cache_dir, "services.csv")
}

.emodnet_wfs <- function() {
  cache_file <- emodnet_cache_file()
  # try reading from GitHub ----
  url <- getOption("emodnet.services.url") %||%
    "https://raw.githubusercontent.com/EMODnet/Web-Service-Documentation/salvadorf-use_readme_rmd/data/wfs.txt"
  services <- suppressWarnings(try(
    utils::read.delim(
      # TODO replace with main branch
      url, # nolint
      stringsAsFactors = FALSE
    ),
    silent = TRUE
  ))
  if (inherits(services, "try-error")) {
    ## use local cache ----
    if (!file.exists(cache_file)) {
      cli::cli_abort(
        c(
          "Can't find service URLs from GitHub nor local cache.",
          i = "Check {.url https://githubstatus.com},
					contact EMODnetWFS maintainer {.url https://github.com/EMODnet/EMODnetWFS}."
        )
      )
    }

    return(utils::read.csv(cache_file, stringsAsFactors = FALSE))
  }
  names(services) <- c("service_name", "Thematic", "service_url")

  create_name <- function(x, y) {
    if (y == "Data Products") {
      return(tolower(x))
    }
    snakecase::to_snake_case(paste(x, y, collapse = " "))
  }
  services[["service_name"]] <- purrr::map2_chr(
    services[["service_name"]], services[["Thematic"]],
    create_name
  )

  services[["service_url"]] <- sub("\\?.*", "", services[["service_url"]])

  # TODO explore this one
  services <- services[services[["service_name"]] != "biology_new_data_products",]
  # update local cache ----
  services <- services[, c("service_name", "service_url")]
  utils::write.csv(services, cache_file)

  return(services)
}
#' Available EMODnet Web Feature Services
#'
#' @return Tibble of available EMODnet Web Feature Services
#'
#' @examples
#' emodnet_wfs()
#' @export
emodnet_wfs <- memoise::memoise(.emodnet_wfs)
