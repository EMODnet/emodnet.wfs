
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

## Create Service Client

Create new WFS Client. Specify the service using the `service` argument.

``` r
wfs_bath <- emodnet_init_wfs_client(service = "bathymetry")
#> Loading ISO 19139 XML schemas...
#> Loading ISO 19115 codelists...
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://ows.emodnet-bathymetry.eu/wfs'
#> ℹ Version: '2.0.0'

wfs_bath$getUrl()
#> [1] "https://ows.emodnet-bathymetry.eu/wfs"
```

## Get WFS Layer info

You can get metadata about the layers available from a service.

``` r
emodnet_get_wfs_info(service = "bathymetry")
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://ows.emodnet-bathymetry.eu/wfs'
#> ℹ Version: '2.0.0'
#> # A tibble: 3 × 9
#>   data_source service_name service_url layer_namespace layer_name title abstract
#>   <chr>       <chr>        <chr>       <chr>           <chr>      <chr> <chr>   
#> 1 emodnet_wfs bathymetry   https://ow… emodnet         contours   Dept… "Genera…
#> 2 emodnet_wfs bathymetry   https://ow… emodnet         quality_i… Qual… "Repres…
#> 3 emodnet_wfs bathymetry   https://ow… emodnet         source_re… Sour… "Covera…
#> # … with 2 more variables: class <chr>, format <chr>
```

or you can pass a wfs client object.

``` r
emodnet_get_wfs_info(wfs_bath)
#> # A tibble: 3 × 9
#>   data_source service_name service_url layer_namespace layer_name title abstract
#>   <chr>       <chr>        <chr>       <chr>           <chr>      <chr> <chr>   
#> 1 emodnet_wfs bathymetry   https://ow… emodnet         contours   Dept… "Genera…
#> 2 emodnet_wfs bathymetry   https://ow… emodnet         quality_i… Qual… "Repres…
#> 3 emodnet_wfs bathymetry   https://ow… emodnet         source_re… Sour… "Covera…
#> # … with 2 more variables: class <chr>, format <chr>
```

You can also get info for specific layers from wfs object:

``` r
wfs_cml <- emodnet_init_wfs_client("chemistry_marine_litter")
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://www.ifremer.fr/services/wfs/emodnet_chemistry2'
#> ℹ Version: '2.0.0'
emodnet_get_wfs_info(wfs_cml)
#> # A tibble: 21 × 9
#>    data_source service_name  service_url    layer_namespace layer_name  title   
#>    <chr>       <chr>         <chr>          <chr>           <chr>       <chr>   
#>  1 emodnet_wfs chemistry_ma… https://www.i… ms              bl_beaches… Beaches…
#>  2 emodnet_wfs chemistry_ma… https://www.i… ms              bl_tempora… Number …
#>  3 emodnet_wfs chemistry_ma… https://www.i… ms              bl_totalab… Beach L…
#>  4 emodnet_wfs chemistry_ma… https://www.i… ms              bl_materia… Beach L…
#>  5 emodnet_wfs chemistry_ma… https://www.i… ms              bl_cigaret… Beach L…
#>  6 emodnet_wfs chemistry_ma… https://www.i… ms              bl_cigaret… Beach L…
#>  7 emodnet_wfs chemistry_ma… https://www.i… ms              bl_fishing… Beach L…
#>  8 emodnet_wfs chemistry_ma… https://www.i… ms              bl_plastic… Beach L…
#>  9 emodnet_wfs chemistry_ma… https://www.i… ms              bl_beaches… Beaches…
#> 10 emodnet_wfs chemistry_ma… https://www.i… ms              bl_tempora… Number …
#> # … with 11 more rows, and 3 more variables: abstract <chr>, class <chr>,
#> #   format <chr>

layers <- c("bl_fishing_monitoring",
          "bl_beacheslocations_2001_2008_monitoring")

emodnet_get_layer_info(wfs = wfs_cml, layers = layers)
#> # A tibble: 1 × 9
#>   data_source service_name service_url layer_namespace layer_name title abstract
#>   <chr>       <chr>        <chr>       <chr>           <chr>      <chr> <chr>   
#> 1 emodnet_wfs https://www… chemistry_… ms              bl_fishin… Beac… ""      
#> # … with 2 more variables: class <chr>, format <chr>
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
```

You can change the output `crs` through argument `crs`.

``` r
emodnet_get_layers(wfs = wfs_cml, layers = layers, crs = 3857)
#> ℹ crs transformed to 3857
```

You can also extract layers directly from a WFS service.

``` r
emodnet_get_layers(service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                   layers = c("dk003069", "dk003070"))
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs'
#> ℹ Version: '2.0.0'
```

Layers can also be returned to a single `sf` object through argument
`reduce_layers`. If `TRUE` the function will try to reduce all layers
into a single `sf`.

``` r
emodnet_get_layers(service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                   layers = c("dk003069", "dk003070"), 
                   reduce_layers = TRUE)
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs'
#> ℹ Version: '2.0.0'
```

If attempting to reduce fails, it will return a list with a warning:

``` r
emodnet_get_layers(wfs = wfs_cml, layers = layers,
                   reduce_layers = TRUE)
```

Using `reduce_layers = TRUE` is also useful for returning an `sf` object
rather than a list in single layer request.

``` r
emodnet_get_layers(service = "seabed_habitats_individual_habitat_map_and_model_datasets",
                  layers = c("dk003069"), 
                   reduce_layers = TRUE)
#> ✓ WFS client created succesfully
#> ℹ Service: 'https://ows.emodnet-seabedhabitats.eu/geoserver/emodnet_open_maplibrary/wfs'
#> ℹ Version: '2.0.0'
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
