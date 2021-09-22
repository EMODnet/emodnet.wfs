
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
remotes::install_github("EMODnet/EMODnetWFS", build_vignettes = TRUE)
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

## Create Service Client

Create new WFS Client. The default service is
`seabed_habitats_individual_habitat_map_and_model_datasets`.

``` r
wfs <- emodnet_init_wfs_client()
#> Loading ISO 19139 XML schemas...
#> Loading ISO 19115 codelists...
#> v WFS client created succesfully
#> i Service: 'https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs'
#> i Version: '2.0.0'
```

You can access further services using the `service` argument.

``` r
wfs_bath <- emodnet_init_wfs_client(service = "bathymetry")
#> v WFS client created succesfully
#> i Service: 'https://ows.emodnet-bathymetry.eu/wfs'
#> i Version: '2.0.0'

wfs_bath$getUrl()
#> [1] "https://ows.emodnet-bathymetry.eu/wfs"
```

## Get WFS Layer info

You can get metadata about the layers available from a service. The
default service is
`seabed_habitats_individual_habitat_map_and_model_datasets`.

``` r
emodnet_get_wfs_info()
#> v WFS client created succesfully
#> i Service: 'https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs'
#> i Version: '2.0.0'
#> # A tibble: 909 x 9
#>    data_source service_name    service_url      layer_namespace layer_name title
#>    <chr>       <chr>           <chr>            <chr>           <chr>      <chr>
#>  1 emodnet_wfs seabed_habitat~ https://ows.emo~ emodnet_open_m~ be000225   BE00~
#>  2 emodnet_wfs seabed_habitat~ https://ows.emo~ emodnet_open_m~ be000226   BE00~
#>  3 emodnet_wfs seabed_habitat~ https://ows.emo~ emodnet_open_m~ be000227   BE00~
#>  4 emodnet_wfs seabed_habitat~ https://ows.emo~ emodnet_open_m~ be000228   BE00~
#>  5 emodnet_wfs seabed_habitat~ https://ows.emo~ emodnet_open_m~ fr004015   FR00~
#>  6 emodnet_wfs seabed_habitat~ https://ows.emo~ emodnet_open_m~ gb001308   GB00~
#>  7 emodnet_wfs seabed_habitat~ https://ows.emo~ emodnet_open_m~ gb001517   GB00~
#>  8 emodnet_wfs seabed_habitat~ https://ows.emo~ emodnet_open_m~ gb100299   GB10~
#>  9 emodnet_wfs seabed_habitat~ https://ows.emo~ emodnet_open_m~ gb100355   GB10~
#> 10 emodnet_wfs seabed_habitat~ https://ows.emo~ emodnet_open_m~ gb100361   GB10~
#> # ... with 899 more rows, and 3 more variables: abstract <chr>, class <chr>,
#> #   format <chr>
```

You can access information about a service using the `service` argument.

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
#> 1 emodnet_wfs seabed_habi~ https://ow~ emodnet         contours   Dept~ "Genera~
#> 2 emodnet_wfs seabed_habi~ https://ow~ emodnet         quality_i~ Qual~ "Repres~
#> 3 emodnet_wfs seabed_habi~ https://ow~ emodnet         source_re~ Sour~ "Covera~
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
#>    data_source service_name   service_url    layer_namespace layer_name  title  
#>    <chr>       <chr>          <chr>          <chr>           <chr>       <chr>  
#>  1 emodnet_wfs seabed_habita~ https://ows.e~ ms              bl_beaches~ Beache~
#>  2 emodnet_wfs seabed_habita~ https://ows.e~ ms              bl_tempora~ Number~
#>  3 emodnet_wfs seabed_habita~ https://ows.e~ ms              bl_totalab~ Beach ~
#>  4 emodnet_wfs seabed_habita~ https://ows.e~ ms              bl_materia~ Beach ~
#>  5 emodnet_wfs seabed_habita~ https://ows.e~ ms              bl_cigaret~ Beach ~
#>  6 emodnet_wfs seabed_habita~ https://ows.e~ ms              bl_cigaret~ Beach ~
#>  7 emodnet_wfs seabed_habita~ https://ows.e~ ms              bl_fishing~ Beach ~
#>  8 emodnet_wfs seabed_habita~ https://ows.e~ ms              bl_plastic~ Beach ~
#>  9 emodnet_wfs seabed_habita~ https://ows.e~ ms              bl_beaches~ Beache~
#> 10 emodnet_wfs seabed_habita~ https://ows.e~ ms              bl_tempora~ Number~
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
All layers are downloaded as `sf` objects and the crs of outputs are
standardised to `EPSG` code 4326 by default.

``` r
emodnet_get_layers(wfs = wfs_cml, layers = layers)
#> Warning: Download of layer 'bl_beacheslocations_2001_2008_monitoring' failed: Error in ft[[1]]: subscript out of bounds
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
#> 
#> $bl_beacheslocations_2001_2008_monitoring
#> NULL
```

You can chage the output crs through argument `crs`.

``` r
emodnet_get_layers(wfs = wfs_cml, layers = layers, crs = 3857)
#> Warning: Download of layer 'bl_beacheslocations_2001_2008_monitoring' failed: Error in ft[[1]]: subscript out of bounds
#> i crs transformed from 4326 to 3857
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
#> 
#> $bl_beacheslocations_2001_2008_monitoring
#> NULL
```

You can also extract layers directly from a WFS service The default
service is `seabed_habitats_individual_habitat_map_and_model_datasets`.

``` r
emodnet_get_layers(layers = c("dk003069", "dk003070"))
#> v WFS client created succesfully
#> i Service: 'https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs'
#> i Version: '2.0.0'
#> i crs transformed from 3857 to 4326
#> i crs transformed from 3857 to 4326
#> $dk003069
#> Simple feature collection with 82 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 9.575308 ymin: 54.77378 xmax: 10.24418 ymax: 55.12132
#> geographic CRS: WGS 84
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
#> 1      <NA> MULTISURFACE (POLYGON ((10....
#> 2      <NA> MULTISURFACE (POLYGON ((10....
#> 3      <NA> MULTISURFACE (POLYGON ((10....
#> 4      <NA> MULTISURFACE (POLYGON ((9.8...
#> 5      <NA> MULTISURFACE (POLYGON ((10....
#> 6      <NA> MULTISURFACE (POLYGON ((9.9...
#> 7      <NA> MULTISURFACE (POLYGON ((9.8...
#> 8      <NA> MULTISURFACE (POLYGON ((9.8...
#> 9      <NA> MULTISURFACE (POLYGON ((10....
#> 10     <NA> MULTISURFACE (POLYGON ((9.9...
#> 
#> $dk003070
#> Simple feature collection with 30 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 11.39643 ymin: 54.55514 xmax: 11.96792 ymax: 54.63234
#> geographic CRS: WGS 84
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
#> 1      <NA> MULTISURFACE (POLYGON ((11....
#> 2      <NA> MULTISURFACE (POLYGON ((11....
#> 3      <NA> MULTISURFACE (POLYGON ((11....
#> 4      <NA> MULTISURFACE (POLYGON ((11....
#> 5      <NA> MULTISURFACE (POLYGON ((11....
#> 6      <NA> MULTISURFACE (POLYGON ((11....
#> 7      <NA> MULTISURFACE (POLYGON ((11....
#> 8      <NA> MULTISURFACE (POLYGON ((11....
#> 9      <NA> MULTISURFACE (POLYGON ((11....
#> 10     <NA> MULTISURFACE (POLYGON ((11....
```

Use argument `service` to specify the required service.

``` r
human_activities <- emodnet_get_layers(service = "human_activities", 
                   layers = c("aquaculture", "dredging"))
#> v WFS client created succesfully
#> i Service: 'https://ows.emodnet-humanactivities.eu/wfs'
#> i Version: '2.0.0'
#> Warning: crs missing. Set to default 4326

#> Warning: crs missing. Set to default 4326

human_activities[["aquaculture"]]
#> Simple feature collection with 1 feature and 10 fields
#> geometry type:  MULTIPOLYGON
#> dimension:      XY
#> bbox:           xmin: -63.08829 ymin: -21.38731 xmax: 55.83663 ymax: 70.0924
#> geographic CRS: WGS 84
#>                                       gml_id gid legalfound
#> 1 aquaculture.fid--15c2f9b5_17c0ddb7fcf_682d  17 2016-07-12
#>                                                           legalfou_1 country
#> 1 http://ebcd.org/wp-content/uploads/2017/01/Statutes-of-the-AAC.pdf    <NA>
#>                      namespace   nationalle
#> 1 Aquaculture Advisory Council Internatonal
#>                                                 nutscode
#> 1 AT, BE, DK, FI, FR, DE, GR, IE, IT, NL, PL, PT, ES, UK
#>                                                                                                                 members
#> 1 Austria, Belgium, Denmark, Finland, France, Germany, Greece, Ireland, Italy, Netherlands, Poland, Portugal, Spain, UK
#>                                                                            url
#> 1 https://ec.europa.eu/fisheries/cfp/aquaculture/aquaculture-advisory-council/
#>                         the_geom
#> 1 MULTIPOLYGON (((55.66534 -2...
```

Layers can also be returned to a single `sf` object through argument
`reduce_layers`. If `TRUE` the function will try to reduce all layers
into a single `sf` and will fail if not.

``` r
emodnet_get_layers(layers = c("dk003069", "dk003070"), 
                   reduce_layers = TRUE)
#> v WFS client created succesfully
#> i Service: 'https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs'
#> i Version: '2.0.0'
#> i crs transformed from 3857 to 4326
#> Simple feature collection with 112 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 9.575308 ymin: 54.55514 xmax: 11.96792 ymax: 55.12132
#> geographic CRS: WGS 84
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
#> 1      <NA> MULTISURFACE (POLYGON ((10....
#> 2      <NA> MULTISURFACE (POLYGON ((10....
#> 3      <NA> MULTISURFACE (POLYGON ((10....
#> 4      <NA> MULTISURFACE (POLYGON ((9.8...
#> 5      <NA> MULTISURFACE (POLYGON ((10....
#> 6      <NA> MULTISURFACE (POLYGON ((9.9...
#> 7      <NA> MULTISURFACE (POLYGON ((9.8...
#> 8      <NA> MULTISURFACE (POLYGON ((9.8...
#> 9      <NA> MULTISURFACE (POLYGON ((10....
#> 10     <NA> MULTISURFACE (POLYGON ((9.9...
```

``` r
emodnet_get_layers(wfs = wfs_cml, layers = layers,
                   reduce_layers = TRUE)
#> Warning: Download of layer 'bl_beacheslocations_2001_2008_monitoring' failed: Error in ft[[1]]: subscript out of bounds
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
