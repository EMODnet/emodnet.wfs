
<!-- README.md is generated from README.Rmd. Please edit that file -->

# EMODnetWFS <img src='man/figures/emodnetwfs.svg' align="right" height="139"/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/EMODnet/EMODnetWFS/workflows/R-CMD-check/badge.svg)](https://github.com/EMODnet/EMODnetWFS/actions)
[![Codecov test
coverage](https://codecov.io/gh/EMODnet/EMODnetWFS/branch/master/graph/badge.svg)](https://codecov.io/gh/EMODnet/EMODnetWFS?branch=master)
<!-- badges: end -->

The goal of EMODnetWFS is to allow interrogation and access to the
EMODnet Web Feature Services data in R.

## Installation

You can install the development version of EMODnetWFS from GitHub with:

``` r
remotes::install_github("EMODnet/EMODnetWFS")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(EMODnetWFS)
## basic example code
```

### Available services

All available services are contained in the `emodnet_wfs` package
dataset.

| service\_name                                                    | service\_url                                                        |
|:-----------------------------------------------------------------|:--------------------------------------------------------------------|
| bathymetry                                                       | <https://ows.emodnet-bathymetry.eu/wfs>                             |
| biology                                                          | <http://geo.vliz.be/geoserver/Emodnetbio/wfs>                       |
| biology\_occurrence\_data                                        | <http://geo.vliz.be/geoserver/Dataportal/wfs>                       |
| chemistry\_marine\_litter                                        | <https://www.ifremer.fr/services/wfs/emodnet_chemistry2>            |
| chemistry\_time\_series\_location                                | <http://emodnet02.cineca.it/geoserver/wfs>                          |
| geology\_sea\_floor\_bedrock                                     | <https://drive.emodnet-geology.eu/geoserver/bgr/wfs>                |
| geology\_marine\_minerals                                        | <https://drive.emodnet-geology.eu/geoserver/gsi/wfs>                |
| geology\_seabed\_substrate\_maps                                 | <https://drive.emodnet-geology.eu/geoserver/gtk/wfs>                |
| geology\_events\_and\_probabilities                              | <https://drive.emodnet-geology.eu/geoserver/ispra/wfs>              |
| geology\_coastal\_behavior                                       | <https://drive.emodnet-geology.eu/geoserver/tno/wfs>                |
| geology\_submerged\_landscapes                                   | <https://drive.emodnet-geology.eu/geoserver/bgs/wfs>                |
| human\_activities                                                | <https://ows.emodnet-humanactivities.eu/wfs>                        |
| physics                                                          | <https://geoserver.emodnet-physics.eu/geoserver/emodnet/wfs>        |
| seabed\_habitats\_general\_datasets\_and\_products               | <https://ows.emodnet-seabedhabitats.eu/emodnet_open/wfs>            |
| seabed\_habitats\_individual\_habitat\_map\_and\_model\_datasets | <https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs> |

To explore available services in Rstudio use:

``` r
View(emodnet_wfs)
```

### Create Service Client

Create new WFS Client. The default service is
`seabed_habitats_individual_habitat_map_and_model_datasets`.

``` r
wfs <- emodnet_init_wfs_client()
#> Loading ISO 19139 XML schemas...
#> Loading ISO 19115 codelists...
#> Warning in CPL_crs_from_input(x): GDAL Message 1: +init=epsg:XXXX syntax is
#> deprecated. It might return a CRS with a non-EPSG compliant axis order.
#> √ WFS client created succesfully
#> i Service: 'https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs'
#> i Version: '2.0.0'
```

You can access further services using the `service` argument.

``` r
wfs_bath <- emodnet_init_wfs_client(service = "bathymetry")
#> √ WFS client created succesfully
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
#> √ WFS client created succesfully
#> i Service: 'https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs'
#> i Version: '2.0.0'
#> # A tibble: 850 x 9
#>    data_source service_name service_url layer_namespace layer_name title
#>    <chr>       <chr>        <chr>       <chr>           <chr>      <chr>
#>  1 emodnet_wfs seabed_habi~ https://ow~ emodnet_open_m~ be000225   BE00~
#>  2 emodnet_wfs seabed_habi~ https://ow~ emodnet_open_m~ be000226   BE00~
#>  3 emodnet_wfs seabed_habi~ https://ow~ emodnet_open_m~ be000227   BE00~
#>  4 emodnet_wfs seabed_habi~ https://ow~ emodnet_open_m~ be000228   BE00~
#>  5 emodnet_wfs seabed_habi~ https://ow~ emodnet_open_m~ dk004005   DK00~
#>  6 emodnet_wfs seabed_habi~ https://ow~ emodnet_open_m~ fr004015   FR00~
#>  7 emodnet_wfs seabed_habi~ https://ow~ emodnet_open_m~ gb001308   GB00~
#>  8 emodnet_wfs seabed_habi~ https://ow~ emodnet_open_m~ gb001517   GB00~
#>  9 emodnet_wfs seabed_habi~ https://ow~ emodnet_open_m~ gb100299   GB10~
#> 10 emodnet_wfs seabed_habi~ https://ow~ emodnet_open_m~ gb100355   GB10~
#> # ... with 840 more rows, and 3 more variables: abstract <chr>, class <chr>,
#> #   format <chr>
```

You can access information about a service using the `service` argument.

``` r
emodnet_get_wfs_info(service = "bathymetry")
#> √ WFS client created succesfully
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
#> √ WFS client created succesfully
#> i Service: 'https://www.ifremer.fr/services/wfs/emodnet_chemistry2'
#> i Version: '2.0.0'
emodnet_get_wfs_info(wfs_cml)
#> # A tibble: 20 x 9
#>    data_source service_name service_url layer_namespace layer_name title
#>    <chr>       <chr>        <chr>       <chr>           <chr>      <chr>
#>  1 emodnet_wfs seabed_habi~ https://ow~ ms              bl_beache~ Beac~
#>  2 emodnet_wfs seabed_habi~ https://ow~ ms              bl_tempor~ Numb~
#>  3 emodnet_wfs seabed_habi~ https://ow~ ms              bl_totala~ Beac~
#>  4 emodnet_wfs seabed_habi~ https://ow~ ms              bl_materi~ Beac~
#>  5 emodnet_wfs seabed_habi~ https://ow~ ms              bl_cigare~ Beac~
#>  6 emodnet_wfs seabed_habi~ https://ow~ ms              bl_cigare~ Beac~
#>  7 emodnet_wfs seabed_habi~ https://ow~ ms              bl_fishin~ Beac~
#>  8 emodnet_wfs seabed_habi~ https://ow~ ms              bl_plasti~ Beac~
#>  9 emodnet_wfs seabed_habi~ https://ow~ ms              bl_beache~ Beac~
#> 10 emodnet_wfs seabed_habi~ https://ow~ ms              bl_tempor~ Numb~
#> 11 emodnet_wfs seabed_habi~ https://ow~ ms              bl_totala~ Beac~
#> 12 emodnet_wfs seabed_habi~ https://ow~ ms              bl_materi~ Beac~
#> 13 emodnet_wfs seabed_habi~ https://ow~ ms              bl_cigare~ Beac~
#> 14 emodnet_wfs seabed_habi~ https://ow~ ms              bl_fishin~ Beac~
#> 15 emodnet_wfs seabed_habi~ https://ow~ ms              bl_plasti~ Beac~
#> 16 emodnet_wfs seabed_habi~ https://ow~ ms              sl_survey~ Seab~
#> 17 emodnet_wfs seabed_habi~ https://ow~ ms              sl_totala~ Seab~
#> 18 emodnet_wfs seabed_habi~ https://ow~ ms              sb_materi~ Seab~
#> 19 emodnet_wfs seabed_habi~ https://ow~ ms              sl_fishing Seab~
#> 20 emodnet_wfs seabed_habi~ https://ow~ ms              sl_plasti~ Seab~
#> # ... with 3 more variables: abstract <chr>, class <chr>, format <chr>

layers <- c("bl_fishing_cleaning",
          "bl_beacheslocations_2001_2008_monitoring")

emodnet_get_layer_info(wfs = wfs_cml, layers = layers)
#> # A tibble: 2 x 9
#>   data_source service_name service_url layer_namespace layer_name title abstract
#>   <chr>       <chr>        <chr>       <chr>           <chr>      <chr> <chr>   
#> 1 emodnet_wfs https://www~ chemistry_~ ms              bl_fishin~ Beac~ ""      
#> 2 emodnet_wfs https://www~ chemistry_~ ms              bl_beache~ Beac~ ""      
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
#> $bl_fishing_cleaning
#> Simple feature collection with 1904 features and 14 fields
#> geometry type:  POINT
#> dimension:      XY
#> bbox:           xmin: -53.60233 ymin: 28.39411 xmax: 41.77114 ymax: 81.68642
#> geographic CRS: WGS 84
#> First 10 features:
#>    gml_id id country country_name      beachcode beachname year
#> 1    <NA>  1      IT        Italy    0004-Poetto    Poetto 2015
#> 2    <NA>  2      IT        Italy    0004-Poetto    Poetto 2016
#> 3    <NA>  3      IT        Italy    0004-Poetto    Poetto 2017
#> 4    <NA>  4      IT        Italy 0028-Costa Rei Costa Rei 2015
#> 5    <NA>  5      IT        Italy 0028-Costa Rei Costa Rei 2016
#> 6    <NA>  6      IT        Italy 0028-Costa Rei Costa Rei 2017
#> 7    <NA>  7      IT        Italy  0122-La Cinta  La Cinta 2015
#> 8    <NA>  8      IT        Italy  0122-La Cinta  La Cinta 2016
#> 9    <NA>  9      IT        Italy  0122-La Cinta  La Cinta 2017
#> 10   <NA> 10      IT        Italy   0192-Alghero   Alghero 2015
#>             surveyyear nbsurvey surveylength surveytype litterreferencelist
#> 1  2015-01-01 00:00:00        3           30 Monitoring                 ITA
#> 2  2016-01-01 00:00:00        6        30/33 Monitoring                 ITA
#> 3  2017-01-01 00:00:00        3           33 Monitoring                 ITA
#> 4  2015-01-01 00:00:00        3           30 Monitoring                 ITA
#> 5  2016-01-01 00:00:00        3           30 Monitoring                 ITA
#> 6  2017-01-01 00:00:00        6           33 Monitoring                 ITA
#> 7  2015-01-01 00:00:00        3           30 Monitoring                 ITA
#> 8  2016-01-01 00:00:00        6        30/33 Monitoring                 ITA
#> 9  2017-01-01 00:00:00        3           33 Monitoring                 ITA
#> 10 2015-01-01 00:00:00        3           30 Monitoring                 ITA
#>              littergroup litterabundance                msGeometry
#> 1  Fishing related items            40.0 POINT (9.173474 39.21138)
#> 2  Fishing related items            36.6 POINT (9.173474 39.21138)
#> 3  Fishing related items           107.1 POINT (9.174917 39.21233)
#> 4  Fishing related items            13.3 POINT (9.582279 39.26557)
#> 5  Fishing related items             4.4 POINT (9.582279 39.26557)
#> 6  Fishing related items            23.2 POINT (9.581931 39.26485)
#> 7  Fishing related items            20.0 POINT (9.670319 40.78884)
#> 8  Fishing related items            13.8 POINT (9.670319 40.78884)
#> 9  Fishing related items             5.1 POINT (9.670457 40.78811)
#> 10 Fishing related items            37.8 POINT (8.307992 40.58419)
#> 
#> $bl_beacheslocations_2001_2008_monitoring
#> Simple feature collection with 581 features and 45 fields
#> geometry type:  POINT
#> dimension:      XY
#> bbox:           xmin: -53.60233 ymin: 28.39411 xmax: 41.77114 ymax: 81.68642
#> geographic CRS: WGS 84
#> First 10 features:
#>    gml_id id countryname       beachcode          beachname surveytype
#> 1    <NA>  1       Italy     0004-Poetto             Poetto Monitoring
#> 2    <NA>  2       Italy  0028-Costa Rei          Costa Rei Monitoring
#> 3    <NA>  3       Italy   0122-La Cinta           La Cinta Monitoring
#> 4    <NA>  4       Italy    0192-Alghero            Alghero Monitoring
#> 5    <NA>  5       Italy  0221-Is Arenas          Is Arenas Monitoring
#> 6    <NA>  6       Italy 0258-Porto Pino         Porto Pino Monitoring
#> 7    <NA>  7       Italy         1-R_PUG          Foce Lato Monitoring
#> 8    <NA>  8       Italy         3-F_PUG           San Vito Monitoring
#> 9    <NA>  9       Italy         4-P_PUG   Barletta Ponente Monitoring
#> 10   <NA> 10       Italy         6-R_PUG Bosco Isola Lesina Monitoring
#>    nbsurvey_tot      surveylength litterreferencelist abundance_2001
#> 1            12                30                 ITA              0
#> 2            12                30                 ITA              0
#> 3            12                30                 ITA              0
#> 4            12                30                 ITA              0
#> 5            12                30                 ITA              0
#> 6            12                30                 ITA              0
#> 7            12 26/29/33/34/35/37                 ITA              0
#> 8            12             30/44                 ITA              0
#> 9            11       31/33/35/43                 ITA              0
#> 10           12             32/35                 ITA              0
#>    nbsurvey_2001 abundance_2002 nbsurvey_2002 abundance_2003 nbsurvey_2003
#> 1              0              0             0              0             0
#> 2              0              0             0              0             0
#> 3              0              0             0              0             0
#> 4              0              0             0              0             0
#> 5              0              0             0              0             0
#> 6              0              0             0              0             0
#> 7              0              0             0              0             0
#> 8              0              0             0              0             0
#> 9              0              0             0              0             0
#> 10             0              0             0              0             0
#>    abundance_2004 nbsurvey_2004 abundance_2005 nbsurvey_2005 abundance_2006
#> 1               0             0              0             0              0
#> 2               0             0              0             0              0
#> 3               0             0              0             0              0
#> 4               0             0              0             0              0
#> 5               0             0              0             0              0
#> 6               0             0              0             0              0
#> 7               0             0              0             0              0
#> 8               0             0              0             0              0
#> 9               0             0              0             0              0
#> 10              0             0              0             0              0
#>    nbsurvey_2006 abundance_2007 nbsurvey_2007 abundance_2008 nbsurvey_2008
#> 1              0              0             0              0             0
#> 2              0              0             0              0             0
#> 3              0              0             0              0             0
#> 4              0              0             0              0             0
#> 5              0              0             0              0             0
#> 6              0              0             0              0             0
#> 7              0              0             0              0             0
#> 8              0              0             0              0             0
#> 9              0              0             0              0             0
#> 10             0              0             0              0             0
#>    abundance_2009 nbsurvey_2009 abundance_2010 nbsurvey_2010 abundance_2011
#> 1               0             0              0             0              0
#> 2               0             0              0             0              0
#> 3               0             0              0             0              0
#> 4               0             0              0             0              0
#> 5               0             0              0             0              0
#> 6               0             0              0             0              0
#> 7               0             0              0             0              0
#> 8               0             0              0             0              0
#> 9               0             0              0             0              0
#> 10              0             0              0             0              0
#>    nbsurvey_2011 abundance_2012 nbsurvey_2012 abundance_2013 nbsurvey_2013
#> 1              0              0             0              0             0
#> 2              0              0             0              0             0
#> 3              0              0             0              0             0
#> 4              0              0             0              0             0
#> 5              0              0             0              0             0
#> 6              0              0             0              0             0
#> 7              0              0             0              0             0
#> 8              0              0             0              0             0
#> 9              0              0             0              0             0
#> 10             0              0             0              0             0
#>    abundance_2014 nbsurvey_2014 abundance_2015 nbsurvey_2015 abundance_2016
#> 1               0             0          395.6             3          380.5
#> 2               0             0          586.7             3          166.7
#> 3               0             0          327.8             3          180.8
#> 4               0             0          747.8             3         1086.7
#> 5               0             0         1274.4             3         2620.2
#> 6               0             0          201.1             3          149.7
#> 7               0             0         1409.5             3         1852.4
#> 8               0             0          481.2             3          358.0
#> 9               0             0          315.6             3          460.4
#> 10              0             0          489.1             3          484.2
#>    nbsurvey_2016 abundance_2017 nbsurvey_2017 abundance_2018 nbsurvey_2018
#> 1              6          933.3             3              0             0
#> 2              3          316.7             6              0             0
#> 3              6           41.4             3              0             0
#> 4              6          933.3             3              0             0
#> 5              6         3564.6             3              0             0
#> 6              6          149.5             3              0             0
#> 7              6         1464.6             3              0             0
#> 8              6          350.5             3              0             0
#> 9              6          399.5             2              0             0
#> 10             6          693.1             3              0             0
#>                   msGeometry
#> 1  POINT (9.173474 39.21138)
#> 2  POINT (9.582279 39.26557)
#> 3  POINT (9.670319 40.78884)
#> 4  POINT (8.307992 40.58419)
#> 5  POINT (8.477852 40.06865)
#> 6  POINT (8.613158 38.95725)
#> 7  POINT (15.38992 41.90055)
#> 8  POINT (16.25158 41.33276)
#> 9  POINT (17.99906 40.64842)
#> 10 POINT (18.25035 39.83537)
```

You can chage the output crs through argument `crs`.

``` r
emodnet_get_layers(wfs = wfs_cml, layers = layers, crs = 3857)
#> i crs transformed from 4326 to 3857
#> i crs transformed from 4326 to 3857
#> $bl_fishing_cleaning
#> Simple feature collection with 1904 features and 14 fields
#> geometry type:  POINT
#> dimension:      XY
#> bbox:           xmin: -5966984 ymin: 3298754 xmax: 4649942 ymax: 16721730
#> projected CRS:  WGS 84 / Pseudo-Mercator
#> First 10 features:
#>    gml_id id country country_name      beachcode beachname year
#> 1    <NA>  1      IT        Italy    0004-Poetto    Poetto 2015
#> 2    <NA>  2      IT        Italy    0004-Poetto    Poetto 2016
#> 3    <NA>  3      IT        Italy    0004-Poetto    Poetto 2017
#> 4    <NA>  4      IT        Italy 0028-Costa Rei Costa Rei 2015
#> 5    <NA>  5      IT        Italy 0028-Costa Rei Costa Rei 2016
#> 6    <NA>  6      IT        Italy 0028-Costa Rei Costa Rei 2017
#> 7    <NA>  7      IT        Italy  0122-La Cinta  La Cinta 2015
#> 8    <NA>  8      IT        Italy  0122-La Cinta  La Cinta 2016
#> 9    <NA>  9      IT        Italy  0122-La Cinta  La Cinta 2017
#> 10   <NA> 10      IT        Italy   0192-Alghero   Alghero 2015
#>             surveyyear nbsurvey surveylength surveytype litterreferencelist
#> 1  2015-01-01 00:00:00        3           30 Monitoring                 ITA
#> 2  2016-01-01 00:00:00        6        30/33 Monitoring                 ITA
#> 3  2017-01-01 00:00:00        3           33 Monitoring                 ITA
#> 4  2015-01-01 00:00:00        3           30 Monitoring                 ITA
#> 5  2016-01-01 00:00:00        3           30 Monitoring                 ITA
#> 6  2017-01-01 00:00:00        6           33 Monitoring                 ITA
#> 7  2015-01-01 00:00:00        3           30 Monitoring                 ITA
#> 8  2016-01-01 00:00:00        6        30/33 Monitoring                 ITA
#> 9  2017-01-01 00:00:00        3           33 Monitoring                 ITA
#> 10 2015-01-01 00:00:00        3           30 Monitoring                 ITA
#>              littergroup litterabundance               msGeometry
#> 1  Fishing related items            40.0  POINT (1021186 4751995)
#> 2  Fishing related items            36.6  POINT (1021186 4751995)
#> 3  Fishing related items           107.1  POINT (1021347 4752132)
#> 4  Fishing related items            13.3  POINT (1066694 4759784)
#> 5  Fishing related items             4.4  POINT (1066694 4759784)
#> 6  Fishing related items            23.2  POINT (1066656 4759680)
#> 7  Fishing related items            20.0  POINT (1076495 4981246)
#> 8  Fishing related items            13.8  POINT (1076495 4981246)
#> 9  Fishing related items             5.1  POINT (1076510 4981138)
#> 10 Fishing related items            37.8 POINT (924841.4 4951202)
#> 
#> $bl_beacheslocations_2001_2008_monitoring
#> Simple feature collection with 581 features and 45 fields
#> geometry type:  POINT
#> dimension:      XY
#> bbox:           xmin: -5966984 ymin: 3298754 xmax: 4649942 ymax: 16721730
#> projected CRS:  WGS 84 / Pseudo-Mercator
#> First 10 features:
#>    gml_id id countryname       beachcode          beachname surveytype
#> 1    <NA>  1       Italy     0004-Poetto             Poetto Monitoring
#> 2    <NA>  2       Italy  0028-Costa Rei          Costa Rei Monitoring
#> 3    <NA>  3       Italy   0122-La Cinta           La Cinta Monitoring
#> 4    <NA>  4       Italy    0192-Alghero            Alghero Monitoring
#> 5    <NA>  5       Italy  0221-Is Arenas          Is Arenas Monitoring
#> 6    <NA>  6       Italy 0258-Porto Pino         Porto Pino Monitoring
#> 7    <NA>  7       Italy         1-R_PUG          Foce Lato Monitoring
#> 8    <NA>  8       Italy         3-F_PUG           San Vito Monitoring
#> 9    <NA>  9       Italy         4-P_PUG   Barletta Ponente Monitoring
#> 10   <NA> 10       Italy         6-R_PUG Bosco Isola Lesina Monitoring
#>    nbsurvey_tot      surveylength litterreferencelist abundance_2001
#> 1            12                30                 ITA              0
#> 2            12                30                 ITA              0
#> 3            12                30                 ITA              0
#> 4            12                30                 ITA              0
#> 5            12                30                 ITA              0
#> 6            12                30                 ITA              0
#> 7            12 26/29/33/34/35/37                 ITA              0
#> 8            12             30/44                 ITA              0
#> 9            11       31/33/35/43                 ITA              0
#> 10           12             32/35                 ITA              0
#>    nbsurvey_2001 abundance_2002 nbsurvey_2002 abundance_2003 nbsurvey_2003
#> 1              0              0             0              0             0
#> 2              0              0             0              0             0
#> 3              0              0             0              0             0
#> 4              0              0             0              0             0
#> 5              0              0             0              0             0
#> 6              0              0             0              0             0
#> 7              0              0             0              0             0
#> 8              0              0             0              0             0
#> 9              0              0             0              0             0
#> 10             0              0             0              0             0
#>    abundance_2004 nbsurvey_2004 abundance_2005 nbsurvey_2005 abundance_2006
#> 1               0             0              0             0              0
#> 2               0             0              0             0              0
#> 3               0             0              0             0              0
#> 4               0             0              0             0              0
#> 5               0             0              0             0              0
#> 6               0             0              0             0              0
#> 7               0             0              0             0              0
#> 8               0             0              0             0              0
#> 9               0             0              0             0              0
#> 10              0             0              0             0              0
#>    nbsurvey_2006 abundance_2007 nbsurvey_2007 abundance_2008 nbsurvey_2008
#> 1              0              0             0              0             0
#> 2              0              0             0              0             0
#> 3              0              0             0              0             0
#> 4              0              0             0              0             0
#> 5              0              0             0              0             0
#> 6              0              0             0              0             0
#> 7              0              0             0              0             0
#> 8              0              0             0              0             0
#> 9              0              0             0              0             0
#> 10             0              0             0              0             0
#>    abundance_2009 nbsurvey_2009 abundance_2010 nbsurvey_2010 abundance_2011
#> 1               0             0              0             0              0
#> 2               0             0              0             0              0
#> 3               0             0              0             0              0
#> 4               0             0              0             0              0
#> 5               0             0              0             0              0
#> 6               0             0              0             0              0
#> 7               0             0              0             0              0
#> 8               0             0              0             0              0
#> 9               0             0              0             0              0
#> 10              0             0              0             0              0
#>    nbsurvey_2011 abundance_2012 nbsurvey_2012 abundance_2013 nbsurvey_2013
#> 1              0              0             0              0             0
#> 2              0              0             0              0             0
#> 3              0              0             0              0             0
#> 4              0              0             0              0             0
#> 5              0              0             0              0             0
#> 6              0              0             0              0             0
#> 7              0              0             0              0             0
#> 8              0              0             0              0             0
#> 9              0              0             0              0             0
#> 10             0              0             0              0             0
#>    abundance_2014 nbsurvey_2014 abundance_2015 nbsurvey_2015 abundance_2016
#> 1               0             0          395.6             3          380.5
#> 2               0             0          586.7             3          166.7
#> 3               0             0          327.8             3          180.8
#> 4               0             0          747.8             3         1086.7
#> 5               0             0         1274.4             3         2620.2
#> 6               0             0          201.1             3          149.7
#> 7               0             0         1409.5             3         1852.4
#> 8               0             0          481.2             3          358.0
#> 9               0             0          315.6             3          460.4
#> 10              0             0          489.1             3          484.2
#>    nbsurvey_2016 abundance_2017 nbsurvey_2017 abundance_2018 nbsurvey_2018
#> 1              6          933.3             3              0             0
#> 2              3          316.7             6              0             0
#> 3              6           41.4             3              0             0
#> 4              6          933.3             3              0             0
#> 5              6         3564.6             3              0             0
#> 6              6          149.5             3              0             0
#> 7              6         1464.6             3              0             0
#> 8              6          350.5             3              0             0
#> 9              6          399.5             2              0             0
#> 10             6          693.1             3              0             0
#>                  msGeometry
#> 1   POINT (1021186 4751995)
#> 2   POINT (1066694 4759784)
#> 3   POINT (1076495 4981246)
#> 4  POINT (924841.4 4951202)
#> 5  POINT (943750.2 4875924)
#> 6  POINT (958812.4 4715550)
#> 7   POINT (1713198 5146094)
#> 8   POINT (1809118 5061549)
#> 9   POINT (2003646 4960621)
#> 10  POINT (2031619 4842048)
```

You can also extract layers directly from a WFS service The default
service is `seabed_habitats_individual_habitat_map_and_model_datasets`.

``` r
emodnet_get_layers(layers = c("dk003069", "dk003070"))
#> √ WFS client created succesfully
#> i Service: 'https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs'
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
#>                                     gml_id   gid      gui polygon annexi
#> 1  dk003069.fid-2788feed_1774492d47b_-33c2 39844 DK003069      61   1170
#> 2  dk003069.fid-2788feed_1774492d47b_-33c1 39855 DK003069      72   1110
#> 3  dk003069.fid-2788feed_1774492d47b_-33c0 39860 DK003069      77   1110
#> 4  dk003069.fid-2788feed_1774492d47b_-33bf 39861 DK003069      78   1110
#> 5  dk003069.fid-2788feed_1774492d47b_-33be 39785 DK003069       2   1170
#> 6  dk003069.fid-2788feed_1774492d47b_-33bd 39814 DK003069      31   1170
#> 7  dk003069.fid-2788feed_1774492d47b_-33bc 39791 DK003069       8   1170
#> 8  dk003069.fid-2788feed_1774492d47b_-33bb 39836 DK003069      53   1170
#> 9  dk003069.fid-2788feed_1774492d47b_-33ba 39829 DK003069      46   1170
#> 10 dk003069.fid-2788feed_1774492d47b_-33b9 39850 DK003069      67   1110
#>            subtype confidence val_comm                           geom
#> 1  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((10....
#> 2             <NA>       High     <NA> MULTISURFACE (POLYGON ((9.7...
#> 3             <NA>       High     <NA> MULTISURFACE (POLYGON ((10....
#> 4             <NA>       High     <NA> MULTISURFACE (POLYGON ((9.7...
#> 5  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((10....
#> 6  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((10....
#> 7  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((9.8...
#> 8  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((9.7...
#> 9  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((9.7...
#> 10            <NA>       High     <NA> MULTISURFACE (POLYGON ((9.9...
#> 
#> $dk003070
#> Simple feature collection with 30 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 11.39643 ymin: 54.55514 xmax: 11.96792 ymax: 54.63234
#> geographic CRS: WGS 84
#> First 10 features:
#>                                     gml_id   gid      gui polygon annexi
#> 1  dk003070.fid-2788feed_1774492d47b_-3352 39889 DK003070      24   1170
#> 2  dk003070.fid-2788feed_1774492d47b_-3351 39888 DK003070      23   1170
#> 3  dk003070.fid-2788feed_1774492d47b_-3350 39883 DK003070      18   1170
#> 4  dk003070.fid-2788feed_1774492d47b_-334f 39892 DK003070      27   1170
#> 5  dk003070.fid-2788feed_1774492d47b_-334e 39876 DK003070      11   1170
#> 6  dk003070.fid-2788feed_1774492d47b_-334d 39880 DK003070      15   1170
#> 7  dk003070.fid-2788feed_1774492d47b_-334c 39869 DK003070       4   1170
#> 8  dk003070.fid-2788feed_1774492d47b_-334b 39866 DK003070       1   1170
#> 9  dk003070.fid-2788feed_1774492d47b_-334a 39894 DK003070      29   1170
#> 10 dk003070.fid-2788feed_1774492d47b_-3349 39878 DK003070      13   1170
#>            subtype confidence val_comm                           geom
#> 1  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((11....
#> 2  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((11....
#> 3  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((11....
#> 4  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((11....
#> 5  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((11....
#> 6  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((11....
#> 7  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((11....
#> 8  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((11....
#> 9  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((11....
#> 10 Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((11....
```

Use argument `service` to specify the required service.

``` r
human_activities <- emodnet_get_layers(service = "human_activities", 
                   layers = c("aquaculture", "dredging"))
#> √ WFS client created succesfully
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
#>                                     gml_id gid legalfound
#> 1 aquaculture.fid-ed6af79_17744793007_-ac0  17 2016-07-12
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
#> √ WFS client created succesfully
#> i Service: 'https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs'
#> i Version: '2.0.0'
#> i crs transformed from 3857 to 4326
#> Simple feature collection with 112 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 9.575308 ymin: 54.55514 xmax: 11.96792 ymax: 55.12132
#> geographic CRS: WGS 84
#> First 10 features:
#>                                   gml_id   gid      gui polygon annexi
#> 1  dk003069.fid-2788feed_1774492d47b_4e8 39844 DK003069      61   1170
#> 2  dk003069.fid-2788feed_1774492d47b_4e9 39855 DK003069      72   1110
#> 3  dk003069.fid-2788feed_1774492d47b_4ea 39860 DK003069      77   1110
#> 4  dk003069.fid-2788feed_1774492d47b_4eb 39861 DK003069      78   1110
#> 5  dk003069.fid-2788feed_1774492d47b_4ec 39785 DK003069       2   1170
#> 6  dk003069.fid-2788feed_1774492d47b_4ed 39814 DK003069      31   1170
#> 7  dk003069.fid-2788feed_1774492d47b_4ee 39791 DK003069       8   1170
#> 8  dk003069.fid-2788feed_1774492d47b_4ef 39836 DK003069      53   1170
#> 9  dk003069.fid-2788feed_1774492d47b_4f0 39829 DK003069      46   1170
#> 10 dk003069.fid-2788feed_1774492d47b_4f1 39850 DK003069      67   1110
#>            subtype confidence val_comm                           geom
#> 1  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((10....
#> 2             <NA>       High     <NA> MULTISURFACE (POLYGON ((9.7...
#> 3             <NA>       High     <NA> MULTISURFACE (POLYGON ((10....
#> 4             <NA>       High     <NA> MULTISURFACE (POLYGON ((9.7...
#> 5  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((10....
#> 6  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((10....
#> 7  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((9.8...
#> 8  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((9.7...
#> 9  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((9.7...
#> 10            <NA>       High     <NA> MULTISURFACE (POLYGON ((9.9...
```

``` r
emodnet_get_layers(wfs = wfs_cml, layers = layers,
                   reduce_layers = TRUE)
#> Error: Cannot reduce layers.
#> Try again with `reduce_layers = FALSE`
```
