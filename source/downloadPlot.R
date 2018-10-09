downloadPlot <- function(input, output, session, plot, 
                         fileType, width, height) {
  
  output$generatePlot <- downloadHandler(
    filename = function() {
      paste('rainCloudPlot', fileType, sep = ".")
    },
    content = function(file) {
      ggsave(file,
             plot = plot,
             device = fileType,
             width = width,
             height = height,
             units = "in",
             dpi = 300)
    }
  )
}


# output$png <- downloadHandler(
#   filename = function() {
#     paste(input$excelFile$name, "png", sep = ".")
#   },
#   content = function(file) {
#     ggsave(
#       filename = file,
#       plot = last_plot(),
#       device = "png",
#       width = input$width / 72,
#       height = input$height / 72,
#       units = "in",
#       dpi = 300
#     )
#   }
# )