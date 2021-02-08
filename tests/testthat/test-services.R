test_that("Service bathymetry works", {
    emodnet_init_wfs_client(service = "bathymetry")
})

test_that("Service biology works", {
    emodnet_init_wfs_client(service = "biology")
})

test_that("Service biology_occurrence_data works", {
    emodnet_init_wfs_client(service = "biology_occurrence_data")
})

test_that("Service chemistry_cdi_data_discovery_and_access_service works", {
    emodnet_init_wfs_client(service = "chemistry_cdi_data_discovery_and_access_service")
})

test_that("Service chemistry_cdi_distribution_observations_per_category_and_region works", {
    emodnet_init_wfs_client(service = "chemistry_cdi_distribution_observations_per_category_and_region")
})

test_that("Service chemistry_contaminants works", {
    emodnet_init_wfs_client(service = "chemistry_contaminants")
})

test_that("Service chemistry_marine_litter works", {
    emodnet_init_wfs_client(service = "chemistry_marine_litter")
})

test_that("Service geology_sea_floor_bedrock works", {
    emodnet_init_wfs_client(service = "geology_sea_floor_bedrock")
})

test_that("Service geology_marine_minerals works", {
    emodnet_init_wfs_client(service = "geology_marine_minerals")
})

test_that("Service geology_seabed_substrate_maps works", {
    emodnet_init_wfs_client(service = "geology_seabed_substrate_maps")
})

test_that("Service geology_events_and_probabilities works", {
    emodnet_init_wfs_client(service = "geology_events_and_probabilities")
})

test_that("Service geology_coastal_behavior works", {
    emodnet_init_wfs_client(service = "geology_coastal_behavior")
})

test_that("Service geology_submerged_landscapes works", {
    emodnet_init_wfs_client(service = "geology_submerged_landscapes")
})

test_that("Service human_activities works", {
    emodnet_init_wfs_client(service = "human_activities")
})

test_that("Service physics works", {
    emodnet_init_wfs_client(service = "physics")
})

test_that("Service seabed_habitats_general_datasets_and_products works", {
    emodnet_init_wfs_client(service = "seabed_habitats_general_datasets_and_products")
})

test_that("Service seabed_habitats_individual_habitat_map_and_model_datasets works", {
    emodnet_init_wfs_client(service = "seabed_habitats_individual_habitat_map_and_model_datasets")
})
