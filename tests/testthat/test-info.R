test_that("wfs info works from the server for a random service", {
    service_name <- sample(emodnet_wfs$service_name, 1)
    info <- emodnet_get_wfs_info(
        service = service_name)

    expect_s3_class(info,
                    class = c("tbl_df", "tbl", "data.frame"))
    expect_gt(nrow(info), 0)
    expect_setequal(unique(info$service_name), service_name)
})

test_that("wfs all info works", {
    skip_on_ci()
    all_info <- emodnet_get_all_wfs_info()
    expect_s3_class(all_info,
                    class = c("tbl_df", "tbl", "data.frame"))
    expect_gt(nrow(all_info), 0)
    expect_setequal(unique(all_info$service_name), emodnet_wfs$service_name)
})

wfs_cml <- emodnet_init_wfs_client("chemistry_marine_litter")

test_that("wfs info works on wfs object", {
    layer_info_all <- emodnet_get_wfs_info(wfs_cml)
    expect_s3_class(layer_info_all,
                    class = c("tbl_df", "tbl", "data.frame"))
    expect_gt(nrow(layer_info_all), 0)
})


test_that("emodnet_get_layer_info works", {
    layers <- c("bl_fishing_cleaning",
               "bl_beacheslocations_2001_2008_monitoring")
    layer_info_cml <-emodnet_get_layer_info(
        wfs = wfs_cml,
        layers = layers
    )
    expect_equal(nrow(layer_info_cml), 2)
    expect_setequal(layer_info_cml$layer_name, layers)
    expect_s3_class(layer_info_cml,
                    class = c("tbl_df", "tbl", "data.frame"))
})


