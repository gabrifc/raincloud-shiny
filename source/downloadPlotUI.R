downloadPlotUI <- function(id, 
                           label = "Image format",
                           buttonLabel = "Download") {
  
  ns <- NS(id)
  
  tagList(
    column(6,
           selectInput(ns("downloadFormat"),
                       label = label,
                       choices = list(
                         "Vectorial" = list(
                           "pdf" = "pdf",
                           "svg" = "svg"
                         ),
                         "Non-vectorial" = list(
                           "png" = "png",
                           "tiff" = "tiff"
                         )
                       ),
                       selected = "pdf")),
    column(6,
           downloadButton(ns("downloadPlot"), 
                          label = buttonLabel))
    
  )
}


