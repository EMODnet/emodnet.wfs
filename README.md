
<!-- README.md is generated from README.Rmd. Please edit that file -->

# emodnet.wfs: Access EMODnet Web Feature Service data through R

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-CMD-check](https://github.com/EMODnet/emodnet.wfs/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/EMODnet/emodnet.wfs/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/EMODnet/emodnet.wfs/branch/main/graph/badge.svg)](https://app.codecov.io/gh/EMODnet/emodnet.wfs/tree/main)
[![DOI](https://zenodo.org/badge/DOI/10.14284/679.svg)](https://doi.org/10.14284/679)
[![Status at rOpenSci Software Peer
Review](https://badges.ropensci.org/653_status.svg)](https://github.com/ropensci/software-review/issues/653)
[![Codecov test
coverage](https://codecov.io/gh/EMODnet/emodnet.wfs/graph/badge.svg)](https://app.codecov.io/gh/EMODnet/emodnet.wfs)
<!-- badges: end -->

The goal of emodnet.wfs is to allow interrogation of and access to
[EMODnet’s, European Marine Observation and Data Network, geographic
vector
data](https://emodnet.ec.europa.eu/en/emodnet-web-service-documentation#inline-nav-3)
in R through the [EMODnet Web Feature
Services](https://emodnet.ec.europa.eu/en/data-0). [Web Feature services
(WFS)](https://www.ogc.org/standards/wfs/) represent a change in the way
geographic information is created, modified and exchanged on the
Internet and offer direct fine-grained access to geographic information
at the feature and feature property level. Features are representation
of geographic entities, such as a coastlines, marine protected areas,
offshore platforms, or fishing areas. In WFS, features have geometry
(spatial information) and attributes (descriptive data). emodnet.wfs
aims at offering an user-friendly interface to this rich data.

## Installation and setup

You can install the development version of emodnet.wfs from the rOpenSci
R-universe with:

``` r
install.packages("emodnet.wfs", repos = c("https://ropensci.r-universe.dev", "https://cloud.r-project.org"))
```

Or from GitHub with:

``` r
# install.packages("pak")
pak::pak("EMODnet/emodnet.wfs")
```

If you want to avoid reading messages from emodnet.wfs such as “WFS
client created successfully”, set the `"emodnet.wfs.quiet"` option to
`TRUE`.

``` r
options("emodnet.wfs.quiet" = TRUE)
```

The use of the EMODnet Web Feature Services is not subjet to rate
limiting at the moment.

## Pre-requisites

The emodnet.wfs is designed to be compatible with the modern R
geospatial stack, in particular output geospatial objects are
[`sf`](https://r-spatial.github.io/sf/) objects, that is to say, a
tibble with a geometry list-column.

For users not familiar yet with geospatial data in R, we recommend the
following resources:

- [Spatial Data Science With Applications in
  R](https://r-spatial.org/book/) by Edzer Pebesma and Roger Bivand.

- [Geocomputation with R](https://r.geocompx.org/) by Robin Lovelace,
  Jakub Nowosad and Jannes Muenchow.

In the documentation we assume a basic familiarity with spatial data:
knowing about coordinates and about projections / [coordinate reference
systems (CRS)](https://r.geocompx.org/spatial-class#crs-intro).

## Available data sources (services)

All available data sources, called services, are contained in the
[tibble](https://tibble.tidyverse.org/) returned by `emodnet_wfs()`.

``` r
library(emodnet.wfs)
services <- emodnet_wfs()
class(services)
#> [1] "tbl_df"     "tbl"        "data.frame"
names(services)
#> [1] "emodnet_thematic_lot" "service_name"         "service_url"
services[, c("emodnet_thematic_lot", "service_name")]
#> # A tibble: 17 × 2
#>    emodnet_thematic_lot     service_name                                        
#>    <chr>                    <chr>                                               
#>  1 EMODnet Bathymetry       bathymetry                                          
#>  2 EMODnet Biology          biology                                             
#>  3 EMODnet Biology          biology_occurrence_data                             
#>  4 EMODnet Chemistry        chemistry_cdi_data_discovery_and_access_service     
#>  5 EMODnet Chemistry        chemistry_cdi_distribution_observations_per_categor…
#>  6 EMODnet Chemistry        chemistry_contaminants                              
#>  7 EMODnet Chemistry        chemistry_marine_litter                             
#>  8 EMODnet Geology          geology_coastal_behavior                            
#>  9 EMODnet Geology          geology_events_and_probabilities                    
#> 10 EMODnet Geology          geology_marine_minerals                             
#> 11 EMODnet Geology          geology_sea_floor_bedrock                           
#> 12 EMODnet Geology          geology_seabed_substrate_maps                       
#> 13 EMODnet Geology          geology_submerged_landscapes                        
#> 14 EMODnet Human Activities human_activities                                    
#> 15 EMODnet Physics          physics                                             
#> 16 EMODnet Seabed Habitats  seabed_habitats_general_datasets_and_products       
#> 17 EMODnet Seabed Habitats  seabed_habitats_individual_habitat_map_and_model_da…
```

EMODnet data covers several disciplines organized in 7 thematic lots:
bathymetry, biology, chemistry, geology, human activities, physics,
seabed habitats. Some thematic lots organize their data in more than one
data source or service.

To explore available services you can use `View()` or your usual way to
explore `data.frames`.

## Initialise a WFS Service Client

A WFS service client is responsible for sending requests to a WFS server
and processing the responses to retrieve, display, or analyze geospatial
features. As such, initialising a client is the first step to
interacting with an EMODnet Web Feature Services.

Specify the service using the `service` argument.

``` r
wfs_bio <- emodnet_init_wfs_client(service = "biology")
#> Loading ISO 19139 XML schemas...
#> Loading ISO 19115-3 XML schemas...
#> Loading ISO 19139 codelists...
#> ✔ WFS client created successfully
#> ℹ Service: "https://geo.vliz.be/geoserver/Emodnetbio/wfs"
#> ℹ Version: "2.0.0"

wfs_bio
#> <WFSClient>
#> ....|-- url: https://geo.vliz.be/geoserver/Emodnetbio/wfs
#> ....|-- version: 2.0.0
#> ....|-- capabilities <WFSCapabilities>
```

## List contents of a WFS: Get layer information from a service client

In the context of a Web Feature Service (WFS), a layer refers to a
logical grouping of geographic features that share the same schema
(i.e., the same feature type, geometry, and attributes). Layers are the
units of data that clients can query, retrieve, and manipulate through a
WFS.

You can access information (metadata) about each layer available from an
EMODnet WFS with `emodnet_get_wfs_info()`

``` r
emodnet_get_wfs_info(service = "biology")
#> ✔ WFS client created successfully
#> ℹ Service: "https://geo.vliz.be/geoserver/Emodnetbio/wfs"
#> ℹ Version: "2.0.0"
#> # A tibble: 39 × 9
#> # Rowwise: 
#>    data_source service_name service_url   layer_name title abstract class format
#>    <chr>       <chr>        <chr>         <chr>      <chr> <chr>    <chr> <chr> 
#>  1 emodnet_wfs biology      https://geo.… cti_macro… Comm… "Ocean … WFSF… sf    
#>  2 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Coral … WFSF… sf    
#>  3 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Coral … WFSF… sf    
#>  4 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Cymodo… WFSF… sf    
#>  5 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  6 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  7 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  8 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  9 emodnet_wfs biology      https://geo.… mediseh_h… EMOD… "Haloph… WFSF… sf    
#> 10 emodnet_wfs biology      https://geo.… mediseh_m… EMOD… "Maërl … WFSF… sf    
#> # ℹ 29 more rows
#> # ℹ 1 more variable: layer_namespace <chr>
```

or you can pass a wfs client object.

``` r
emodnet_get_wfs_info(wfs_bio)
#> # A tibble: 39 × 9
#> # Rowwise: 
#>    data_source service_name service_url   layer_name title abstract class format
#>    <chr>       <chr>        <chr>         <chr>      <chr> <chr>    <chr> <chr> 
#>  1 emodnet_wfs biology      https://geo.… cti_macro… Comm… "Ocean … WFSF… sf    
#>  2 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Coral … WFSF… sf    
#>  3 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Coral … WFSF… sf    
#>  4 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Cymodo… WFSF… sf    
#>  5 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  6 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  7 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  8 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  9 emodnet_wfs biology      https://geo.… mediseh_h… EMOD… "Haloph… WFSF… sf    
#> 10 emodnet_wfs biology      https://geo.… mediseh_m… EMOD… "Maërl … WFSF… sf    
#> # ℹ 29 more rows
#> # ℹ 1 more variable: layer_namespace <chr>
```

You can also get info for specific layers from wfs object:

``` r
layers <- c("mediseh_zostera_m_pnt", "mediseh_posidonia_nodata")

emodnet_get_layer_info(wfs = wfs_bio, layers = layers)
#> # A tibble: 2 × 9
#> # Rowwise: 
#>   data_source service_name    service_url layer_name title abstract class format
#>   <chr>       <chr>           <chr>       <chr>      <chr> <chr>    <chr> <chr> 
#> 1 emodnet_wfs https://geo.vl… biology     mediseh_p… EMOD… "Coastl… WFSF… sf    
#> 2 emodnet_wfs https://geo.vl… biology     mediseh_z… EMOD… "Zoster… WFSF… sf    
#> # ℹ 1 more variable: layer_namespace <chr>
```

Finally, you can get details on all available services and layers from
the server

``` r
emodnet_get_all_wfs_info()
```

## Get data from a data source: get layers

You can extract layers directly from a `wfs` object using layer names.
All layers are downloaded as `sf` objects and output as a list with a
named element for each layer requested. The argument `simplify = TRUE`
stack all the layers in one single tibble, if possible (for instance if
all column names are the same, otherwise it fails).

By default, `emodnet_get_layers()` returns a list of sf objects, one per
layer.

``` r
emodnet_get_layers(wfs = wfs_bio, layers = layers)
#> $mediseh_zostera_m_pnt
#> Simple feature collection with 54 features and 3 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -4.167154 ymin: 33.07783 xmax: 15.35766 ymax: 45.72451
#> Geodetic CRS:  WGS 84
#> First 10 features:
#>                      gml_id id country                   the_geom
#> 1   mediseh_zostera_m_pnt.1  0  Spagna  POINT (-2.61314 36.71681)
#> 2   mediseh_zostera_m_pnt.2  0  Spagna POINT (-3.846598 36.75127)
#> 3   mediseh_zostera_m_pnt.3  0  Spagna POINT (-3.957785 36.72266)
#> 4   mediseh_zostera_m_pnt.4  0  Spagna POINT (-4.039712 36.74217)
#> 5   mediseh_zostera_m_pnt.5  0  Spagna POINT (-4.100182 36.72331)
#> 6   mediseh_zostera_m_pnt.6  0  Spagna POINT (-4.167154 36.71226)
#> 7   mediseh_zostera_m_pnt.7  0  Spagna POINT (-1.268366 37.55796)
#> 8   mediseh_zostera_m_pnt.8  0 Francia   POINT (4.84864 43.37637)
#> 9   mediseh_zostera_m_pnt.9  0  Italia  POINT (13.71831 45.70017)
#> 10 mediseh_zostera_m_pnt.10  0  Italia  POINT (13.16378 45.72451)
#> 
#> $mediseh_posidonia_nodata
#> Simple feature collection with 465 features and 3 fields
#> Geometry type: MULTICURVE
#> Dimension:     XY
#> Bounding box:  xmin: -2.1798 ymin: 30.26623 xmax: 34.60767 ymax: 45.47668
#> Geodetic CRS:  WGS 84
#> First 10 features:
#>                         gml_id id         km                       the_geom
#> 1   mediseh_posidonia_nodata.1  0 291.503233 MULTICURVE (LINESTRING (27....
#> 2   mediseh_posidonia_nodata.2  0  75.379502 MULTICURVE (LINESTRING (23....
#> 3   mediseh_posidonia_nodata.3  0  38.627764 MULTICURVE (LINESTRING (22....
#> 4   mediseh_posidonia_nodata.4  0 110.344802 MULTICURVE (LINESTRING (19....
#> 5  mediseh_posidonia_nodata.13  0  66.997461 MULTICURVE (LINESTRING (9.1...
#> 6  mediseh_posidonia_nodata.14  0  18.090640 MULTICURVE (LINESTRING (9.7...
#> 7  mediseh_posidonia_nodata.15  0  16.618978 MULTICURVE (LINESTRING (9.8...
#> 8  mediseh_posidonia_nodata.16  0   1.913773 MULTICURVE (LINESTRING (10....
#> 9  mediseh_posidonia_nodata.83  0   2.173447 MULTICURVE (LINESTRING (15....
#> 10 mediseh_posidonia_nodata.84  0   2.817453 MULTICURVE (LINESTRING (15....
```

You can change the output Coordinate Reference System (CRS), which
defines how geographic data is mapped to the Earth’s surface, through
the argument `crs`.

``` r
emodnet_get_layers(wfs = wfs_bio, layers = layers, crs = 3857)
#> ℹ crs transformed to 3857.
#> ℹ crs transformed to 3857.
#> $mediseh_zostera_m_pnt
#> Simple feature collection with 54 features and 3 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -463885.4 ymin: 3905639 xmax: 1709607 ymax: 5736311
#> Projected CRS: WGS 84 / Pseudo-Mercator
#> First 10 features:
#>                      gml_id id country                  the_geom
#> 1   mediseh_zostera_m_pnt.1  0  Spagna POINT (-290893.4 4399707)
#> 2   mediseh_zostera_m_pnt.2  0  Spagna POINT (-428201.3 4404494)
#> 3   mediseh_zostera_m_pnt.3  0  Spagna POINT (-440578.6 4400520)
#> 4   mediseh_zostera_m_pnt.4  0  Spagna POINT (-449698.6 4403229)
#> 5   mediseh_zostera_m_pnt.5  0  Spagna POINT (-456430.1 4400610)
#> 6   mediseh_zostera_m_pnt.6  0  Spagna POINT (-463885.4 4399075)
#> 7   mediseh_zostera_m_pnt.7  0  Spagna POINT (-141193.9 4517168)
#> 8   mediseh_zostera_m_pnt.8  0 Francia  POINT (539748.1 5369436)
#> 9   mediseh_zostera_m_pnt.9  0  Italia   POINT (1527115 5732431)
#> 10 mediseh_zostera_m_pnt.10  0  Italia   POINT (1465385 5736311)
#> 
#> $mediseh_posidonia_nodata
#> Simple feature collection with 465 features and 3 fields
#> Geometry type: MULTICURVE
#> Dimension:     XY
#> Bounding box:  xmin: -242654.3 ymin: 3537818 xmax: 3852508 ymax: 5696879
#> Projected CRS: WGS 84 / Pseudo-Mercator
#> First 10 features:
#>                         gml_id id         km                       the_geom
#> 1   mediseh_posidonia_nodata.1  0 291.503233 MULTICURVE (LINESTRING (302...
#> 2   mediseh_posidonia_nodata.2  0  75.379502 MULTICURVE (LINESTRING (257...
#> 3   mediseh_posidonia_nodata.3  0  38.627764 MULTICURVE (LINESTRING (246...
#> 4   mediseh_posidonia_nodata.4  0 110.344802 MULTICURVE (LINESTRING (221...
#> 5  mediseh_posidonia_nodata.13  0  66.997461 MULTICURVE (LINESTRING (101...
#> 6  mediseh_posidonia_nodata.14  0  18.090640 MULTICURVE (LINESTRING (108...
#> 7  mediseh_posidonia_nodata.15  0  16.618978 MULTICURVE (LINESTRING (110...
#> 8  mediseh_posidonia_nodata.16  0   1.913773 MULTICURVE (LINESTRING (121...
#> 9  mediseh_posidonia_nodata.83  0   2.173447 MULTICURVE (LINESTRING (169...
#> 10 mediseh_posidonia_nodata.84  0   2.817453 MULTICURVE (LINESTRING (169...
```

You can also extract layers using a WFS service name.

``` r
emodnet_get_layers(
  service = "biology",
  layers = c("mediseh_zostera_m_pnt", "mediseh_posidonia_nodata")
)
#> ✔ WFS client created successfully
#> ℹ Service: "https://geo.vliz.be/geoserver/Emodnetbio/wfs"
#> ℹ Version: "2.0.0"
#> $mediseh_zostera_m_pnt
#> Simple feature collection with 54 features and 3 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -4.167154 ymin: 33.07783 xmax: 15.35766 ymax: 45.72451
#> Geodetic CRS:  WGS 84
#> First 10 features:
#>                      gml_id id country                   the_geom
#> 1   mediseh_zostera_m_pnt.1  0  Spagna  POINT (-2.61314 36.71681)
#> 2   mediseh_zostera_m_pnt.2  0  Spagna POINT (-3.846598 36.75127)
#> 3   mediseh_zostera_m_pnt.3  0  Spagna POINT (-3.957785 36.72266)
#> 4   mediseh_zostera_m_pnt.4  0  Spagna POINT (-4.039712 36.74217)
#> 5   mediseh_zostera_m_pnt.5  0  Spagna POINT (-4.100182 36.72331)
#> 6   mediseh_zostera_m_pnt.6  0  Spagna POINT (-4.167154 36.71226)
#> 7   mediseh_zostera_m_pnt.7  0  Spagna POINT (-1.268366 37.55796)
#> 8   mediseh_zostera_m_pnt.8  0 Francia   POINT (4.84864 43.37637)
#> 9   mediseh_zostera_m_pnt.9  0  Italia  POINT (13.71831 45.70017)
#> 10 mediseh_zostera_m_pnt.10  0  Italia  POINT (13.16378 45.72451)
#> 
#> $mediseh_posidonia_nodata
#> Simple feature collection with 465 features and 3 fields
#> Geometry type: MULTICURVE
#> Dimension:     XY
#> Bounding box:  xmin: -2.1798 ymin: 30.26623 xmax: 34.60767 ymax: 45.47668
#> Geodetic CRS:  WGS 84
#> First 10 features:
#>                         gml_id id         km                       the_geom
#> 1   mediseh_posidonia_nodata.1  0 291.503233 MULTICURVE (LINESTRING (27....
#> 2   mediseh_posidonia_nodata.2  0  75.379502 MULTICURVE (LINESTRING (23....
#> 3   mediseh_posidonia_nodata.3  0  38.627764 MULTICURVE (LINESTRING (22....
#> 4   mediseh_posidonia_nodata.4  0 110.344802 MULTICURVE (LINESTRING (19....
#> 5  mediseh_posidonia_nodata.13  0  66.997461 MULTICURVE (LINESTRING (9.1...
#> 6  mediseh_posidonia_nodata.14  0  18.090640 MULTICURVE (LINESTRING (9.7...
#> 7  mediseh_posidonia_nodata.15  0  16.618978 MULTICURVE (LINESTRING (9.8...
#> 8  mediseh_posidonia_nodata.16  0   1.913773 MULTICURVE (LINESTRING (10....
#> 9  mediseh_posidonia_nodata.83  0   2.173447 MULTICURVE (LINESTRING (15....
#> 10 mediseh_posidonia_nodata.84  0   2.817453 MULTICURVE (LINESTRING (15....
```

Layers can also be returned to a single `sf` object through argument
`simplify`.  
If `TRUE` the function will try to reduce all layers into a single `sf`.

If attempting to reduce fails, it will error:

``` r
emodnet_get_layers(
  wfs = wfs_bio,
  layers = layers,
  simplify = TRUE
)
#> Error in `value[[3L]]()`:
#> ! Cannot reduce layers.
#> ℹ Try again with `simplify = FALSE`
```

Using `simplify = TRUE` is also useful for returning an `sf` object
rather than a list in single layer request.

``` r
emodnet_get_layers(
  service = "biology",
  layers = c("mediseh_posidonia_nodata"),
  simplify = TRUE
)
#> ✔ WFS client created successfully
#> ℹ Service: "https://geo.vliz.be/geoserver/Emodnetbio/wfs"
#> ℹ Version: "2.0.0"
#> Simple feature collection with 465 features and 3 fields
#> Geometry type: MULTICURVE
#> Dimension:     XY
#> Bounding box:  xmin: -2.1798 ymin: 30.26623 xmax: 34.60767 ymax: 45.47668
#> Geodetic CRS:  WGS 84
#> First 10 features:
#>                         gml_id id         km                       the_geom
#> 1   mediseh_posidonia_nodata.1  0 291.503233 MULTICURVE (LINESTRING (27....
#> 2   mediseh_posidonia_nodata.2  0  75.379502 MULTICURVE (LINESTRING (23....
#> 3   mediseh_posidonia_nodata.3  0  38.627764 MULTICURVE (LINESTRING (22....
#> 4   mediseh_posidonia_nodata.4  0 110.344802 MULTICURVE (LINESTRING (19....
#> 5  mediseh_posidonia_nodata.13  0  66.997461 MULTICURVE (LINESTRING (9.1...
#> 6  mediseh_posidonia_nodata.14  0  18.090640 MULTICURVE (LINESTRING (9.7...
#> 7  mediseh_posidonia_nodata.15  0  16.618978 MULTICURVE (LINESTRING (9.8...
#> 8  mediseh_posidonia_nodata.16  0   1.913773 MULTICURVE (LINESTRING (10....
#> 9  mediseh_posidonia_nodata.83  0   2.173447 MULTICURVE (LINESTRING (15....
#> 10 mediseh_posidonia_nodata.84  0   2.817453 MULTICURVE (LINESTRING (15....
```

## Help needed?

If you get an unexpected error,

- Look up the [EMODnet
  monitor](https://monitor.emodnet.eu/resources?lang=en&resource_type=OGC:WFS);
- Open an issue in this
  [repository](https://github.com/EMODnet/emodnet.wfs/issues).

## Unlock the Full Potential of the EMODnet Web Services: Access Raster and Gridded datasets.

EMODnet hosts a wealth of marine and maritime data distributed through
three complementary web services: WFS, WCS, and ERDDAP. Web services
allow users to retrieve data programmatically from remote servers,
eliminating the need for manual downloads. This is particularly useful
for handling large datasets or conducting dynamic analyses. These
services are tailored to different data types and research needs, but
together, they ensure seamless access to all EMODnet vector, raster, and
gridded datasets. Vector data, such as shipwrecks or boundaries, are
accessible through `emodnet.wfs` via Web Feature Services (WFS).
Complementary, raster and gridded datasets are available through Web
Coverage Services (WCS) and ERDDAP respectively.

### Access EMODnet raster data through Web Coverage Services with `emodnet.wcs` in R

EMODnet raster datasets, such as habitat maps or bathymetry, are
available through [Web Coverage Services
(WCS)](https://en.wikipedia.org/wiki/Web_Coverage_Service). These data
are continuous, gridded, and often used for spatial visualization or
environmental modeling. The emodnet.wcs R package provides tools to
retrieve and process these raser datasets, in a similar fashion as
`emodnet.wfs`. Extensive documentation is available at the [emodnet.wcs
website](https://emodnet.github.io/emodnet.wcs/).

### Access EMODnet gridded and tabular datasets through the ERDDAP Server and `rerddap` in R

Both WFS and WCS EMODnet services are based on a federated system: each
EMODnet thematic lot manages their servers and data, ensuring that their
data are exposed both via WFS and WCS. The twin R packages `emodnet.wfs`
and `emodnet.wcs` simplify the access to all the entry points by
collecting them in single places, which are the packages themselves.

In contrast, the [EMODnet ERDDAP Server](https://erddap.emodnet.eu) is
centrally managed by the EMODnet Central Portal, offering a single
access point to all gridded and tabular datasets. ERDDAP simplifies
access to datasets such as digital terrain models, vessel density or
environmental data. It is particularly suited for large-scale,
multidimensional data analysis. In R, the `rerddap` package allows users
to query and subset ERDDAP data programmatically, enabling efficient
analysis and integration into workflows. For example, researchers can
retrieve datasets on vessel density.

``` r
# install.packages("rerrdap")
library(rerddap)
#> Registered S3 method overwritten by 'hoardr':
#>   method           from
#>   print.cache_info httr

# This is the url where the EMODnet ERDDAP server is located
erddap_url <- "https://erddap.emodnet.eu/erddap/"

# Inspect all available datasets
ed_datasets(url = erddap_url)
#> # A tibble: 8 × 16
#>   griddap Subset tabledap Make.A.Graph wms   files Title Summary FGDC  ISO.19115
#>   <chr>   <chr>  <chr>    <chr>        <chr> <chr> <chr> <chr>   <chr> <chr>    
#> 1 ""      "/erd… /erddap… /erddap/tab… ""    ""    * Th… "This … ""    ""       
#> 2 ""      ""     /erddap… /erddap/tab… ""    "/er… EMOD… "The d… ""    ""       
#> 3 ""      ""     /erddap… /erddap/tab… ""    "/er… EMOD… "The d… ""    ""       
#> 4 ""      "/erd… /erddap… /erddap/tab… ""    "/er… EMOD… "The d… "/er… "/erddap…
#> 5 ""      ""     /erddap… /erddap/tab… ""    "/er… Pres… "The p… "/er… "/erddap…
#> 6 ""      ""     /erddap… /erddap/tab… ""    ""    PSMS… "Perma… ""    ""       
#> 7 ""      ""     /erddap… /erddap/tab… ""    "/er… PSMS… "Perma… ""    ""       
#> 8 ""      "/erd… /erddap… /erddap/tab… ""    "/er… TAO/… "This … "/er… "/erddap…
#> # ℹ 6 more variables: Info <chr>, Background.Info <chr>, RSS <chr>,
#> #   Email <chr>, Institution <chr>, Dataset.ID <chr>

# Find datasets with the key words "vessel density"
ed_search(query = "vessel density", url = erddap_url)
#> # A tibble: 16 × 2
#>    title                                                     dataset_id         
#>    <chr>                                                     <chr>              
#>  1 Vessel Density                                            humanactivities_9f…
#>  2 Vessel Density                                            humanactivities_e9…
#>  3 Vessel traffic density, 2019, All                         EMODPACE_VD_All    
#>  4 Vessel traffic density, 2019, Cargo                       EMODPACE_VD_09_Car…
#>  5 Vessel traffic density, 2019, Dredging or underwater ops  EMODPACE_VD_03_Dre…
#>  6 Vessel traffic density, 2019, Fishing                     EMODPACE_VD_01_Fis…
#>  7 Vessel traffic density, 2019, High Speed craft            EMODPACE_VD_06_High
#>  8 Vessel traffic density, 2019, Miliary and law enforcement EMODPACE_VD_11_Mil…
#>  9 Vessel traffic density, 2019, Other                       EMODPACE_VD_00_Oth…
#> 10 Vessel traffic density, 2019, Passenger                   EMODPACE_VD_08_Pas…
#> 11 Vessel traffic density, 2019, Pleasure craft              EMODPACE_VD_05_Ple…
#> 12 Vessel traffic density, 2019, Sailing                     EMODPACE_VD_04_Sai…
#> 13 Vessel traffic density, 2019, Service                     EMODPACE_VD_02_Ser…
#> 14 Vessel traffic density, 2019, Tanker                      EMODPACE_VD_10_Tan…
#> 15 Vessel traffic density, 2019, Tug and Towing              EMODPACE_VD_07_Tug 
#> 16 Vessel traffic density, 2019, Unknown                     EMODPACE_VD_12_Unk…

# Inspect more info about the vessel density dataset, using its identifier
human_activities_data_info <- info(
  datasetid = "humanactivities_9f8a_3389_f08a",
  url = erddap_url
)
human_activities_data_info
#> <ERDDAP info> humanactivities_9f8a_3389_f08a 
#>  Base URL: https://erddap.emodnet.eu/erddap 
#>  Dataset Type: griddap 
#>  Dimensions (range):  
#>      time: (2017-01-01T00:00:00Z, 2021-12-01T00:00:00Z) 
#>      y: (604500.0, 7034500.0) 
#>      x: (-622500.0, 6884500.0) 
#>  Variables:  
#>      vd: 
#>          Units: seconds

# Retrieve the vessel density at a particular time period
year_2020_gridded_data <- griddap(
  datasetx = human_activities_data_info,
  time = c("2020-03-18", "2020-03-19")
)
#> info() output passed to x; setting base url to: https://erddap.emodnet.eu/erddap
head(year_2020_gridded_data$data)
#>         x       y                 time vd
#> 1 -622500 7034500 2020-04-01T00:00:00Z NA
#> 2 -621500 7034500 2020-04-01T00:00:00Z NA
#> 3 -620500 7034500 2020-04-01T00:00:00Z NA
#> 4 -619500 7034500 2020-04-01T00:00:00Z NA
#> 5 -618500 7034500 2020-04-01T00:00:00Z NA
#> 6 -617500 7034500 2020-04-01T00:00:00Z NA
```

More functionalities are available through `rerddap`. Feel free to
explore the [rerddap website](https://docs.ropensci.org/rerddap/) to
find out what else can you do with the EMODnet datasets in ERDDAP.

## Citation

To cite emodnet.wfs, please use the output from
`citation(package = "emodnet.wfs")`.

``` r
citation(package = "emodnet.wfs")
#> To cite package 'emodnet.wfs' in publications use:
#> 
#>   Krystalli A, Fernández-Bejarano S, Salmon M (????). _emodnet.wfs:
#>   Access EMODnet Web Feature Service data through R_. doi:10.14284/679
#>   <https://doi.org/10.14284/679>, R package version 2.0.2.9000.
#>   Integrated data products created under the European Marine
#>   Observation Data Network (EMODnet) Biology project
#>   (EASME/EMFF/2017/1.3.1.2/02/SI2.789013), funded by the by the
#>   European Union under Regulation (EU) No 508/2014 of the European
#>   Parliament and of the Council of 15 May 2014 on the European Maritime
#>   and Fisheries Fund, <https://github.com/EMODnet/emodnet.wfs>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {{emodnet.wfs}: Access EMODnet Web Feature Service data through R},
#>     author = {Anna Krystalli and Salvador Fernández-Bejarano and Maëlle Salmon},
#>     note = {R package version 2.0.2.9000. Integrated data products created under the European Marine Observation Data Network (EMODnet) Biology project (EASME/EMFF/2017/1.3.1.2/02/SI2.789013), funded by the by the European Union under Regulation (EU) No 508/2014 of the European Parliament and of the Council of 15 May 2014 on the European Maritime and Fisheries Fund},
#>     url = {https://github.com/EMODnet/emodnet.wfs},
#>     doi = {10.14284/679},
#>   }
```

## Acknowledgements

This package was started by the Sheffield University during the EMODnet
Biology WP4 data products workshop in June 2020.
