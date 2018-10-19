downloadPlot <- function(input, output, session, plot, 
                         fileType, width, height) {
  
  output$generatePlot <- downloadHandler(
    filename = function() {
      paste('rainCloudPlot', fileType, sep = ".")
    },
    content = function(file) {
      ggsave(file,
             ## the ggghost has to be printed to be a plot, otherwise cannot be 
             ## saved as it is not a ggplot object for ggsave.
             plot = print(plot),
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