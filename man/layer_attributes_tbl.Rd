% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/layer_attributes.R
\name{layer_attributes_tbl}
\alias{layer_attributes_tbl}
\title{Possible values of variables (attributes) in a dataset (layer)
from a data source (service).}
\usage{
layer_attributes_tbl(wfs = NULL, service = NULL, service_version = NULL, layer)
}
\arguments{
\item{wfs}{A \code{WFSClient} R6 object with methods for interfacing an
OGC Web Feature Service. From \code{\link[=emodnet_init_wfs_client]{emodnet_init_wfs_client()}}.}

\item{service}{the EMODnet OGC WFS service name.
For available services, see \code{\link[=emodnet_wfs]{emodnet_wfs()}}.}

\item{service_version}{\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}
the WFS service version. Now always "2.0.0".}

\item{layer}{character sting of layer name. To get info on layers, including
\code{layer_name} use \code{\link[=emodnet_get_wfs_info]{emodnet_get_wfs_info()}}.}
}
\value{
tibble of layer attribute (variable) values
with geometry column removed.
}
\description{
Get layer attribute values tibble
}
\details{
Request excluding spatial information can be significantly faster.
Can be
useful for inspecting attribute values and constructing feature filters
for more
targeted and faster layer download.
}
\examples{
\dontshow{if (should_run_example()) withAutoprint(\{ # examplesIf}
layer_attributes_tbl(service = "biology", layer = "mediseh_zostera_m_pnt")
\dontshow{\}) # examplesIf}
}
\seealso{
Attributes metadata:
\code{\link{layer_attribute_descriptions}()},
\code{\link{layer_attribute_inspect}()},
\code{\link{layer_attributes_get_names}()},
\code{\link{layer_attributes_summarise}()}
}
\concept{attributes}
