<!---
Below, please enter values for (1) submitting author GitHub handle (replacing "@github_handle@); and (2) Repository URL (replacing "https://repourl"). Values for additional package authors may also be specified, replacing "@github_handle1", "@github_handle2" - delete these if not needed. DO NOT DELETE HTML SYMBOLS (everything between "<!" and ">"). Replace only "@github_handle" and "https://repourl". This comment may be deleted once it has been read and understood.
--->

Submitting Author Name: Maëlle Salmon
Submitting Author Github Handle: <!--author1-->@maelle<!--end-author1-->
Other Package Authors Github handles: (comma separated, delete if none) <!--author-others-->@salvafern, @annakrystalli<!--end-author-others-->
Repository:  <!--repourl-->https://github.com/EMODnet/emodnet.wfs/<!--end-repourl-->
Version submitted: 2.0.2
Submission type: <!--submission-type-->Standard<!--end-submission-type-->
Editor: <!--editor--> TBD <!--end-editor-->
Reviewers: <!--reviewers-list--> TBD <!--end-reviewers-list-->
<!--due-dates-list--><!--end-due-dates-list-->
Archive: TBD
Version accepted: TBD
Language: <!--language-->en<!--end-language-->

---



-   Paste the full DESCRIPTION file inside a code block below:

```
Package: emodnet.wfs
Title: Access EMODnet Web Feature Service data through R
Version: 2.0.2
Authors@R: c(
    person("Anna", "Krystalli", , "annakrystalli@googlemail.com", role = "aut",
           comment = c(ORCID = "0000-0002-2378-4915")),
    person("Salvador", "Fernández-Bejarano", , "salvador.fernandez@vliz.be", role = c("aut", "cre"),
           comment = c(ORCID = "0000-0003-0535-7677")),
    person("Thomas J", "Webb", , "t.j.webb@sheffield.ac.uk", role = "ctb"),
    person("European Marine Observation Data Network (EMODnet) Biology project", "European Commission's Directorate - General for Maritime Affairs and Fisheries (DG MARE)", , "bio@emodnet.eu", role = "cph"),
    person("VLIZ (VLAAMS INSTITUUT VOOR DE ZEE)", , , "info@vliz.be", role = "fnd"),
    person("Maëlle", "Salmon", , "msmaellesalmon@gmail.com", role = "aut",
           comment = c(ORCID = "0000-0002-2815-0399"))
  )
Description: Access and interrogate EMODnet (European Marine Observation and Data Network) 
    Web Feature Service data through R.
License: MIT + file LICENSE
URL: https://emodnet.github.io/emodnet.wfs/,
    https://github.com/EMODnet/emodnet.wfs
BugReports: https://github.com/EMODnet/emodnet.wfs/issues
Depends: 
    R (>= 3.6.0)
Imports: 
    checkmate,
    cli,
    dplyr,
    lifecycle,
    magrittr,
    memoise,
    ows4R (>= 0.4),
    purrr,
    rlang,
    sf,
    tibble,
    utils,
    whoami
Suggests: 
    covr,
    httptest,
    knitr,
    mapview,
    readr,
    rmarkdown,
    skimr,
    testthat (>= 3.1.2),
    testthis,
    withr
Config/Needs/readme: rerddap
VignetteBuilder: 
    knitr
Config/testthat/edition: 3
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.3.2
SystemRequirements: C++11, GDAL (>= 2.0.1), GEOS (>= 3.4.0), PROJ (>=
    4.8.0)
Remotes: 
    eblondel/ows4R

```


## Scope

- Please indicate which category or categories from our [package fit policies](https://ropensci.github.io/dev_guide/policies.html#package-categories) this package falls under: (Please check an appropriate box below. If you are unsure, we suggest you make a pre-submission inquiry.):

	- [x] data retrieval
	- [ ] data extraction
	- [ ] data munging
	- [ ] data deposition
    - [ ] data validation and testing
	- [ ] workflow automation
	- [ ] version control
	- [ ] citation management and bibliometrics
	- [ ] scientific software wrappers
	- [ ] field and lab reproducibility tools
	- [ ] database software bindings
	- [x] geospatial data
	- [ ] text analysis

- Explain how and why the package falls under these categories (briefly, 1-2 sentences):

The package allow interrogation of and access to EMODnet’s, European Marine Observation and Data Network, geographic vector data.

-   Who is the target audience and what are scientific applications of this package?

The target audience of the package are EMODnet users that might need programmatic access to EMODnet's geographic vector data. 
The package allows to include EMODnet vector data into scientific pipelines without needing to manually explore and download data from the [EMODnet Geographic Viewer](https://emodnet.ec.europa.eu/geoviewer/).
The data covers seven disciplinary themes (bathymetry, geology, physics, chemistry, biology, seabed habitats and human activities).

-   Are there other R packages that accomplish the same thing? If so, how does yours differ or meet [our criteria for best-in-category](https://ropensci.github.io/dev_guide/policies.html#overlap)?

No, to our knowledge emodnet.wfs is the only package that provides access to EMODnet data in R though the EMODnet Web Feature
Services.
The emodnet.wfs package was developed in collaboration with other EMODnet members.

There are in total three ways to access EMODnet data that complement each other and which we documented in [emodnet.wfs README](https://github.com/EMODnet/emodnet.wfs?tab=readme-ov-file#other-web-services):

- Some EMODnet data are also published in an [ERDDAP
server](https://erddap.emodnet.eu). One can access these data in R using
the rOpenSci [rerddap R package](https://docs.ropensci.org/rerddap/).

- This package emodnet.wfs uses [Web Feature
Services](https://www.ogc.org/standard/wfs/), hence it is limited to
getting vector data. EMODnet also hosts raster data that can be accessed
via [Web Coverage Services (WCS)](https://www.ogc.org/standard/wcs/).
The R package [EMODnetWCS](https://github.com/EMODnet/EMODnetWCS) makes
these data available in R. We intend to also submit the latter to software review at one point (and we intend to rename it).

-   (If applicable) Does your package comply with our [guidance around _Ethics, Data Privacy and Human Subjects Research_](https://devguide.ropensci.org/policies.html#ethics-data-privacy-and-human-subjects-research)?

N/A

-   If you made a pre-submission inquiry, please paste the link to the corresponding issue, forum post, or other discussion, or @tag the editor you contacted.

-   Explain reasons for any [`pkgcheck` items](https://docs.ropensci.org/pkgcheck/) which your package is unable to pass.

## Technical checks

Confirm each of the following by checking the box.

- [x] I have read the [rOpenSci packaging guide](https://devguide.ropensci.org/building.html).
- [x] I have read the [author guide](https://devdevguide.netlify.app/authors-guide.html) and I expect to maintain this package for at least 2 years or to find a replacement.

This package:

- [x] does not violate the Terms of Service of any service it interacts with.
- [x] has a CRAN and OSI accepted license.
- [x] contains a [README with instructions for installing the development version](https://ropensci.github.io/dev_guide/building.html#readme).
- [x] includes [documentation with examples for all functions, created with roxygen2](https://ropensci.github.io/dev_guide/building.html#documentation).
- [x] contains a vignette with examples of its essential functions and uses.
- [x] has a [test suite](https://ropensci.github.io/dev_guide/building.html#testing).
- [x] has [continuous integration](https://ropensci.github.io/dev_guide/ci.html), including reporting of test coverage.

## Publication options

- [x] Do you intend for this package to go on CRAN?
- [ ] Do you intend for this package to go on Bioconductor?

- [ ] Do you wish to submit an Applications Article about your package to [Methods in Ecology and Evolution](http://besjournals.onlinelibrary.wiley.com/hub/journal/10.1111/(ISSN)2041-210X/)? If so:

<details>
<summary>MEE Options</summary>

- [ ] The package is novel and will be of interest to the broad readership of the journal.
- [ ] The manuscript describing the package is no longer than 3000 words.
- [ ] You intend to archive the code for the package in a long-term repository which meets the requirements of the journal (see [MEE's Policy on Publishing Code](http://besjournals.onlinelibrary.wiley.com/hub/journal/10.1111/(ISSN)2041-210X/journal-resources/policy-on-publishing-code.html))
- (*Scope: Do consider MEE's [Aims and Scope](http://besjournals.onlinelibrary.wiley.com/hub/journal/10.1111/(ISSN)2041-210X/aims-and-scope/read-full-aims-and-scope.html) for your manuscript. We make no guarantee that your manuscript will be within MEE scope.*)
- (*Although not required, we strongly recommend having a full manuscript prepared when you submit here.*)
- (*Please do not submit your package separately to Methods in Ecology and Evolution*)

</details>

## Code of conduct

- [x] I agree to abide by [rOpenSci's Code of Conduct](https://ropensci.org/code-of-conduct/) during the review process and in maintaining my package should it be accepted.
