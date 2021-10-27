
<!-- README.md is generated from README.Rmd. Please edit that file -->

# EMODnetWFS: Access EMODnet Web Feature Service data through R <img src='man/figures/emodnetwfs.svg' align="right" height="200"/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/EMODnet/EMODnetWFS/workflows/R-CMD-check/badge.svg)](https://github.com/EMODnet/EMODnetWFS/actions)
[![Codecov test
coverage](https://codecov.io/gh/EMODnet/EMODnetWFS/branch/master/graph/badge.svg)](https://codecov.io/gh/EMODnet/EMODnetWFS?branch=master)
<!-- badges: end -->

The goal of EMODnetWFS is to allow interrogation and access to the
[EMODnet Web Feature Services](https://www.emodnet.eu/en/data) data in
R. This package was developed by the Sheffield University during the
EMODnet Biology WP4 data products workshop in June 2020.

You can read the product story on the EMODnet-Biology portal following
[this
link](https://www.emodnet-biology.eu/blog/emodnetwfs-access-emodnet-web-feature-service-data-through-r),
or read the vignette directly in R after installing the package.

``` r
vignette("emodnetwfs")
```

## Installation

You can install the development version of EMODnetWFS from GitHub with:

``` r
remotes::install_github("EMODnet/EMODnetWFS")
```

## Available services

All available services are contained in the `emodnet_wfs` package
dataset.

| service\_name                                                          | service\_url                                                                  |
|:-----------------------------------------------------------------------|:------------------------------------------------------------------------------|
| bathymetry                                                             | <https://ows.emodnet-bathymetry.eu/wfs>                                       |
| biology                                                                | <http://geo.vliz.be/geoserver/Emodnetbio/wfs>                                 |
| biology\_occurrence\_data                                              | <http://geo.vliz.be/geoserver/Dataportal/wfs>                                 |
| chemistry\_cdi\_data\_discovery\_and\_access\_service                  | <https://geo-service.maris.nl/emodnet_chemistry/wfs>                          |
| chemistry\_cdi\_distribution\_observations\_per\_category\_and\_region | <https://geo-service.maris.nl/emodnet_chemistry_p36/wfs>                      |
| chemistry\_contaminants                                                | <https://nodc.ogs.trieste.it/geoserver/Contaminants/wfs>                      |
| chemistry\_marine\_litter                                              | <https://www.ifremer.fr/services/wfs/emodnet_chemistry2>                      |
| geology\_coastal\_behavior                                             | <https://drive.emodnet-geology.eu/geoserver/tno/wfs>                          |
| geology\_events\_and\_probabilities                                    | <https://drive.emodnet-geology.eu/geoserver/ispra/wfs>                        |
| geology\_marine\_minerals                                              | <https://drive.emodnet-geology.eu/geoserver/gsi/wfs>                          |
| geology\_sea\_floor\_bedrock                                           | <https://drive.emodnet-geology.eu/geoserver/bgr/wfs>                          |
| geology\_seabed\_substrate\_maps                                       | <https://drive.emodnet-geology.eu/geoserver/gtk/wfs>                          |
| geology\_submerged\_landscapes                                         | <https://drive.emodnet-geology.eu/geoserver/bgs/wfs>                          |
| human\_activities                                                      | <https://ows.emodnet-humanactivities.eu/wfs>                                  |
| physics                                                                | <https://geoserver.emodnet-physics.eu/geoserver/emodnet/wfs>                  |
| seabed\_habitats\_general\_datasets\_and\_products                     | <https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open/wfs>            |
| seabed\_habitats\_individual\_habitat\_map\_and\_model\_datasets       | <https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs> |

To explore available services in Rstudio use:

``` r
View(emodnet_wfs)
```

If you experience problems, please consult the [EMODnet OGC monitor
](https://monitor.emodnet.eu/resources?lang=en&resource_type=OGC%3AWFS) to check the status of services prior to opening issues in the package.

## Create Service Client

Create new WFS Client. Specify the service using the `service` argument.

``` r
wfs_bath <- emodnet_init_wfs_client(service = "bathymetry")
#> Loading ISO 19139 XML schemas...
#> Loading ISO 19115 codelists...
#> v WFS client created succesfully
#> i Service: 'https://ows.emodnet-bathymetry.eu/wfs'
#> i Version: '2.0.0'

wfs_bath$getUrl()
#> [1] "https://ows.emodnet-bathymetry.eu/wfs"
```

## Get WFS Layer info

You can get metadata about the layers available from a service.

``` r
emodnet_get_wfs_info(service = "bathymetry")
#> v WFS client created succesfully
#> i Service: 'https://ows.emodnet-bathymetry.eu/wfs'
#> i Version: '2.0.0'
#> # A tibble: 3 x 9
#>   data_source service_name service_url layer_namespace layer_name title abstract
#>   <chr>       <chr>        <chr>       <chr>           <chr>      <chr> <chr>   
#> 1 emodnet_wfs bathymetry   https://ow~ emodnet         contours   Dept~ "Genera~
#> 2 emodnet_wfs bathymetry   https://ow~ emodnet         quality_i~ Qual~ "Repres~
#> 3 emodnet_wfs bathymetry   https://ow~ emodnet         source_re~ Sour~ "Covera~
#> # ... with 2 more variables: class <chr>, format <chr>
```

or you can pass a wfs client object.

``` r
emodnet_get_wfs_info(wfs_bath)
#> # A tibble: 3 x 9
#>   data_source service_name service_url layer_namespace layer_name title abstract
#>   <chr>       <chr>        <chr>       <chr>           <chr>      <chr> <chr>   
#> 1 emodnet_wfs bathymetry   https://ow~ emodnet         contours   Dept~ "Genera~
#> 2 emodnet_wfs bathymetry   https://ow~ emodnet         quality_i~ Qual~ "Repres~
#> 3 emodnet_wfs bathymetry   https://ow~ emodnet         source_re~ Sour~ "Covera~
#> # ... with 2 more variables: class <chr>, format <chr>
```

You can also get info for specific layers from wfs object:

``` r
wfs_cml <- emodnet_init_wfs_client("chemistry_marine_litter")
#> v WFS client created succesfully
#> i Service: 'https://www.ifremer.fr/services/wfs/emodnet_chemistry2'
#> i Version: '2.0.0'
emodnet_get_wfs_info(wfs_cml)
#> # A tibble: 21 x 9
#>    data_source service_name  service_url    layer_namespace layer_name  title   
#>    <chr>       <chr>         <chr>          <chr>           <chr>       <chr>   
#>  1 emodnet_wfs chemistry_ma~ https://www.i~ ms              bl_beaches~ Beaches~
#>  2 emodnet_wfs chemistry_ma~ https://www.i~ ms              bl_tempora~ Number ~
#>  3 emodnet_wfs chemistry_ma~ https://www.i~ ms              bl_totalab~ Beach L~
#>  4 emodnet_wfs chemistry_ma~ https://www.i~ ms              bl_materia~ Beach L~
#>  5 emodnet_wfs chemistry_ma~ https://www.i~ ms              bl_cigaret~ Beach L~
#>  6 emodnet_wfs chemistry_ma~ https://www.i~ ms              bl_cigaret~ Beach L~
#>  7 emodnet_wfs chemistry_ma~ https://www.i~ ms              bl_fishing~ Beach L~
#>  8 emodnet_wfs chemistry_ma~ https://www.i~ ms              bl_plastic~ Beach L~
#>  9 emodnet_wfs chemistry_ma~ https://www.i~ ms              bl_beaches~ Beaches~
#> 10 emodnet_wfs chemistry_ma~ https://www.i~ ms              bl_tempora~ Number ~
#> # ... with 11 more rows, and 3 more variables: abstract <chr>, class <chr>,
#> #   format <chr>

layers <- c("bl_fishing_monitoring",
          "bl_beacheslocations_2001_2008_monitoring")

emodnet_get_layer_info(wfs = wfs_cml, layers = layers)
#> # A tibble: 1 x 9
#>   data_source service_name service_url layer_namespace layer_name title abstract
#>   <chr>       <chr>        <chr>       <chr>           <chr>      <chr> <chr>   
#> 1 emodnet_wfs https://www~ chemistry_~ ms              bl_fishin~ Beac~ ""      
#> # ... with 2 more variables: class <chr>, format <chr>
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
emodnet_get_layers(wfs = wfs_cml, layers = layers)
#> $bl_fishing_monitoring
#> Simple feature collection with 3490 features and 15 fields
#> geometry type:  POINT
#> dimension:      XY
#> bbox:           xmin: -53.60233 ymin: 28.34246 xmax: 41.77114 ymax: 81.68642
#> geographic CRS: WGS 84
#> First 10 features:
#>    gml_id id country country_name beachcode         beachname
#> 1    <NA>  1      SE       Sweden         1 Björkängs Havsbad
#> 2    <NA>  2      SE       Sweden         1 Björkängs Havsbad
#> 3    <NA>  3      SE       Sweden         1 Björkängs Havsbad
#> 4    <NA>  4      SE       Sweden        11          Rullsand
#> 5    <NA>  5      SE       Sweden        11          Rullsand
#> 6    <NA>  6      SE       Sweden        11          Rullsand
#> 7    <NA>  7      SE       Sweden        11          Rullsand
#> 8    <NA>  8      SE       Sweden        11          Rullsand
#> 9    <NA>  9      SE       Sweden        11          Rullsand
#> 10   <NA> 10      SE       Sweden        11          Rullsand
#>       surveytype_class      surveytype year          surveyyear nbsurvey
#> 1  Official monitoring MSFD_monitoring 2012 2012-01-01 00:00:00        3
#> 2  Official monitoring MSFD_monitoring 2013 2013-01-01 00:00:00        3
#> 3  Official monitoring MSFD_monitoring 2014 2014-01-01 00:00:00        1
#> 4  Official monitoring MSFD_monitoring 2012 2012-01-01 00:00:00        3
#> 5  Official monitoring MSFD_monitoring 2013 2013-01-01 00:00:00        3
#> 6  Official monitoring MSFD_monitoring 2014 2014-01-01 00:00:00        2
#> 7  Official monitoring MSFD_monitoring 2015 2015-01-01 00:00:00        3
#> 8  Official monitoring MSFD_monitoring 2016 2016-01-01 00:00:00        3
#> 9  Official monitoring MSFD_monitoring 2017 2017-01-01 00:00:00        3
#> 10 Official monitoring MSFD_monitoring 2018 2018-01-01 00:00:00        3
#>    surveylength litterreferencelist           littergroup litterabundance
#> 1      100/1000         UNEP_MARLIN Fishing related items             5.0
#> 2      100/1000         UNEP_MARLIN Fishing related items             3.0
#> 3      100/1000         UNEP_MARLIN Fishing related items            14.0
#> 4       100/500         UNEP_MARLIN Fishing related items            12.0
#> 5       100/500         UNEP_MARLIN Fishing related items             1.0
#> 6       100/500         UNEP_MARLIN Fishing related items             5.0
#> 7       100/500         UNEP_MARLIN Fishing related items             1.0
#> 8       100/500         UNEP_MARLIN Fishing related items             3.2
#> 9       100/500         UNEP_MARLIN Fishing related items             4.6
#> 10      100/500         UNEP_MARLIN Fishing related items             9.2
#>                   msGeometry
#> 1  POINT (12.34726 57.00938)
#> 2  POINT (12.34726 57.00938)
#> 3  POINT (12.34726 57.00938)
#> 4   POINT (17.4729 60.64045)
#> 5   POINT (17.4729 60.64045)
#> 6   POINT (17.4729 60.64045)
#> 7   POINT (17.4729 60.64045)
#> 8   POINT (17.4729 60.64045)
#> 9   POINT (17.4729 60.64045)
#> 10  POINT (17.4729 60.64045)
```

You can change the output `crs` through argument `crs`.

``` r
emodnet_get_layers(wfs = wfs_cml, layers = layers, crs = 3857)
#> i crs transformed to 3857
#> $bl_fishing_monitoring
#> Simple feature collection with 3490 features and 15 fields
#> geometry type:  POINT
#> dimension:      XY
#> bbox:           xmin: -5966984 ymin: 3292219 xmax: 4649942 ymax: 16721730
#> projected CRS:  WGS 84 / Pseudo-Mercator
#> First 10 features:
#>    gml_id id country country_name beachcode         beachname
#> 1    <NA>  1      SE       Sweden         1 Björkängs Havsbad
#> 2    <NA>  2      SE       Sweden         1 Björkängs Havsbad
#> 3    <NA>  3      SE       Sweden         1 Björkängs Havsbad
#> 4    <NA>  4      SE       Sweden        11          Rullsand
#> 5    <NA>  5      SE       Sweden        11          Rullsand
#> 6    <NA>  6      SE       Sweden        11          Rullsand
#> 7    <NA>  7      SE       Sweden        11          Rullsand
#> 8    <NA>  8      SE       Sweden        11          Rullsand
#> 9    <NA>  9      SE       Sweden        11          Rullsand
#> 10   <NA> 10      SE       Sweden        11          Rullsand
#>       surveytype_class      surveytype year          surveyyear nbsurvey
#> 1  Official monitoring MSFD_monitoring 2012 2012-01-01 00:00:00        3
#> 2  Official monitoring MSFD_monitoring 2013 2013-01-01 00:00:00        3
#> 3  Official monitoring MSFD_monitoring 2014 2014-01-01 00:00:00        1
#> 4  Official monitoring MSFD_monitoring 2012 2012-01-01 00:00:00        3
#> 5  Official monitoring MSFD_monitoring 2013 2013-01-01 00:00:00        3
#> 6  Official monitoring MSFD_monitoring 2014 2014-01-01 00:00:00        2
#> 7  Official monitoring MSFD_monitoring 2015 2015-01-01 00:00:00        3
#> 8  Official monitoring MSFD_monitoring 2016 2016-01-01 00:00:00        3
#> 9  Official monitoring MSFD_monitoring 2017 2017-01-01 00:00:00        3
#> 10 Official monitoring MSFD_monitoring 2018 2018-01-01 00:00:00        3
#>    surveylength litterreferencelist           littergroup litterabundance
#> 1      100/1000         UNEP_MARLIN Fishing related items             5.0
#> 2      100/1000         UNEP_MARLIN Fishing related items             3.0
#> 3      100/1000         UNEP_MARLIN Fishing related items            14.0
#> 4       100/500         UNEP_MARLIN Fishing related items            12.0
#> 5       100/500         UNEP_MARLIN Fishing related items             1.0
#> 6       100/500         UNEP_MARLIN Fishing related items             5.0
#> 7       100/500         UNEP_MARLIN Fishing related items             1.0
#> 8       100/500         UNEP_MARLIN Fishing related items             3.2
#> 9       100/500         UNEP_MARLIN Fishing related items             4.6
#> 10      100/500         UNEP_MARLIN Fishing related items             9.2
#>                 msGeometry
#> 1  POINT (1374491 7762037)
#> 2  POINT (1374491 7762037)
#> 3  POINT (1374491 7762037)
#> 4  POINT (1945074 8543728)
#> 5  POINT (1945074 8543728)
#> 6  POINT (1945074 8543728)
#> 7  POINT (1945074 8543728)
#> 8  POINT (1945074 8543728)
#> 9  POINT (1945074 8543728)
#> 10 POINT (1945074 8543728)
```

You can also extract layers directly from a WFS service.

``` r
emodnet_get_layers(service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                   layers = c("dk003069", "dk003070"))
#> v WFS client created succesfully
#> i Service: 'https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs'
#> i Version: '2.0.0'
#> $dk003069
#> Simple feature collection with 82 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 1065918 ymin: 7318084 xmax: 1140377 ymax: 7385447
#> projected CRS:  WGS 84 / Pseudo-Mercator
#> First 10 features:
#>            gml_id   gid      gui polygon annexi         subtype confidence
#> 1  dk003069.39813 39813 DK003069      30   1170 Geogenic origin       High
#> 2  dk003069.39847 39847 DK003069      64   1110            <NA>       High
#> 3  dk003069.39794 39794 DK003069      11   1170 Geogenic origin       High
#> 4  dk003069.39787 39787 DK003069       4   1170 Geogenic origin       High
#> 5  dk003069.39809 39809 DK003069      26   1170 Geogenic origin       High
#> 6  dk003069.39806 39806 DK003069      23   1170 Geogenic origin       High
#> 7  dk003069.39801 39801 DK003069      18   1170 Geogenic origin       High
#> 8  dk003069.39805 39805 DK003069      22   1170 Geogenic origin       High
#> 9  dk003069.39827 39827 DK003069      44   1170 Geogenic origin       High
#> 10 dk003069.39849 39849 DK003069      66   1110            <NA>       High
#>    val_comm                           geom
#> 1      <NA> MULTISURFACE (POLYGON ((113...
#> 2      <NA> MULTISURFACE (POLYGON ((112...
#> 3      <NA> MULTISURFACE (POLYGON ((112...
#> 4      <NA> MULTISURFACE (POLYGON ((109...
#> 5      <NA> MULTISURFACE (POLYGON ((113...
#> 6      <NA> MULTISURFACE (POLYGON ((110...
#> 7      <NA> MULTISURFACE (POLYGON ((109...
#> 8      <NA> MULTISURFACE (POLYGON ((109...
#> 9      <NA> MULTISURFACE (POLYGON ((112...
#> 10     <NA> MULTISURFACE (POLYGON ((111...
#> 
#> $dk003070
#> Simple feature collection with 30 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 1268645 ymin: 7276003 xmax: 1332262 ymax: 7290836
#> projected CRS:  WGS 84 / Pseudo-Mercator
#> First 10 features:
#>            gml_id   gid      gui polygon annexi         subtype confidence
#> 1  dk003070.39886 39886 DK003070      21   1170 Geogenic origin       High
#> 2  dk003070.39890 39890 DK003070      25   1170 Geogenic origin       High
#> 3  dk003070.39882 39882 DK003070      17   1170 Geogenic origin       High
#> 4  dk003070.39875 39875 DK003070      10   1170 Geogenic origin       High
#> 5  dk003070.39881 39881 DK003070      16   1170 Geogenic origin       High
#> 6  dk003070.39887 39887 DK003070      22   1170 Geogenic origin       High
#> 7  dk003070.39885 39885 DK003070      20   1170 Geogenic origin       High
#> 8  dk003070.39879 39879 DK003070      14   1170 Geogenic origin       High
#> 9  dk003070.39867 39867 DK003070       2   1170 Geogenic origin       High
#> 10 dk003070.39873 39873 DK003070       8   1170 Geogenic origin       High
#>    val_comm                           geom
#> 1      <NA> MULTISURFACE (POLYGON ((131...
#> 2      <NA> MULTISURFACE (POLYGON ((131...
#> 3      <NA> MULTISURFACE (POLYGON ((128...
#> 4      <NA> MULTISURFACE (POLYGON ((130...
#> 5      <NA> MULTISURFACE (POLYGON ((128...
#> 6      <NA> MULTISURFACE (POLYGON ((131...
#> 7      <NA> MULTISURFACE (POLYGON ((131...
#> 8      <NA> MULTISURFACE (POLYGON ((129...
#> 9      <NA> MULTISURFACE (POLYGON ((129...
#> 10     <NA> MULTISURFACE (POLYGON ((128...
```

Layers can also be returned to a single `sf` object through argument
`reduce_layers`. If `TRUE` the function will try to reduce all layers
into a single `sf`.

``` r
emodnet_get_layers(service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                   layers = c("dk003069", "dk003070"), 
                   reduce_layers = TRUE)
#> v WFS client created succesfully
#> i Service: 'https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs'
#> i Version: '2.0.0'
#> Simple feature collection with 112 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 1065918 ymin: 7276003 xmax: 1332262 ymax: 7385447
#> projected CRS:  WGS 84 / Pseudo-Mercator
#> First 10 features:
#>            gml_id   gid      gui polygon annexi         subtype confidence
#> 1  dk003069.39813 39813 DK003069      30   1170 Geogenic origin       High
#> 2  dk003069.39847 39847 DK003069      64   1110            <NA>       High
#> 3  dk003069.39794 39794 DK003069      11   1170 Geogenic origin       High
#> 4  dk003069.39787 39787 DK003069       4   1170 Geogenic origin       High
#> 5  dk003069.39809 39809 DK003069      26   1170 Geogenic origin       High
#> 6  dk003069.39806 39806 DK003069      23   1170 Geogenic origin       High
#> 7  dk003069.39801 39801 DK003069      18   1170 Geogenic origin       High
#> 8  dk003069.39805 39805 DK003069      22   1170 Geogenic origin       High
#> 9  dk003069.39827 39827 DK003069      44   1170 Geogenic origin       High
#> 10 dk003069.39849 39849 DK003069      66   1110            <NA>       High
#>    val_comm                           geom
#> 1      <NA> MULTISURFACE (POLYGON ((113...
#> 2      <NA> MULTISURFACE (POLYGON ((112...
#> 3      <NA> MULTISURFACE (POLYGON ((112...
#> 4      <NA> MULTISURFACE (POLYGON ((109...
#> 5      <NA> MULTISURFACE (POLYGON ((113...
#> 6      <NA> MULTISURFACE (POLYGON ((110...
#> 7      <NA> MULTISURFACE (POLYGON ((109...
#> 8      <NA> MULTISURFACE (POLYGON ((109...
#> 9      <NA> MULTISURFACE (POLYGON ((112...
#> 10     <NA> MULTISURFACE (POLYGON ((111...
```

If attempting to reduce fails, it will return a list with a warning:

``` r
emodnet_get_layers(wfs = wfs_cml, layers = layers,
                   reduce_layers = TRUE)
#> Simple feature collection with 3490 features and 15 fields
#> geometry type:  POINT
#> dimension:      XY
#> bbox:           xmin: -53.60233 ymin: 28.34246 xmax: 41.77114 ymax: 81.68642
#> geographic CRS: WGS 84
#> First 10 features:
#>    gml_id id country country_name beachcode         beachname
#> 1    <NA>  1      SE       Sweden         1 Björkängs Havsbad
#> 2    <NA>  2      SE       Sweden         1 Björkängs Havsbad
#> 3    <NA>  3      SE       Sweden         1 Björkängs Havsbad
#> 4    <NA>  4      SE       Sweden        11          Rullsand
#> 5    <NA>  5      SE       Sweden        11          Rullsand
#> 6    <NA>  6      SE       Sweden        11          Rullsand
#> 7    <NA>  7      SE       Sweden        11          Rullsand
#> 8    <NA>  8      SE       Sweden        11          Rullsand
#> 9    <NA>  9      SE       Sweden        11          Rullsand
#> 10   <NA> 10      SE       Sweden        11          Rullsand
#>       surveytype_class      surveytype year          surveyyear nbsurvey
#> 1  Official monitoring MSFD_monitoring 2012 2012-01-01 00:00:00        3
#> 2  Official monitoring MSFD_monitoring 2013 2013-01-01 00:00:00        3
#> 3  Official monitoring MSFD_monitoring 2014 2014-01-01 00:00:00        1
#> 4  Official monitoring MSFD_monitoring 2012 2012-01-01 00:00:00        3
#> 5  Official monitoring MSFD_monitoring 2013 2013-01-01 00:00:00        3
#> 6  Official monitoring MSFD_monitoring 2014 2014-01-01 00:00:00        2
#> 7  Official monitoring MSFD_monitoring 2015 2015-01-01 00:00:00        3
#> 8  Official monitoring MSFD_monitoring 2016 2016-01-01 00:00:00        3
#> 9  Official monitoring MSFD_monitoring 2017 2017-01-01 00:00:00        3
#> 10 Official monitoring MSFD_monitoring 2018 2018-01-01 00:00:00        3
#>    surveylength litterreferencelist           littergroup litterabundance
#> 1      100/1000         UNEP_MARLIN Fishing related items             5.0
#> 2      100/1000         UNEP_MARLIN Fishing related items             3.0
#> 3      100/1000         UNEP_MARLIN Fishing related items            14.0
#> 4       100/500         UNEP_MARLIN Fishing related items            12.0
#> 5       100/500         UNEP_MARLIN Fishing related items             1.0
#> 6       100/500         UNEP_MARLIN Fishing related items             5.0
#> 7       100/500         UNEP_MARLIN Fishing related items             1.0
#> 8       100/500         UNEP_MARLIN Fishing related items             3.2
#> 9       100/500         UNEP_MARLIN Fishing related items             4.6
#> 10      100/500         UNEP_MARLIN Fishing related items             9.2
#>                   msGeometry
#> 1  POINT (12.34726 57.00938)
#> 2  POINT (12.34726 57.00938)
#> 3  POINT (12.34726 57.00938)
#> 4   POINT (17.4729 60.64045)
#> 5   POINT (17.4729 60.64045)
#> 6   POINT (17.4729 60.64045)
#> 7   POINT (17.4729 60.64045)
#> 8   POINT (17.4729 60.64045)
#> 9   POINT (17.4729 60.64045)
#> 10  POINT (17.4729 60.64045)
```

Using `reduce_layers = TRUE` is also useful for returning an `sf` object
rather than a list in single layer request.

``` r
emodnet_get_layers(service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                  layers = c("dk003069"), 
                   reduce_layers = TRUE)
#> v WFS client created succesfully
#> i Service: 'https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs'
#> i Version: '2.0.0'
#> Simple feature collection with 82 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 1065918 ymin: 7318084 xmax: 1140377 ymax: 7385447
#> projected CRS:  WGS 84 / Pseudo-Mercator
#> First 10 features:
#>            gml_id   gid      gui polygon annexi         subtype confidence
#> 1  dk003069.39813 39813 DK003069      30   1170 Geogenic origin       High
#> 2  dk003069.39847 39847 DK003069      64   1110            <NA>       High
#> 3  dk003069.39794 39794 DK003069      11   1170 Geogenic origin       High
#> 4  dk003069.39787 39787 DK003069       4   1170 Geogenic origin       High
#> 5  dk003069.39809 39809 DK003069      26   1170 Geogenic origin       High
#> 6  dk003069.39806 39806 DK003069      23   1170 Geogenic origin       High
#> 7  dk003069.39801 39801 DK003069      18   1170 Geogenic origin       High
#> 8  dk003069.39805 39805 DK003069      22   1170 Geogenic origin       High
#> 9  dk003069.39827 39827 DK003069      44   1170 Geogenic origin       High
#> 10 dk003069.39849 39849 DK003069      66   1110            <NA>       High
#>    val_comm                           geom
#> 1      <NA> MULTISURFACE (POLYGON ((113...
#> 2      <NA> MULTISURFACE (POLYGON ((112...
#> 3      <NA> MULTISURFACE (POLYGON ((112...
#> 4      <NA> MULTISURFACE (POLYGON ((109...
#> 5      <NA> MULTISURFACE (POLYGON ((113...
#> 6      <NA> MULTISURFACE (POLYGON ((110...
#> 7      <NA> MULTISURFACE (POLYGON ((109...
#> 8      <NA> MULTISURFACE (POLYGON ((109...
#> 9      <NA> MULTISURFACE (POLYGON ((112...
#> 10     <NA> MULTISURFACE (POLYGON ((111...
```

## Citation

Please cite this package as:

Anna Krystalli (2020). EMODnetWFS: Access EMODnet Web Feature Service
data through R. R package version 0.0.2.
<https://github.com/EMODnet/EMODnetWFS>. Integrated data products
created under the European Marine Observation Data Network (EMODnet)
Biology project (EASME/EMFF/2017/1.3.1.2/02/SI2.789013), funded by the
by the European Union under Regulation (EU) No 508/2014 of the European
Parliament and of the Council of 15 May 2014 on the European Maritime
and Fisheries Fund.
