test_that("layer attributes stuff works", {
  skip_if_offline()
  wfs <- create_biology_wfs()

  with_mock_dir("biology-layers", {
    layer_attr <- layer_attributes_get_names(
      wfs,
      layer = "mediseh_zostera_m_pnt"
    )
    expect_identical(layer_attr, c("id", "country", "the_geom"))

    layer_attr_desc <- layer_attribute_descriptions(
      wfs,
      layer = "mediseh_zostera_m_pnt"
    )
    expect_snapshot_output(layer_attr_desc)

    country <- layer_attribute_inspect(
      wfs,
      layer = "mediseh_zostera_m_pnt",
      attribute = "country"
    )
    expect_s3_class(country, c("tabyl", "data.frame"))
    expect_named(country, c(".", "n", "percent"))
    expect_gt(nrow(country), 1L)

    the_geom <- layer_attribute_inspect(
      wfs,
      layer = "mediseh_zostera_m_pnt",
      attribute = "the_geom"
    )
    expect_s3_class(the_geom, c("sfc_POINT", "sfc"))

    id <- layer_attribute_inspect(
      wfs,
      layer = "mediseh_zostera_m_pnt",
      attribute = "id"
    )
    expect_s3_class(id, c("summaryDefault", "table"))
    expect_named(id, c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max."))
    expect_length(id, 6L)

    attr_summary <- layer_attributes_summarise(
      wfs,
      layer = "mediseh_zostera_m_pnt"
    )

    expect_s3_class(attr_summary, "table")
    expect_identical(
      attr_summary[, "  country"][2:3],
      # nolint start: undesirable_function_linter
      structure(
        # nolint end
        c("Class :character  ", "Mode  :character  "),
        .Names = c(
          "",
          ""
        )
      )
    )
    expect_identical(
      attr_summary[, 2][1],
      structure("Min.   :0  ", .Names = "") # nolint: undesirable_function_linter
    )

    crs1 <- get_layer_default_crs(
      layer = "mediseh_zostera_m_pnt",
      wfs,
      output = "epsg.text"
    )
    expect_identical(crs1, "epsg:4326")

    crs2 <- get_layer_default_crs(
      layer = "mediseh_zostera_m_pnt",
      wfs,
      output = "epsg.num"
    )
  })
  expect_identical(crs2, 4326)

  crs3 <- get_layer_default_crs(
    layer = "mediseh_zostera_m_pnt",
    wfs,
    output = "crs"
  )
  expect_s3_class(crs3, "crs")
})
