
<!-- README.md is generated from README.Rmd. Please edit that file -->

# EMODnetWFS

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/annakrystalli/EMODnetWFS/workflows/R-CMD-check/badge.svg)](https://github.com/annakrystalli/EMODnetWFS/actions)
<!-- badges: end -->

The goal of EMODnetWFS is to allow interrogation and access to the
EMODnet Web Feature Services data in R.

## Installation

You can install the development version of EMODnetWFS from GitHub with:

``` r
remotes::install_github("annakrystalli/EMODnetWFS")
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
| :--------------------------------------------------------------- | :------------------------------------------------------------------ |
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
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs'
#> ℹ Version: '2.0.0'
```

You can access further services through the `service`.

``` r

wfs_bath <- emodnet_init_wfs_client(service = "bathymetry")
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://ows.emodnet-bathymetry.eu/wfs'
#> ℹ Version: '2.0.0'

wfs_bath$getUrl()
#> [1] "https://ows.emodnet-bathymetry.eu/wfs"
```

## Get WFS Layer info

``` r
emodnet_get_wfs_info()
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs'
#> ℹ Version: '2.0.0'
#> # A tibble: 688 x 5
#>    layer_namespace   layer_name title               abstract              class 
#>    <chr>             <chr>      <chr>               <chr>                 <chr> 
#>  1 emodnet_open_map… be000071   BE000071            "Habitat map \"BE000… WFSFe…
#>  2 emodnet_open_map… be000225   BE000225            "Habitat map \"BE000… WFSFe…
#>  3 emodnet_open_map… be000226   BE000226            "Habitat map \"BE000… WFSFe…
#>  4 emodnet_open_map… be000227   BE000227            "Habitat map \"BE000… WFSFe…
#>  5 emodnet_open_map… be000228   BE000228            "Habitat map \"BE000… WFSFe…
#>  6 emodnet_open_map… be000231   BE000231            "Habitat map \"BE000… WFSFe…
#>  7 emodnet_open_map… gb001308   GB001308            "Habitat map \"GB001… WFSFe…
#>  8 emodnet_open_map… nl000065   NL000065            "Habitat map \"NL000… WFSFe…
#>  9 emodnet_open_map… nl000066   NL000066            "Habitat map \"NL000… WFSFe…
#> 10 emodnet_open_map… be000007   [BE000007] Project… "Area West Coast, po… WFSFe…
#> # … with 678 more rows
```

You can access information about a service using the `service` argument.

``` r
emodnet_get_wfs_info(service = "bathymetry")
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://ows.emodnet-bathymetry.eu/wfs'
#> ℹ Version: '2.0.0'
#> # A tibble: 4 x 5
#>   layer_namespace layer_name     title         abstract                  class  
#>   <chr>           <chr>          <chr>         <chr>                     <chr>  
#> 1 emodnet         contours       Depth contou… "Generalised bathymetric… WFSFea…
#> 2 emodnet         quality_index  Quality index "Representation of vario… WFSFea…
#> 3 emodnet         source_refere… Source refer… "Coverage of individual … WFSFea…
#> 4 emodnet         source_refere… Source refer… "Coverage of individual … WFSFea…
```

or you can pass a wfs client object.

``` r
emodnet_get_wfs_info(wfs_bath)
#> # A tibble: 4 x 5
#>   layer_namespace layer_name     title         abstract                  class  
#>   <chr>           <chr>          <chr>         <chr>                     <chr>  
#> 1 emodnet         contours       Depth contou… "Generalised bathymetric… WFSFea…
#> 2 emodnet         quality_index  Quality index "Representation of vario… WFSFea…
#> 3 emodnet         source_refere… Source refer… "Coverage of individual … WFSFea…
#> 4 emodnet         source_refere… Source refer… "Coverage of individual … WFSFea…
```

## Get WFS layers

``` r
emodnet_get_layers(layers = c("dk003069", "dk003070"))
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs'
#> ℹ Version: '2.0.0'
#> $dk003069
#> Simple feature collection with 82 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 1065918 ymin: 7318084 xmax: 1140377 ymax: 7385447
#> epsg (SRID):    3857
#> proj4string:    +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs
#> First 10 features:
#>                                    gml_id   gid      gui polygon annexi
#> 1  dk003069.fid-7f7ff433_172b8aad37a_1ec0 39863 DK003069      80   1110
#> 2  dk003069.fid-7f7ff433_172b8aad37a_1ec1 39791 DK003069       8   1170
#> 3  dk003069.fid-7f7ff433_172b8aad37a_1ec2 39796 DK003069      13   1170
#> 4  dk003069.fid-7f7ff433_172b8aad37a_1ec3 39810 DK003069      27   1170
#> 5  dk003069.fid-7f7ff433_172b8aad37a_1ec4 39804 DK003069      21   1170
#> 6  dk003069.fid-7f7ff433_172b8aad37a_1ec5 39855 DK003069      72   1110
#> 7  dk003069.fid-7f7ff433_172b8aad37a_1ec6 39860 DK003069      77   1110
#> 8  dk003069.fid-7f7ff433_172b8aad37a_1ec7 39799 DK003069      16   1170
#> 9  dk003069.fid-7f7ff433_172b8aad37a_1ec8 39848 DK003069      65   1110
#> 10 dk003069.fid-7f7ff433_172b8aad37a_1ec9 39790 DK003069       7   1170
#>            subtype confidence val_comm                           geom
#> 1             <NA>       High     <NA> MULTISURFACE (POLYGON ((107...
#> 2  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((109...
#> 3  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((110...
#> 4  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((110...
#> 5  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((109...
#> 6             <NA>       High     <NA> MULTISURFACE (POLYGON ((108...
#> 7             <NA>       High     <NA> MULTISURFACE (POLYGON ((111...
#> 8  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((110...
#> 9             <NA>       High     <NA> MULTISURFACE (POLYGON ((110...
#> 10 Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((109...
#> 
#> $dk003070
#> Simple feature collection with 30 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 1268645 ymin: 7276003 xmax: 1332262 ymax: 7290836
#> epsg (SRID):    3857
#> proj4string:    +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs
#> First 10 features:
#>                                    gml_id   gid      gui polygon annexi
#> 1  dk003070.fid-7f7ff433_172b8aad37a_1f30 39869 DK003070       4   1170
#> 2  dk003070.fid-7f7ff433_172b8aad37a_1f31 39888 DK003070      23   1170
#> 3  dk003070.fid-7f7ff433_172b8aad37a_1f32 39866 DK003070       1   1170
#> 4  dk003070.fid-7f7ff433_172b8aad37a_1f33 39894 DK003070      29   1170
#> 5  dk003070.fid-7f7ff433_172b8aad37a_1f34 39884 DK003070      19   1170
#> 6  dk003070.fid-7f7ff433_172b8aad37a_1f35 39895 DK003070      30   1110
#> 7  dk003070.fid-7f7ff433_172b8aad37a_1f36 39877 DK003070      12   1170
#> 8  dk003070.fid-7f7ff433_172b8aad37a_1f37 39878 DK003070      13   1170
#> 9  dk003070.fid-7f7ff433_172b8aad37a_1f38 39872 DK003070       7   1170
#> 10 dk003070.fid-7f7ff433_172b8aad37a_1f39 39871 DK003070       6   1170
#>            subtype confidence val_comm                           geom
#> 1  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((127...
#> 2  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((129...
#> 3  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((127...
#> 4  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((132...
#> 5  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((130...
#> 6             <NA>       High     <NA> MULTISURFACE (POLYGON ((132...
#> 7  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((130...
#> 8  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((128...
#> 9  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((130...
#> 10 Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((130...
```

Layers can also be returned to a single `sf` object through argument
`reduce_layers`. If `TRUE` the function will try to reduce all layers
into a single `sf` if possible.

``` r

emodnet_get_layers(layers = c("dk003069", "dk003070"), reduce_layers = TRUE)
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs'
#> ℹ Version: '2.0.0'
#> Simple feature collection with 112 features and 8 fields
#> geometry type:  MULTISURFACE
#> dimension:      XY
#> bbox:           xmin: 1065918 ymin: 7276003 xmax: 1332262 ymax: 7385447
#> epsg (SRID):    3857
#> proj4string:    +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs
#> First 10 features:
#>                                    gml_id   gid      gui polygon annexi
#> 1  dk003069.fid-7f7ff433_172b8aad37a_1fa0 39863 DK003069      80   1110
#> 2  dk003069.fid-7f7ff433_172b8aad37a_1fa1 39791 DK003069       8   1170
#> 3  dk003069.fid-7f7ff433_172b8aad37a_1fa2 39796 DK003069      13   1170
#> 4  dk003069.fid-7f7ff433_172b8aad37a_1fa3 39810 DK003069      27   1170
#> 5  dk003069.fid-7f7ff433_172b8aad37a_1fa4 39804 DK003069      21   1170
#> 6  dk003069.fid-7f7ff433_172b8aad37a_1fa5 39855 DK003069      72   1110
#> 7  dk003069.fid-7f7ff433_172b8aad37a_1fa6 39860 DK003069      77   1110
#> 8  dk003069.fid-7f7ff433_172b8aad37a_1fa7 39799 DK003069      16   1170
#> 9  dk003069.fid-7f7ff433_172b8aad37a_1fa8 39848 DK003069      65   1110
#> 10 dk003069.fid-7f7ff433_172b8aad37a_1fa9 39790 DK003069       7   1170
#>            subtype confidence val_comm                           geom
#> 1             <NA>       High     <NA> MULTISURFACE (POLYGON ((107...
#> 2  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((109...
#> 3  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((110...
#> 4  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((110...
#> 5  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((109...
#> 6             <NA>       High     <NA> MULTISURFACE (POLYGON ((108...
#> 7             <NA>       High     <NA> MULTISURFACE (POLYGON ((111...
#> 8  Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((110...
#> 9             <NA>       High     <NA> MULTISURFACE (POLYGON ((110...
#> 10 Geogenic origin       High     <NA> MULTISURFACE (POLYGON ((109...
```

``` r
#emodnet_get_layers(wfs_bath, layers = "source_references_2016")
```
