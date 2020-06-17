test_that("wfs info works for all services", {
    l_info <- purrr::map(emodnet_wfs$service_name,
                         ~try(emodnet_get_wfs_info(service = .x)))

    info_classes <- purrr::map(l_info, class) %>% unique() %>% unlist()
    expect_setequal(info_classes, c("tbl_df", "tbl", "data.frame"))
})


test_that("emodnet_get_layer_info works", {
    wfs_cml <- emodnet_init_wfs_client("chemistry_marine_litter")
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


