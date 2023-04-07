.emodnet_wfs <- function() {
  cache_dir <- rappdirs::user_cache_dir("EMODnetWFS")
  cache_file <- file.path(cache_dir, "services.csv")
  if (!dir.exists(cache_dir)) {
  	dir.create(cache_dir, recursive = TRUE)
  }
  # try reading from GitHub ----
  services <- try(
  	utils::read.delim(
  	# TODO replace with main branch
  	"https://raw.githubusercontent.com/EMODnet/Web-Service-Documentation/salvadorf-use_readme_rmd/data/wfs.txt", # nolint
    stringsAsFactors = FALSE
  	),
  	silent = TRUE
  )
  if (inherits(services, "try-error")) {
  	## use local cache ----
  	if (!file.exits(cache_file)) {
  		cli::cli_abort("Can't find service URLs from GitHub nor local cache.",
  			i = "Check https://githubstatus.com, contact EMODnetWFS maintainer.")
  	}
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

  services[["service_url"]] <- sprintf(
  	"%s://%s/",
  	urltools::scheme(services[["service_url"]]),
  	urltools::domain(services[["service_url"]])
  )

  # update local cache ----
  services <- services[,c("service_name", "service_url")]
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
