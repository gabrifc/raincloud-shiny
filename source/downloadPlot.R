downloadPlot <- function(input, output, session, plot, 
                         fileName, width, height) {
  
  output$downloadPlot <- downloadHandler(
    filename = function() {
      paste(paste('rainCloudPlot-',fileName, sep = ""), input$downloadFormat, sep = ".")
    },
    content = function(file) {
      ggsave(file,
             plot = plot,
             device = input$downloadFormat,
             width = width,
             height = height,
             units = "in",
             dpi = 300)
    }
  )
}