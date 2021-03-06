% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimateCoherence.R
\name{estimateCoherence}
\alias{estimateCoherence}
\title{Estimate the interferometric Coherence}
\usage{
estimateCoherence(
  master,
  slave,
  outputDirectory,
  fileName,
  resolution,
  polarisation = "VV,VH",
  swath = "all",
  firstBurst = 1,
  lastBurst = 9,
  aoi = NULL,
  aoiBuffer = 0,
  numCores = NULL,
  maxMemory = NULL,
  crs = "AUTO:42001",
  execute = FALSE,
  return = FALSE,
  BigTIFF = FALSE
)
}
\arguments{
\item{master}{Master Sentinel-1 scene for coherence estimation.}

\item{slave}{Slave scene.}

\item{outputDirectory}{Directory for the output file.}

\item{fileName}{Name of the output file.}

\item{resolution}{Spatial resolution of the output raster in meters.}

\item{polarisation}{Plarisations to be processed. One of "VH", "VV", or "VV,VH". Defaults to "VV,VH".}

\item{swath}{Swath to be processed. One of "IW1", "IW2", "IW3" or "all".}

\item{firstBurst}{First burst index from the chosen swath. Between 1 and 9. Only relevant if swath != "all".}

\item{lastBurst}{Last burst index. Has to be higher than or equal to first burst. Only relevant if swath != "all".}

\item{aoi}{sf object for the area of interest.}

\item{aoiBuffer}{Buffer around aoi in meters. Defaults to 0.}

\item{numCores}{Number of CPUs to be used in the process. Chosen by SNAP if not set.}

\item{maxMemory}{Amount of memory to be used in GB. Chosen by SNAP if not set.}

\item{crs}{Coordinate reference system to use for output of format "EPSG:XXXX". Defaults to automatic UTM/WGS84 if not set.}

\item{execute}{logical if command for esa SNAP gpt shall be executed. If FALSE the commmand is printed instead.}

\item{return}{logical if processed raster or stack shall be returned.}

\item{BigTIFF}{logical if output should be written as BigTIFF.}
}
\value{

}
\description{
Coherence estimation for two corresponding Sentinel-1 SLC scenes
}
\examples{
# example AOI
aoi <- c(10.441054, 52.286959) \%>\%
  sf::st_point() \%>\%
  sf::st_sfc(crs = 4326)

# scenes for aoi and given criteria
scenes <-
  getScenes(
    aoi = aoi,
    startDate = "2019-01-01",
    endDate = "2019-01-15",
    productType = "SLC"
  ) \%>\%
  dplyr::filter(relativeOrbitNumber == 117)

estimateCoherence(
  master = scenes$productPath[2],
  slave = scenes$productPath[1],
  outputDirectory = getwd(),
  fileName = "test.tif",
  resolution = 30,
  polarisation = "VV,VH",
  aoi = aoi,
  aoiBuffer = 250,
  numCores = 6,
  maxMemory=32,
  execute = FALSE)
}
