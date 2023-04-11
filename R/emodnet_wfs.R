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
    name <- snakecase::to_snake_case(paste(x, y, collapse = " "))
    if (name == "human_activities_data_and_data_products") {
    	name = "human_activities"
    }
    return(name)
  }
  services[["service_name"]] <- purrr::map2_chr(
    services[["service_name"]], services[["Thematic"]],
    create_name
  )

  services[["service_url"]] <- sub("\\?.*", "", services[["service_url"]])


  # TODO explore this one
  services <- services[services[["service_name"]] %in% curated_services(),]
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

curated_services <- function() {
  c(
    "bathymetry",
    "biology",
    "biology_occurrence_data",
    "chemistry_litter",
    "chemistry_contaminants",
    "chemistry_cdi_data_discovery_and_access_service",
    "chemistry_distribution_of_cdi_observations_per_data_category_p_36_and_msfd_sea_regions",
    "geology_sea_floor_bedrock",
    "geology_marine_minerals", "geology_seabed_substrate_maps",
    "geology_events_and_probabilities",
    "geology_coastal_behaviour",
    "geology_submerged_landscapes",
    "geology_index_of_borehole_and_geophysics_data",
    "human_activities",
    "physics_data_and_data_products",
    "seabed_habitats_general_datasets_and_products",
    "seabed_habitats_individual_habitat_map_and_model_datasets"
  )
}
