downloadPlotUI <- function(id, label) {
  
  ns <- NS(id)
  
  downloadButton(ns("generatePlot"), label = label)
}
