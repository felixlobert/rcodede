#' Estimate the interferometric Coherence
#'
#' Coherence estimation for two corresponding Sentinel-1 SLC scenes
#'
#' @param master Master Sentinel-1 scene for coherence estimation.
#' @param slave Slave scene.
#' @param outputDirectory Directory for the output file.
#' @param fileName Name of the output file.
#' @param swath Swath to be processed. One of "IW1", "IW2", "IW3" or "all".
#' @param polarisation Plarisations to be processed. One of "VH", "VV", or "VV,VH". Defaults to "VV,VH".
#' @param firstBurst First burst from the chosen swath.
#' @param lastBurst Last birst. Has to be higher or equal to first burst.
#' @param numCores Number of CPUs to be used in the process.
#' @param maxMemory Amount of memory to be used in GB.
#' @param execute logical if command for esa SNAP gpt shall be executed.
#'
#' @return
#' @export
#'
#' @examples
#' # example AOI
#' aoi <- c(10.441054, 52.286959) %>%
#'   sf::st_point() %>%
#'   sf::st_sfc(crs = 4326)
#'
#' # scenes for aoi and given criteria
#' scenes <-
#'   getScenes(
#'     aoi = aoi,
#'     bufferDist = 100,
#'     startDate = "2019-01-01",
#'     endDate = "2019-01-31",
#'     productType = "SLC"
#'   ) %>%
#'   dplyr::filter(relativeOrbitNumber == 44)
#'
#' estimateCoherence(
#'   master = scenes$productPath[1],
#'   slave = scenes$productPath[2],
#'   outputDirectory = getwd(),
#'   fileName = "test.tif",
#'   polarisation = "VV,VH",
#'   swath = "IW1",
#'   firstBurst = 1,
#'   lastBurst = 1,
#'   numCores = 8,
#'   maxMemory=50,
#'   execute = FALSE)
estimateCoherence <-
  function(master,
           slave,
           outputDirectory,
           fileName,
           swath = "IW1",
           polarisation = "VV,VH",
           firstBurst = 1,
           lastBurst = 9,
           numCores,
           maxMemory,
           execute = FALSE) {

    if(swath == "all"){
      graph <-
        system.file("extdata", "coherenceGraphAllSwaths.xml", package = "rcodede")

      cmd <- paste0(
        "sudo gpt ", graph,
        " -Pinput1=", master, "/manifest.safe",
        " -Pinput2=", slave, "/manifest.safe",
        " -Poutput=", outputDirectory, fileName,
        " -q ", numCores,
        " -J-Xms2G -J-Xmx", maxMemory, "G"
      )

    } else{
      graph <-
        system.file("extdata", "coherenceGraphOneSwath.xml", package = "rcodede")

      cmd <- paste0(
        "sudo gpt ", graph,
        " -Pinput1=", master, "/manifest.safe",
        " -Pinput2=", slave, "/manifest.safe",
        " -Poutput=", outputDirectory, fileName,
        " -Pswath=", swath,
        " -Ppolarisation=", polarisation,
        " -PfirstBurst=", firstBurst,
        " -PlastBurst=", lastBurst,
        " -q ", numCores,
        " -J-Xms2G -J-Xmx", maxMemory, "G"
      )
    }

    if(execute==TRUE){
      system(cmd)
    } else{
      cat(cmd)
    }
  }
