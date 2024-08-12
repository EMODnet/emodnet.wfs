
<!-- README.md is generated from README.Rmd. Please edit that file -->

# emodnet.wfs: Access EMODnet Web Feature Service data through R

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R build
status](https://github.com/EMODnet/emodnet.wfs/workflows/R-CMD-check/badge.svg)](https://github.com/EMODnet/emodnet.wfs/actions)
[![Codecov test
coverage](https://codecov.io/gh/EMODnet/emodnet.wfs/branch/main/graph/badge.svg)](https://app.codecov.io/gh/EMODnet/emodnet.wfs/tree/main)
<!-- badges: end -->

The goal of emodnet.wfs is to allow interrogation of and access to
[EMODnet’s, European Marine Observation and Data Network, geographic
vector
data](https://emodnet.ec.europa.eu/en/emodnet-web-service-documentation#inline-nav-3)
in R though the [EMODnet Web Feature
Services](https://emodnet.ec.europa.eu/en/data). [Web Feature services
(WFS)](https://www.ogc.org/standard/wfs/) represent a change in the way
geographic information is created, modified and exchanged on the
Internet and offer direct fine-grained access to geographic information
at the feature and feature property level. emodnet.wfs aims at offering
an user-friendly interface to this rich data.

## Installation and setup

You can install the development version of emodnet.wfs from GitHub with:

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

## Available services

All available services are contained in the tibble returned by
`emodnet_wfs()`.

| service_name                                                    | service_url                                                                   |
|:----------------------------------------------------------------|:------------------------------------------------------------------------------|
| bathymetry                                                      | <https://ows.emodnet-bathymetry.eu/wfs>                                       |
| biology                                                         | <https://geo.vliz.be/geoserver/Emodnetbio/wfs>                                |
| biology_occurrence_data                                         | <https://geo.vliz.be/geoserver/Dataportal/wfs>                                |
| chemistry_cdi_data_discovery_and_access_service                 | <https://geo-service.maris.nl/emodnet_chemistry/wfs>                          |
| chemistry_cdi_distribution_observations_per_category_and_region | <https://geo-service.maris.nl/emodnet_chemistry_p36/wfs>                      |
| chemistry_contaminants                                          | <https://geoserver.hcmr.gr/geoserver/EMODNET_SHARED/wfs>                      |
| chemistry_marine_litter                                         | <https://www.ifremer.fr/services/wfs/emodnet_chemistry2>                      |
| geology_coastal_behavior                                        | <https://drive.emodnet-geology.eu/geoserver/tno/wfs>                          |
| geology_events_and_probabilities                                | <https://drive.emodnet-geology.eu/geoserver/ispra/wfs>                        |
| geology_marine_minerals                                         | <https://drive.emodnet-geology.eu/geoserver/gsi/wfs>                          |
| geology_sea_floor_bedrock                                       | <https://drive.emodnet-geology.eu/geoserver/bgr/wfs>                          |
| geology_seabed_substrate_maps                                   | <https://drive.emodnet-geology.eu/geoserver/gtk/wfs>                          |
| geology_submerged_landscapes                                    | <https://drive.emodnet-geology.eu/geoserver/bgs/wfs>                          |
| human_activities                                                | <https://ows.emodnet-humanactivities.eu/wfs>                                  |
| physics                                                         | <https://prod-geoserver.emodnet-physics.eu/geoserver/ows>                     |
| seabed_habitats_general_datasets_and_products                   | <https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open/wfs>            |
| seabed_habitats_individual_habitat_map_and_model_datasets       | <https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs> |

To explore available services you can use:

``` r
View(emodnet_wfs())
```

## Create Service Client

Specify the service using the `service` argument.

``` r
wfs_bio <- emodnet_init_wfs_client(service = "biology")
#> Loading ISO 19139 XML schemas...
#> Loading ISO 19115 codelists...
#> ✔ WFS client created successfully
#> ℹ Service: "https://geo.vliz.be/geoserver/Emodnetbio/wfs"
#> ℹ Version: "2.0.0"

wfs_bio
#> <WFSClient>
#> ....|-- url: https://geo.vliz.be/geoserver/Emodnetbio/wfs
#> ....|-- version: 2.0.0
#> ....|-- capabilities <WFSCapabilities>
```

## Get WFS Layer info

You can get metadata about the layers available from a service.

``` r
emodnet_get_wfs_info(service = "biology")
#> ✔ WFS client created successfully
#> ℹ Service: "https://geo.vliz.be/geoserver/Emodnetbio/wfs"
#> ℹ Version: "2.0.0"
#> # A tibble: 35 × 9
#> # Rowwise: 
#>    data_source service_name service_url   layer_name title abstract class format
#>    <chr>       <chr>        <chr>         <chr>      <chr> <chr>    <chr> <chr> 
#>  1 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Coral … WFSF… sf    
#>  2 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Coral … WFSF… sf    
#>  3 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Cymodo… WFSF… sf    
#>  4 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  5 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  6 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  7 emodnet_wfs biology      https://geo.… mediseh_h… EMOD… "Haloph… WFSF… sf    
#>  8 emodnet_wfs biology      https://geo.… mediseh_m… EMOD… "Maërl … WFSF… sf    
#>  9 emodnet_wfs biology      https://geo.… mediseh_m… EMOD… "Maërl … WFSF… sf    
#> 10 emodnet_wfs biology      https://geo.… mediseh_p… EMOD… "This d… WFSF… sf    
#> # ℹ 25 more rows
#> # ℹ 1 more variable: layer_namespace <chr>
```

or you can pass a wfs client object.

``` r
emodnet_get_wfs_info(wfs_bio)
#> # A tibble: 35 × 9
#> # Rowwise: 
#>    data_source service_name service_url   layer_name title abstract class format
#>    <chr>       <chr>        <chr>         <chr>      <chr> <chr>    <chr> <chr> 
#>  1 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Coral … WFSF… sf    
#>  2 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Coral … WFSF… sf    
#>  3 emodnet_wfs biology      https://geo.… mediseh_c… EMOD… "Cymodo… WFSF… sf    
#>  4 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  5 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  6 emodnet_wfs biology      https://geo.… Species_g… EMOD… "This d… WFSF… sf    
#>  7 emodnet_wfs biology      https://geo.… mediseh_h… EMOD… "Haloph… WFSF… sf    
#>  8 emodnet_wfs biology      https://geo.… mediseh_m… EMOD… "Maërl … WFSF… sf    
#>  9 emodnet_wfs biology      https://geo.… mediseh_m… EMOD… "Maërl … WFSF… sf    
#> 10 emodnet_wfs biology      https://geo.… mediseh_p… EMOD… "This d… WFSF… sf    
#> # ℹ 25 more rows
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

## Get WFS layers

You can extract layers directly from a `wfs` object using layer names.
All layers are downloaded as `sf` objects and output as a list with a
named element for each layer requested.

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

You can change the output `crs` through the argument `crs`.

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
`reduce_layers`.  
If `TRUE` the function will try to reduce all layers into a single `sf`.

If attempting to reduce fails, it will error:

``` r
emodnet_get_layers(
  wfs = wfs_bio,
  layers = layers,
  reduce_layers = TRUE
)
#> Error in `value[[3L]]()`:
#> ! Cannot reduce layers.
#> ℹ Try again with `reduce_layers = FALSE`
```

Using `reduce_layers = TRUE` is also useful for returning an `sf` object
rather than a list in single layer request.

``` r
emodnet_get_layers(
  service = "biology",
  layers = c("mediseh_posidonia_nodata"),
  reduce_layers = TRUE
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

## Other web services

There are three ways to access EMODnet data at the moment, that
complement each other.

### EMODnet ERDDAP server

Some EMODnet data are also published in an [ERDDAP
server](https://erddap.emodnet.eu). You can access these data in R using
the [rerddap R package](https://docs.ropensci.org/rerddap/):

``` r
# install.packages("rerrdap")
library(rerddap)
#> Registered S3 method overwritten by 'hoardr':
#>   method           from
#>   print.cache_info httr

erddap_url <- "https://erddap.emodnet.eu/erddap/"

rerddap::ed_datasets(url = erddap_url)
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

rerddap::ed_search(query = "vessel density", url = erddap_url)
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

human_activities_data_info <- rerddap::info(datasetid = "humanactivities_9f8a_3389_f08a", url = erddap_url)
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

year_2020_gridded_data <- griddap(datasetx = human_activities_data_info, time = c("2020-03-18", "2020-03-19"))
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

### EMODnetWCS: Access EMODnet Web Coverage Service data

This package emodnet.wfs uses [Web Feature
Services](https://www.ogc.org/standard/wfs/), hence it is limited to
getting vector data. EMODnet also hosts raster data that can be accessed
via [Web Coverage Services (WCS)](https://www.ogc.org/standard/wcs/).
The R package [EMODnetWCS](https://github.com/EMODnet/EMODnetWCS) makes
these data available in R.

## Citation

To cite emodnet.wfs, please use the output from
`citation(package = "emodnet.wfs")`.

``` r
citation(package = "emodnet.wfs")
#> To cite package 'emodnet.wfs' in publications use:
#> 
#>   Krystalli A, Fernández-Bejarano S, Salmon M (????). _EMODnetWFS:
#>   Access EMODnet Web Feature Service data through R_. R package version
#>   2.0.1.9001. Integrated data products created under the European
#>   Marine Observation Data Network (EMODnet) Biology project
#>   (EASME/EMFF/2017/1.3.1.2/02/SI2.789013), funded by the by the
#>   European Union under Regulation (EU) No 508/2014 of the European
#>   Parliament and of the Council of 15 May 2014 on the European Maritime
#>   and Fisheries Fund, <https://github.com/EMODnet/EMODnetWFS>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {{EMODnetWFS}: Access EMODnet Web Feature Service data through R},
#>     author = {Anna Krystalli and Salvador Fernández-Bejarano and Maëlle Salmon},
#>     note = {R package version 2.0.1.9001. Integrated data products created under the European Marine Observation Data Network (EMODnet) Biology project (EASME/EMFF/2017/1.3.1.2/02/SI2.789013), funded by the by the European Union under Regulation (EU) No 508/2014 of the European Parliament and of the Council of 15 May 2014 on the European Maritime and Fisheries Fund},
#>     url = {https://github.com/EMODnet/EMODnetWFS},
#>   }
```

## Acknowledgements

This package was started by the Sheffield University during the EMODnet
Biology WP4 data products workshop in June 2020. You can read the
[product story on the EMODnet-Biology
portal](https://emodnet.ec.europa.eu/geonetwork/)
