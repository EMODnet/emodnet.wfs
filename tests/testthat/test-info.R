test_that("wfs info works from the server for a random service", {
    skip_if_offline()

    service_name <- sample(emodnet_wfs()$service_name, 1)
    info <- emodnet_get_wfs_info(
        service = service_name)

    expect_s3_class(info, class = c("tbl_df", "tbl", "data.frame"))
    expect_gt(nrow(info), 0)
    expect_setequal(unique(info$service_name), service_name)
})

test_that("wfs all info works", {
    skip_on_ci()
    skip_if_offline()
    all_info <- emodnet_get_all_wfs_info()
    expect_s3_class(all_info, class = c("tbl_df", "tbl", "data.frame"))
    expect_gt(nrow(all_info), 0)
    expect_setequal(unique(all_info$service_name), emodnet_wfs()$service_name)
})

test_that("wfs info works on wfs object", {
    wfs <- create_biology_wfs()
    with_mock_dir("biology-info", {
        layer_info_all <- emodnet_get_wfs_info(wfs)
    })

    expect_s3_class(layer_info_all, class = c("tbl_df", "tbl", "data.frame"))
    expect_gt(nrow(layer_info_all), 0)
    expect_equal(unique(layer_info_all$service_name), "biology")
    expect_equal(unique(layer_info_all$service_url), "https://geo.vliz.be/geoserver/Emodnetbio/wfs")
})

test_that("emodnet_get_layer_info works", {
    wfs <- create_biology_wfs()
    with_mock_dir("biology-info", {
        layers <- c("mediseh_zostera_m_pnt", "mediseh_cymodocea_pnt")
        layer_info_cml <- emodnet_get_layer_info(
            wfs = wfs,
            layers = layers
        )
    })
    expect_equal(nrow(layer_info_cml), 2)
    expect_setequal(layer_info_cml$layer_name, layers)
    expect_s3_class(layer_info_cml,
        class = c("tbl_df", "tbl", "data.frame"))
})
