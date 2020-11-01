#' Estimate the interferometric Coherence
#'
#' Coherence estimation for two corresponding Sentinel-1 SLC scenes
#'
#' @param master Master Sentinel-1 scene for coherence estimation.
#' @param slave Slave scene.
#' @param outputDirectory Directory for the output file.
#' @param fileName Name of the output file.
#' @param swath Swath to be processed. One of "IW1", "IW2" or "IW3".
#' @param polarisation Plarisations to be processed. One of "VH", "VV", or "VV,VH". Defaults to "VV,VH".
#' @param firstBurst First burst from the chosen swath.
#' @param lastBurst Last birst. Has to be higher or equal to first burst.
#' @param aoi sf object with area of interest to subst the output.
#' @param aoiBuffer Buffer size in metres for AOI.
#' @param numCores Number of CPUs to be used in the process.
#' @param maxMemory Amount of memory to be used in GB.
estimateCoherence <-
  function(master,
           slave,
           outputDirectory,
           fileName,
           swath = "IW1",
           polarisation = "VV,VH",
           firstBurst = 1,
           lastBurst = 9,
           aoi,
           aoiBuffer = 0,
           numCores,
           maxMemory) {

    graph <-
      system.file("extdata", "coherenceGraphOneSwath.xml", package = "rcodede")

    subset <- aoi %>%
      sf::st_transform(32632) %>%
      sf::st_buffer(aoiBuffer) %>%
      sf::st_transform(4326)%>%
      sf::st_bbox() %>%
      sf::st_as_sfc() %>%
      sf::st_as_text(digits=15)

    cmd <- paste0(
      "sudo gpt ", graph,
      " -Pinput1=", master, "/manifest.safe",
      " -Pinput2=", slave, "/manifest.safe",
      " -Poutput=", outputDirectory, fileName,
      " -Pswath=", swath,
      " -Ppolarisation=", polarisation,
      " -PfirstBurst=", firstBurst,
      " -PlastBurst=", lastBurst,
      " -Paoi=\"", subset, "\"",
      " -q ", numCores,
      " -J-Xms2G -J-Xmx", maxMemory, "G"
    )

    cat(cmd)
    system(cmd)

  }
