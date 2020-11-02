
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rcodede

<!-- badges: start -->

<!-- badges: end -->

This package is in the earliest stages of development and is in no way
ready for use.

The goal of rcodede is to simpify the usage of the CODE-DE satellite
data repository with R and provide functions for basic processing steps
with the esa SNAP Graph Processing Tool.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
install.packages("devtools")
devtools::install_github("felixlobert/rcodede")
```

## Examples

### Query available scenes

This is a basic example which shows you how to query available
Sentinel-1 scenes for a given area of interest and multiple filter
criteria. The function ‘rcodede::getScenes’ creates an HTTP-GET request
for the CODE-DE EO Finder API and processes the results for an easy
usage.

``` r
library(sf)
library(mapview)

# Create example AOI
aoi <- c(10.441054, 52.286959) %>%
  sf::st_point() %>%
  sf::st_sfc(crs = 4326)

mapview::mapView(aoi, map.types = "Esri.WorldImagery")
```

``` r
library(rcodede)

# Query footprint and metadata of available scenes for the AOI and given criteria
scenes <-
  getScenes(
    aoi = aoi,
    bufferDist = 100,
    startDate = "2019-01-01",
    endDate = "2019-01-31",
    productType = "SLC",
    view = TRUE
  )
```

This table shows the 5 top entries of the resulting sf object:

| date       | platform | orbitDirection | relativeOrbitNumber | centroidLat | centroidLon | productPath                                                                                                             | numberAoiGeoms | footprint                    |
| :--------- | :------- | :------------- | ------------------: | ----------: | ----------: | :---------------------------------------------------------------------------------------------------------------------- | -------------: | :--------------------------- |
| 2019-01-02 | S1B      | ascending      |                 117 |    52.32027 |    9.727361 | /codede/Sentinel-1/SAR/SLC/2019/01/02/S1B\_IW\_SLC\_\_1SDV\_20190102T170751\_20190102T170818\_014318\_01AA3A\_FF22.SAFE |              1 | POLYGON ((7.595577 52.91906… |
| 2019-01-03 | S1A      | ascending      |                  44 |    52.16575 |   11.819360 | /codede/Sentinel-1/SAR/SLC/2019/01/03/S1A\_IW\_SLC\_\_1SDV\_20190103T170016\_20190103T170044\_025316\_02CD10\_3344.SAFE |              1 | POLYGON ((9.6748 52.76576, … |
| 2019-01-05 | S1A      | descending     |                  66 |    51.98302 |   10.031724 | /codede/Sentinel-1/SAR/SLC/2019/01/05/S1A\_IW\_SLC\_\_1SDV\_20190105T053336\_20190105T053403\_025338\_02CDE5\_DD48.SAFE |              1 | POLYGON ((11.62581 50.96621… |
| 2019-01-06 | S1B      | descending     |                 168 |    52.72275 |   12.320578 | /codede/Sentinel-1/SAR/SLC/2019/01/06/S1B\_IW\_SLC\_\_1SDV\_20190106T052428\_20190106T052456\_014369\_01ABD6\_2CFC.SAFE |              1 | POLYGON ((13.9049 51.68368,… |
| 2019-01-08 | S1A      | ascending      |                 117 |    52.37313 |    9.685434 | /codede/Sentinel-1/SAR/SLC/2019/01/08/S1A\_IW\_SLC\_\_1SDV\_20190108T170833\_20190108T170900\_025389\_02CFCA\_312E.SAFE |              1 | POLYGON ((7.54464 52.97379,… |

### Basic Processing

If the CODE-DE satellite data repository is mounted to the used machine,
processing steps can be directly executed to the queried scenes.

The next example shows the estimation of the interferometric coherence
for a selected swath based on two subsequent Sentinel-1 scenes from the
same relative orbit. The function ‘rcodede::estimateCoherence’ creates a
command for the esa SNAP Graph Processing Tool that is executed in the
terminal. A pre-built SNAP-Workflow delivered with the package is then
applied to the selected scenes.

``` r
# filter for scenes from same orbit to ensure same acquisition geometry
scenes.filtered <-
  scenes %>% 
  dplyr::filter(relativeOrbitNumber == 44)

mapview::mapview(scenes.filtered, alpha.regions = .2, map.types = "Esri.WorldImagery") +
  mapview::mapview(aoi)
```

<!--html_preserve-->

<div id="htmlwidget-9876652d3af900ffe636" class="leaflet html-widget" style="width:100%;height:480px;">

</div>

<script type="application/json" data-for="htmlwidget-9876652d3af900ffe636">{"x":{"options":{"minZoom":1,"maxZoom":52,"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}},"preferCanvas":false,"bounceAtZoomLimits":false,"maxBounds":[[[-90,-370]],[[90,370]]]},"calls":[{"method":"addProviderTiles","args":["Esri.WorldImagery","Esri.WorldImagery","Esri.WorldImagery",{"errorTileUrl":"","noWrap":false,"detectRetina":false,"pane":"tilePane"}]},{"method":"createMapPane","args":["polygon",420]},{"method":"addPolygons","args":[[[[{"lng":[9.6748,13.499476,13.90172,10.216146,9.6748],"lat":[52.765762,53.175121,51.554939,51.148655,52.765762]}]],[[{"lng":[9.693062,13.526867,13.926334,10.230799,9.693062],"lat":[52.64637,53.057983,51.445362,51.036793,52.64637]}]],[[{"lng":[9.67335,13.497894,13.900228,10.214779,9.67335],"lat":[52.765736,53.175163,51.554981,51.148636,52.765736]}]],[[{"lng":[9.694054,13.527869,13.927323,10.231787,9.694054],"lat":[52.646732,53.058308,51.445557,51.037025,52.646732]}]],[[{"lng":[9.673216,13.497745,13.900026,10.214581,9.673216],"lat":[52.765705,53.17511,51.55505,51.148724,52.765705]}]]],null,"scenes.filtered",{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}},"pane":"polygon","stroke":true,"color":"#333333","weight":0.5,"opacity":0.9,"fill":true,"fillColor":"#6666FF","fillOpacity":0.2,"smoothFactor":1,"noClip":false},["<div class='scrollableContainer'><table class= id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>1&emsp;<\/td><\/tr><tr><td>1<\/td><th>date&emsp;<\/th><td>2019-01-03&emsp;<\/td><\/tr><tr><td>2<\/td><th>platform&emsp;<\/th><td>S1A&emsp;<\/td><\/tr><tr><td>3<\/td><th>orbitDirection&emsp;<\/th><td>ascending&emsp;<\/td><\/tr><tr><td>4<\/td><th>relativeOrbitNumber&emsp;<\/th><td>44&emsp;<\/td><\/tr><tr><td>5<\/td><th>centroidLat&emsp;<\/th><td>52.16575&emsp;<\/td><\/tr><tr><td>6<\/td><th>centroidLon&emsp;<\/th><td>11.81936&emsp;<\/td><\/tr><tr><td>7<\/td><th>productPath&emsp;<\/th><td>/codede/Sentinel-1/SAR/SLC/2019/01/03/S1A_IW_SLC__1SDV_20190103T170016_20190103T170044_025316_02CD10_3344.SAFE&emsp;<\/td><\/tr><tr><td>8<\/td><th>numberAoiGeoms&emsp;<\/th><td>1&emsp;<\/td><\/tr><tr><td>9<\/td><th>footprint&emsp;<\/th><td>sfc_POLYGON&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class= id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>2&emsp;<\/td><\/tr><tr><td>1<\/td><th>date&emsp;<\/th><td>2019-01-09&emsp;<\/td><\/tr><tr><td>2<\/td><th>platform&emsp;<\/th><td>S1B&emsp;<\/td><\/tr><tr><td>3<\/td><th>orbitDirection&emsp;<\/th><td>ascending&emsp;<\/td><\/tr><tr><td>4<\/td><th>relativeOrbitNumber&emsp;<\/th><td>44&emsp;<\/td><\/tr><tr><td>5<\/td><th>centroidLat&emsp;<\/th><td>52.05119&emsp;<\/td><\/tr><tr><td>6<\/td><th>centroidLon&emsp;<\/th><td>11.84060&emsp;<\/td><\/tr><tr><td>7<\/td><th>productPath&emsp;<\/th><td>/codede/Sentinel-1/SAR/SLC/2019/01/09/S1B_IW_SLC__1SDV_20190109T165933_20190109T170000_014420_01AD7C_3191.SAFE&emsp;<\/td><\/tr><tr><td>8<\/td><th>numberAoiGeoms&emsp;<\/th><td>1&emsp;<\/td><\/tr><tr><td>9<\/td><th>footprint&emsp;<\/th><td>sfc_POLYGON&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class= id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>3&emsp;<\/td><\/tr><tr><td>1<\/td><th>date&emsp;<\/th><td>2019-01-15&emsp;<\/td><\/tr><tr><td>2<\/td><th>platform&emsp;<\/th><td>S1A&emsp;<\/td><\/tr><tr><td>3<\/td><th>orbitDirection&emsp;<\/th><td>ascending&emsp;<\/td><\/tr><tr><td>4<\/td><th>relativeOrbitNumber&emsp;<\/th><td>44&emsp;<\/td><\/tr><tr><td>5<\/td><th>centroidLat&emsp;<\/th><td>52.16576&emsp;<\/td><\/tr><tr><td>6<\/td><th>centroidLon&emsp;<\/th><td>11.81789&emsp;<\/td><\/tr><tr><td>7<\/td><th>productPath&emsp;<\/th><td>/codede/Sentinel-1/SAR/SLC/2019/01/15/S1A_IW_SLC__1SDV_20190115T170016_20190115T170043_025491_02D361_AAA9.SAFE&emsp;<\/td><\/tr><tr><td>8<\/td><th>numberAoiGeoms&emsp;<\/th><td>1&emsp;<\/td><\/tr><tr><td>9<\/td><th>footprint&emsp;<\/th><td>sfc_POLYGON&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class= id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>4&emsp;<\/td><\/tr><tr><td>1<\/td><th>date&emsp;<\/th><td>2019-01-21&emsp;<\/td><\/tr><tr><td>2<\/td><th>platform&emsp;<\/th><td>S1B&emsp;<\/td><\/tr><tr><td>3<\/td><th>orbitDirection&emsp;<\/th><td>ascending&emsp;<\/td><\/tr><tr><td>4<\/td><th>relativeOrbitNumber&emsp;<\/th><td>44&emsp;<\/td><\/tr><tr><td>5<\/td><th>centroidLat&emsp;<\/th><td>52.05147&emsp;<\/td><\/tr><tr><td>6<\/td><th>centroidLon&emsp;<\/th><td>11.84159&emsp;<\/td><\/tr><tr><td>7<\/td><th>productPath&emsp;<\/th><td>/codede/Sentinel-1/SAR/SLC/2019/01/21/S1B_IW_SLC__1SDV_20190121T165932_20190121T165959_014595_01B316_CAB9.SAFE&emsp;<\/td><\/tr><tr><td>8<\/td><th>numberAoiGeoms&emsp;<\/th><td>1&emsp;<\/td><\/tr><tr><td>9<\/td><th>footprint&emsp;<\/th><td>sfc_POLYGON&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class= id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>5&emsp;<\/td><\/tr><tr><td>1<\/td><th>date&emsp;<\/th><td>2019-01-27&emsp;<\/td><\/tr><tr><td>2<\/td><th>platform&emsp;<\/th><td>S1A&emsp;<\/td><\/tr><tr><td>3<\/td><th>orbitDirection&emsp;<\/th><td>ascending&emsp;<\/td><\/tr><tr><td>4<\/td><th>relativeOrbitNumber&emsp;<\/th><td>44&emsp;<\/td><\/tr><tr><td>5<\/td><th>centroidLat&emsp;<\/th><td>52.16578&emsp;<\/td><\/tr><tr><td>6<\/td><th>centroidLon&emsp;<\/th><td>11.81772&emsp;<\/td><\/tr><tr><td>7<\/td><th>productPath&emsp;<\/th><td>/codede/Sentinel-1/SAR/SLC/2019/01/27/S1A_IW_SLC__1SDV_20190127T170016_20190127T170043_025666_02D9CC_97F9.SAFE&emsp;<\/td><\/tr><tr><td>8<\/td><th>numberAoiGeoms&emsp;<\/th><td>1&emsp;<\/td><\/tr><tr><td>9<\/td><th>footprint&emsp;<\/th><td>sfc_POLYGON&emsp;<\/td><\/tr><\/table><\/div>"],{"maxWidth":800,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"closeOnClick":true,"className":""},["1","2","3","4","5"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},{"stroke":true,"weight":1,"opacity":0.9,"fillOpacity":0.28,"bringToFront":false,"sendToBack":false}]},{"method":"addScaleBar","args":[{"maxWidth":100,"metric":true,"imperial":true,"updateWhenIdle":true,"position":"bottomleft"}]},{"method":"addHomeButton","args":[9.673216,51.036793,13.927323,53.175163,"scenes.filtered","Zoom to scenes.filtered","<strong> scenes.filtered <\/strong>","bottomright"]},{"method":"addLegend","args":[{"colors":["#6666FF"],"labels":["scenes.filtered"],"na_color":null,"na_label":"NA","opacity":1,"position":"topright","type":"factor","title":"","extra":null,"layerId":null,"className":"info legend","group":"scenes.filtered"}]},{"method":"createMapPane","args":["point",440]},{"method":"addCircleMarkers","args":[52.286959,10.441054,6,null,"aoi",{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}},"pane":"point","stroke":true,"color":"#333333","weight":1,"opacity":0.9,"fill":true,"fillColor":"#6666ff","fillOpacity":0.6},null,null,null,{"maxWidth":800,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"closeOnClick":true,"className":""},"1",{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addHomeButton","args":[10.441054,52.286959,10.441054,52.286959,"aoi","Zoom to aoi","<strong> aoi <\/strong>","bottomright"]},{"method":"addLayersControl","args":["Esri.WorldImagery",["scenes.filtered","aoi"],{"collapsed":true,"autoZIndex":true,"position":"topleft"}]},{"method":"addHomeButton","args":[9.673216,51.036793,13.927323,53.175163,null,"Zoom to full extent","<strong>Zoom full<\/strong>","bottomleft"]}],"limits":{"lat":[51.036793,53.175163],"lng":[9.673216,13.927323]},"fitBounds":[51.036793,9.673216,53.175163,13.927323,[]]},"evals":[],"jsHooks":{"render":[{"code":"function(el, x, data) {\n  return (\n      function(el, x, data) {\n      // get the leaflet map\n      var map = this; //HTMLWidgets.find('#' + el.id);\n      // we need a new div element because we have to handle\n      // the mouseover output separately\n      // debugger;\n      function addElement () {\n      // generate new div Element\n      var newDiv = $(document.createElement('div'));\n      // append at end of leaflet htmlwidget container\n      $(el).append(newDiv);\n      //provide ID and style\n      newDiv.addClass('lnlt');\n      newDiv.css({\n      'position': 'relative',\n      'bottomleft':  '0px',\n      'background-color': 'rgba(255, 255, 255, 0.7)',\n      'box-shadow': '0 0 2px #bbb',\n      'background-clip': 'padding-box',\n      'margin': '0',\n      'padding-left': '5px',\n      'color': '#333',\n      'font': '9px/1.5 \"Helvetica Neue\", Arial, Helvetica, sans-serif',\n      'z-index': '700',\n      });\n      return newDiv;\n      }\n\n\n      // check for already existing lnlt class to not duplicate\n      var lnlt = $(el).find('.lnlt');\n\n      if(!lnlt.length) {\n      lnlt = addElement();\n\n      // grab the special div we generated in the beginning\n      // and put the mousmove output there\n\n      map.on('mousemove', function (e) {\n      if (e.originalEvent.ctrlKey) {\n      if (document.querySelector('.lnlt') === null) lnlt = addElement();\n      lnlt.text(\n                           ' lon: ' + (e.latlng.lng).toFixed(5) +\n                           ' | lat: ' + (e.latlng.lat).toFixed(5) +\n                           ' | zoom: ' + map.getZoom() +\n                           ' | x: ' + L.CRS.EPSG3857.project(e.latlng).x.toFixed(0) +\n                           ' | y: ' + L.CRS.EPSG3857.project(e.latlng).y.toFixed(0) +\n                           ' | epsg: 3857 ' +\n                           ' | proj4: +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs ');\n      } else {\n      if (document.querySelector('.lnlt') === null) lnlt = addElement();\n      lnlt.text(\n                      ' lon: ' + (e.latlng.lng).toFixed(5) +\n                      ' | lat: ' + (e.latlng.lat).toFixed(5) +\n                      ' | zoom: ' + map.getZoom() + ' ');\n      }\n      });\n\n      // remove the lnlt div when mouse leaves map\n      map.on('mouseout', function (e) {\n      var strip = document.querySelector('.lnlt');\n      strip.remove();\n      });\n\n      };\n\n      //$(el).keypress(67, function(e) {\n      map.on('preclick', function(e) {\n      if (e.originalEvent.ctrlKey) {\n      if (document.querySelector('.lnlt') === null) lnlt = addElement();\n      lnlt.text(\n                      ' lon: ' + (e.latlng.lng).toFixed(5) +\n                      ' | lat: ' + (e.latlng.lat).toFixed(5) +\n                      ' | zoom: ' + map.getZoom() + ' ');\n      var txt = document.querySelector('.lnlt').textContent;\n      console.log(txt);\n      //txt.innerText.focus();\n      //txt.select();\n      setClipboardText('\"' + txt + '\"');\n      }\n      });\n\n      }\n      ).call(this.getMap(), el, x, data);\n}","data":null},{"code":"function(el, x, data) {\n  return (function(el,x,data){\n           var map = this;\n\n           map.on('keypress', function(e) {\n               console.log(e.originalEvent.code);\n               var key = e.originalEvent.code;\n               if (key === 'KeyE') {\n                   var bb = this.getBounds();\n                   var txt = JSON.stringify(bb);\n                   console.log(txt);\n\n                   setClipboardText('\\'' + txt + '\\'');\n               }\n           })\n        }).call(this.getMap(), el, x, data);\n}","data":null}]}}</script>

<!--/html_preserve-->

Estimate the interferometric coherence for the first pair from the
filtered scenes.

``` r
# estimate the coherence for the first two scenes in the sf object
coherence <- 
  estimateCoherence(
    master = scenes.filtered$productPath[1],
    slave = scenes.filtered$productPath[2],
    outputDirectory = "/home/",
    fileName = "coherence.tif",
    polarisation = "VH",
    swath = "all",
    aoi = aoi,
    aoiBuffer = 500,
    numCores = 6,
    maxMemory = 32,
    execute = TRUE,
    return = TRUE)
```

The created coherence raster or stack can then be plotted or further
processed:

``` r

mapview::mapview(coherence$layer, map.types = "Esri.WorldImagery", alpha = .75) +
  mapview::mapview(aoi, burst =T)
```

<!--html_preserve-->

<div id="htmlwidget-c8c825eb4a3d4065e480" class="leaflet html-widget" style="width:100%;height:480px;">

</div>

<script type="application/json" data-for="htmlwidget-c8c825eb4a3d4065e480">{"x":{"options":{"minZoom":1,"maxZoom":52,"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}},"preferCanvas":false,"bounceAtZoomLimits":false,"maxBounds":[[[-90,-370]],[[90,370]]]},"calls":[{"method":"addProviderTiles","args":["Esri.WorldImagery","Esri.WorldImagery","Esri.WorldImagery",{"errorTileUrl":"","noWrap":false,"detectRetina":false,"pane":"tilePane"}]},{"method":"addRasterImage","args":["data:image/png;base64,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",[[52.291741749106,10.4331664189154],[52.282119589197,10.4488612487606]],0.75,null,"coherence$layer","coherence$layer"]},{"method":"removeLayersControl","args":[]},{"method":"addControl","args":["","topright","imageValues-coherence$layer","info legend "]},{"method":"addImageQuery","args":["coherence$layer",[10.4331664189154,52.282119589197,10.4488612487606,52.291741749106],"mousemove",7,"Layer"]},{"method":"addLegend","args":[{"colors":["#040404 , #1D1135 8.23241432253804%, #4D1258 20.2694741251358%, #80106F 32.3065339277335%, #B02275 44.3435937303312%, #DA4664 56.3806535329289%, #F3762F 68.4177133355267%, #F7AC2F 80.4547731381244%, #FADD6F 92.4918329407221%, #FFFE9E "],"labels":["0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8"],"na_color":"#BEBEBE","na_label":"NA","opacity":1,"position":"topright","type":"numeric","title":"coherence$layer","extra":{"p_1":0.0823241432253804,"p_n":0.924918329407221},"layerId":null,"className":"info legend","group":"coherence$layer"}]},{"method":"addScaleBar","args":[{"maxWidth":100,"metric":true,"imperial":true,"updateWhenIdle":true,"position":"bottomleft"}]},{"method":"addHomeButton","args":[10.4331664189154,52.282119589197,10.4488612487606,52.291741749106,"coherence$layer","Zoom to coherence$layer","<strong> coherence$layer <\/strong>","bottomright"]},{"method":"createMapPane","args":["point",440]},{"method":"addCircleMarkers","args":[52.286959,10.441054,6,null,"aoi",{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}},"pane":"point","stroke":true,"color":"#333333","weight":1,"opacity":0.9,"fill":true,"fillColor":"#6666ff","fillOpacity":0.6},null,null,null,{"maxWidth":800,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"closeOnClick":true,"className":""},"1",{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addHomeButton","args":[10.441054,52.286959,10.441054,52.286959,"aoi","Zoom to aoi","<strong> aoi <\/strong>","bottomright"]},{"method":"addLayersControl","args":["Esri.WorldImagery",["coherence$layer","aoi"],{"collapsed":true,"autoZIndex":true,"position":"topleft"}]},{"method":"addHomeButton","args":[10.4331664189154,52.282119589197,10.4488612487606,52.2917417491059,null,"Zoom to full extent","<strong>Zoom full<\/strong>","bottomleft"]}],"limits":{"lat":[52.282119589197,52.291741749106],"lng":[10.4331664189154,10.4488612487606]},"fitBounds":[6851297.92417912,1161414.77311515,6853048.97993497,1163161.91358159,[]]},"evals":[],"jsHooks":{"render":[{"code":"function(el, x, data) {\n  return (\n      function(el, x, data) {\n      // get the leaflet map\n      var map = this; //HTMLWidgets.find('#' + el.id);\n      // we need a new div element because we have to handle\n      // the mouseover output separately\n      // debugger;\n      function addElement () {\n      // generate new div Element\n      var newDiv = $(document.createElement('div'));\n      // append at end of leaflet htmlwidget container\n      $(el).append(newDiv);\n      //provide ID and style\n      newDiv.addClass('lnlt');\n      newDiv.css({\n      'position': 'relative',\n      'bottomleft':  '0px',\n      'background-color': 'rgba(255, 255, 255, 0.7)',\n      'box-shadow': '0 0 2px #bbb',\n      'background-clip': 'padding-box',\n      'margin': '0',\n      'padding-left': '5px',\n      'color': '#333',\n      'font': '9px/1.5 \"Helvetica Neue\", Arial, Helvetica, sans-serif',\n      'z-index': '700',\n      });\n      return newDiv;\n      }\n\n\n      // check for already existing lnlt class to not duplicate\n      var lnlt = $(el).find('.lnlt');\n\n      if(!lnlt.length) {\n      lnlt = addElement();\n\n      // grab the special div we generated in the beginning\n      // and put the mousmove output there\n\n      map.on('mousemove', function (e) {\n      if (e.originalEvent.ctrlKey) {\n      if (document.querySelector('.lnlt') === null) lnlt = addElement();\n      lnlt.text(\n                           ' lon: ' + (e.latlng.lng).toFixed(5) +\n                           ' | lat: ' + (e.latlng.lat).toFixed(5) +\n                           ' | zoom: ' + map.getZoom() +\n                           ' | x: ' + L.CRS.EPSG3857.project(e.latlng).x.toFixed(0) +\n                           ' | y: ' + L.CRS.EPSG3857.project(e.latlng).y.toFixed(0) +\n                           ' | epsg: 3857 ' +\n                           ' | proj4: +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs ');\n      } else {\n      if (document.querySelector('.lnlt') === null) lnlt = addElement();\n      lnlt.text(\n                      ' lon: ' + (e.latlng.lng).toFixed(5) +\n                      ' | lat: ' + (e.latlng.lat).toFixed(5) +\n                      ' | zoom: ' + map.getZoom() + ' ');\n      }\n      });\n\n      // remove the lnlt div when mouse leaves map\n      map.on('mouseout', function (e) {\n      var strip = document.querySelector('.lnlt');\n      strip.remove();\n      });\n\n      };\n\n      //$(el).keypress(67, function(e) {\n      map.on('preclick', function(e) {\n      if (e.originalEvent.ctrlKey) {\n      if (document.querySelector('.lnlt') === null) lnlt = addElement();\n      lnlt.text(\n                      ' lon: ' + (e.latlng.lng).toFixed(5) +\n                      ' | lat: ' + (e.latlng.lat).toFixed(5) +\n                      ' | zoom: ' + map.getZoom() + ' ');\n      var txt = document.querySelector('.lnlt').textContent;\n      console.log(txt);\n      //txt.innerText.focus();\n      //txt.select();\n      setClipboardText('\"' + txt + '\"');\n      }\n      });\n\n      }\n      ).call(this.getMap(), el, x, data);\n}","data":null},{"code":"function(el, x, data) {\n  return (function(el,x,data){\n           var map = this;\n\n           map.on('keypress', function(e) {\n               console.log(e.originalEvent.code);\n               var key = e.originalEvent.code;\n               if (key === 'KeyE') {\n                   var bb = this.getBounds();\n                   var txt = JSON.stringify(bb);\n                   console.log(txt);\n\n                   setClipboardText('\\'' + txt + '\\'');\n               }\n           })\n        }).call(this.getMap(), el, x, data);\n}","data":null}]}}</script>

<!--/html_preserve-->
