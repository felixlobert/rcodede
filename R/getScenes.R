#' Query scenes from CODE-DE EO Finder API
#'
#' Returns metadata for satellite imagery that matches several input criteria
#'
#' @param aoi Area of interest for the query. Has to be an sf object with polygonal or point geometry. In case of a point geometry, the buffer argument has to be set.
#' @param bufferDist Buffer around the AOI in meters. Defaults to 0.
#' @param startDate Starting date for the query of format "YYYY-MM-DD".
#' @param endDate End date for query.
#' @param productType Product type to query. One of "SLC", "GRD", "CARD-INF6", ...
#' @param sensorMode Sensor mode for Sentinel-1. One of "IW", "EW", ... Only considered if set.
#' @param orbitDirection Direction of satellite orbit. One of "ascending" or "descending". Only considered if set.
#' @param relativeOrbitNumber Relative orbit number. Only considered if set.
#' @param view logical indicating if the queried scenes should be visualized with mapview. Defaults to FALSE.
#'
#' @return sf object containing footprints and metadata for all queried scenes.
#' @export
#'
#' @examples
#' # points example polygon
#' pts <-
#'   matrix(
#'     data = c(
#'       10.441070,
#'       10.441070,
#'       10.441077,
#'       10.441077,
#'       10.441070,
#'       52.286956,
#'       52.286965,
#'       52.286965,
#'       52.286956,
#'       52.286956
#'     ),
#'     nrow = 5
#'   )
#'
#' # create aoi from points
#' aoi <- sf::st_polygon(x = list(pts)) %>%
#'   sf::st_sfc() %>%
#'   sf::`st_crs<-`(4326)
#'
#' # scenes for aoi and given criteria
#' scenes <-
#'   getScenes(
#'     aoi = aoi,
#'     startDate = "2019-01-01",
#'     endDate = "2019-12-31",
#'     productType = "SLC"
#'   )
getScenes <-
  function(aoi,
           bufferDist = 0,
           startDate,
           endDate,
           productType,
           sensorMode = NULL,
           orbitDirection = NULL,
           relativeOrbitNumber = NULL,
           view = FALSE) {

    aoi <- aoi %>%
      sf::st_transform(32632) %>%
      sf::st_buffer(bufferDist) %>%
      sf::st_transform(4326)

    aoi.wkt <- aoi %>%
      sf::st_bbox() %>%
      sf::st_as_sfc() %>%
      sf::st_as_text(digits = 15) %>%
      gsub(", ", "%2C", .) %>%
      gsub("POLYGON ", "POLYGON", .) %>%
      gsub(" ", "+", .)

    url = paste0(
      "https://finder.code-de.org/resto/api/collections/Sentinel1/search.json?maxRecords=1000&location=all&sortParam=startDate&sortOrder=descending&status=all&dataset=ESA-DATASET",
      if (!is.null(orbitDirection))
        paste0("&orbitDirection=", orbitDirection),
      if (!is.null(startDate))
        paste0("&startDate=", startDate, "T00%3A00%3A00Z"),
      if (!is.null(endDate))
        paste0("&completionDate=", endDate, "T23%3A59%3A59Z"),
      if (!is.null(productType))
        paste0("&productType=", productType),
      if (!is.null(sensorMode))
        paste0("&sensorMode=", sensorMode),
      if (!is.null(relativeOrbitNumber))
        paste0("&relativeOrbitNumber=", relativeOrbitNumber),
      if (!is.null(aoi))
        paste0("&geometry=", aoi.wkt)
    )

    scenes <- url %>%
      httr::GET() %$%
      content %>%
      base::rawToChar() %>%
      jsonlite::fromJSON() %$%
      features$properties %>%
      dplyr::mutate(
        lon = sapply(.$centroid$coordinates, `[[`, 1),
        lat = sapply(.$centroid$coordinates, `[[`, 2)
      ) %>%
      dplyr::mutate(wkt = gsub(
        ".*<gml:coordinates>(.+)</gml:coordinates>.*",
        "\\1",
        gmlgeometry
      )) %>%
      dplyr::mutate(wkt = gsub(",", ";", wkt)) %>%
      dplyr::mutate(wkt = gsub(" ", ", ", wkt)) %>%
      dplyr::mutate(wkt = gsub(";", " ", wkt)) %>%
      dplyr::mutate(wkt = paste0("POLYGON (( ", wkt, " ))")) %>%
      dplyr::select(
        date = startDate,
        platform,
        relativeOrbitNumber,
        orbitDirection,
        centroidLat = lat,
        centroidLon = lon,
        productPath = productIdentifier,
        footprint = wkt
      ) %>%
      tidyr::separate(date, c("date", NA), sep = "T") %>%
      dplyr::mutate(date = as.Date(date)) %>%
      dplyr::arrange(date) %>%
      sf::st_as_sf(wkt = "footprint") %>%
      sf::`st_crs<-`(sf::st_crs(4326)) %>%
      dplyr::mutate(numberAoiGeoms = sf::st_contains_properly(., aoi) %>% lengths) %>%
      dplyr::select(date, platform, orbitDirection, relativeOrbitNumber, centroidLat, centroidLon, productPath, numberAoiGeoms, footprint) %>%
      dplyr::arrange(date, relativeOrbitNumber) %>%
      dplyr::mutate(date = as.Date(date))

    if (view == T) {
      print(mapview::mapview(scenes, alpha.regions = .2) +
              mapview::mapview(aoi))
    }

    return(scenes)
  }
