test_that("wfs info works for all services", {
    l_info <- purrr::map(emodnet_wfs$service_name,
                         ~try(emodnet_get_wfs_info(service = .x)))

    info_classes <- purrr::map(l_info, class) %>% unique() %>% unlist()
    expect_setequal(info_classes, c("tbl_df", "tbl", "data.frame"))
})
