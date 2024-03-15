wfs <- emodnet_init_wfs_client(service = "human_activities")

attr_desc <- layer_attribute_descriptions(wfs, layer = "maritimebnds")
testthis::use_testdata(attr_desc, overwrite = TRUE)


maritime_crs <- get_layer_default_crs(
  layer = "maritimebnds",
  wfs,
  output = "crs"
)
testthis::use_testdata(maritime_crs, overwrite = TRUE)
