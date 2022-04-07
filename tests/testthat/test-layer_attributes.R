test_that("layer attributes stuff works", {
    skip_if_offline()
    wfs <- create_biology_wfs()
    with_mock_dir("biology-layers", {
        layer_attr <- layer_attributes_get_names(wfs, layer = "mediseh_zostera_m_pnt")
        layer_attr_desc <- layer_attribute_descriptions(wfs, layer = "mediseh_zostera_m_pnt")
        country <- layer_attribute_inspect(wfs, layer = "mediseh_zostera_m_pnt", attribute = "country")
        id <- layer_attribute_inspect(wfs, layer = "mediseh_zostera_m_pnt", attribute = "id")
        attr_summary <- layer_attributes_summarise(wfs, layer = "mediseh_zostera_m_pnt")
        crs1 <- get_layer_default_crs(layer = "mediseh_zostera_m_pnt", wfs, output = "epsg.text")
        crs2 <- get_layer_default_crs(layer = "mediseh_zostera_m_pnt", wfs, output = "epsg.num")
    })
    expect_equal(layer_attr, c("id", "country", "the_geom"))
    expect_snapshot_output(layer_attr_desc)
    expect_equal(class(country), c("tabyl", "data.frame"))
    expect_equal(names(country), c(".", "n", "percent"))
    expect_true(nrow(country) > 1)

    expect_equal(class(id), c("summaryDefault", "table"))
    expect_equal(names(id), c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max."))
    expect_length(id, 6L)

    expect_equal(class(attr_summary), "table")
    expect_equal(attr_summary[ , "  country"][2:3],
        structure(c("Class :character  ", "Mode  :character  "), .Names = c("",
            "")))
    expect_equal(attr_summary[ , 2][1],
        structure("Min.   :0  ", .Names = ""))


    expect_equal(crs1, "epsg:4326")
    expect_equal(crs2, 4326)
})

