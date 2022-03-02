test_that("layer_attributes_get_names works", {
    skip_if_offline()
    with_mock_dir("biology-attr", {
        wfs <- emodnet_init_wfs_client(service = "biology")
        layer_attr1 <- layer_attributes_get_names(wfs, layer = "mediseh_zostera_m_pnt")
        layer_attr2 <- layer_attributes_get_names(service = "biology", layer = "mediseh_zostera_m_pnt")
    })
    expect_equal(layer_attr1, c("id", "country", "the_geom"))
    expect_equal(layer_attr2, c("id", "country", "the_geom"))
})

test_that("layer_attribute_descriptions works", {
    skip_if_offline()
    with_mock_dir("biology-attr", {
        wfs <- emodnet_init_wfs_client(service = "biology")
        attr <- layer_attribute_descriptions(wfs, layer = "mediseh_zostera_m_pnt")
    })
    expect_snapshot_output(attr)
})

test_that("layer_attribute_inspect works", {
    skip_if_offline()
    with_mock_dir("biology-attr2", {
        wfs <- emodnet_init_wfs_client(service = "biology")
        country <- layer_attribute_inspect(wfs, layer = "mediseh_zostera_m_pnt", attribute = "country")
        id <- layer_attribute_inspect(wfs, layer = "mediseh_zostera_m_pnt", attribute = "id")
    })
    expect_equal(class(country), c("tabyl", "data.frame"))
    expect_equal(names(country), c(".", "n", "percent"))
    expect_true(nrow(country) > 1)

    expect_equal(class(id), c("summaryDefault", "table"))
    expect_equal(names(id), c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max."))
    expect_length(id, 6L)
})


test_that("layer_attributes_summarise works", {
    skip_if_offline()
    with_mock_dir("biology-attr3", {
        wfs <- emodnet_init_wfs_client(service = "biology")
        attrs <- layer_attributes_summarise(wfs, layer = "mediseh_zostera_m_pnt")
    })
    expect_equal(class(attrs), "table")
    expect_equal(attrs[ , "  country"][2:3],
        structure(c("Class :character  ", "Mode  :character  "), .Names = c("",
            "")))
    expect_equal(attrs[ , 2][1],
        structure("Min.   :0  ", .Names = ""))
})

test_that("get_default_crs works", {
    skip_if_offline()
    with_mock_dir("biology-crs", {
        wfs <- emodnet_init_wfs_client(service = "biology")
        crs1 <- get_layer_default_crs(layer = "mediseh_zostera_m_pnt", wfs, output = "epsg.text")
        crs2 <- get_layer_default_crs(layer = "mediseh_zostera_m_pnt", wfs, output = "epsg.num")
    })
    expect_equal(crs1, "epsg:4326")
    expect_equal(crs2, 4326)
})
