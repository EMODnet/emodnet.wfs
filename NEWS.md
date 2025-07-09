# emodnet.wfs 2.1.1

# emodnet.wfs 2.1.0

* Improved documentation following rOpenSci reviews: manual pages, README, vignettes.

* Renamed `reduce_layers` argument to `simplify`.

* `emodnet_wfs()` now really returns a tibble, not a data.frame.

* Listed reviewers in DESCRIPTION.

* Set up a better escape mechanism for examples that could fail when services are 
down, but ensure they are rendered in the pkgdown website.


# emodnet.wfs 2.0.2

* Added ability to pass vendor parameter to `emodnet.wfs::emodnet_get_layers()` queries (#88).
* Added memoising (caching during each R session) of the functions getting services
 and layers information (#52).

# emodnet.wfs 2.0.1

* Introduced better handling of server response errors.

# emodnet.wfs 2.0.0


* NEW FEATURE: Added `ecql` filtering capability and ability to interrogate feature attribute (see relevant vignette).
* Bug fix: corrected service namespace definition when using a `wfs` object
* Breaking Change: set to extract default CRS from service information (through `getDeafultCRS` method)
* Breaking change: Removed default service value.
* Updated to new EMODnet Seabed Habitats endpoints
* Added a `NEWS.md` file to track changes to the package.
