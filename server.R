#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library('glue')
library('stringr')

#source("source/libraries.R", local = TRUE)
source("source/createPlot.R", local = TRUE)
source("source/formatCode.R", local = TRUE)
source("source/downloadPlot.R", local = TRUE)
source("source/dataUpload.R", local = TRUE)

server <- function(input, output, session) {
  
  processedData <- callModule(dataUploadAndManipulation, "rainCloud")

  # Conditions to upload the UI if necessary
  # output$statsControlUI <- renderUI({
  #   conditionList <- as.list(processedData$conditions())
  #   selectInput("statsControl", 
  #                      label = h4("Control Condition"),
  #                      choices = conditionList, 
  #                      selected = conditionList[[1]])
  # })
  
  output$statsCombinationsUI <- renderUI({
    # This is wrong on so many levels but is the only way I found it f** works.
    # Explanation: ggghost accepts only 1 supplemental data, which is 'input'.
    #   Therefore, we need the list of comparisons to be an input.
    #   Should be something like list('AvsB' = c('A', 'B'),
    #                                 'BvsC' = c('B', 'C'))
    #   The problem here is that there is not any input that can accept a vector
    #   as values.
    #   We could use selectInput multiple == TRUE (see previous attempts), but 
    #   then it would group the values as independent under the same name (e.g).
    #   AvsB
    #   ----
    #   A
    #   B
    #   BvsC
    #   ----
    #   B
    #   C
    #   This is a disaster.
    
    # # ## Create a matrix with the combinations
    # statsCombns <- combn(processedData$conditions(), 2)
    #  
    # # ## From the split examples: split a matrix into a list by columns
    # combinationList <- split(statsCombns, col(statsCombns))
    # 
    # # ## Name the List
    # combinationListNames <- combn(processedData$conditions(), 2, FUN = paste, collapse = 'vs')
    # names(combinationList) <- combinationListNames
    # print(combinationList)
    # checkboxGroupInput('statsCombinations',
    #                    label = h4("Conditions To Test"),
    #                    choices = combinationList)
    
    combinationList <- combn(processedData$conditions(), 2, FUN = paste, collapse = 'vs')
    selectInput("statsCombinations", 
                label = h4("Conditions To Test"),
                choices = combinationList,
                multiple = TRUE)
    
  })

  output$statsLabelUI <- renderUI({
    numericInput('statsLabelY',
                 label = h4("Significance Label Y"), 
                 min = 0, 
                 value = round(max(processedData$df()$value)*1.05))
  })
  
  output$scaleLimitsUI <- renderUI({
   tagList(
     column(6,
           numericInput("minScale", 
                        label = h4("Min Scale Limit"), 
                        value = 0)
    ),
    column(6,
           numericInput("maxScale", 
                        label = h4("Max Scale Limit"), 
                        value = round(max(processedData$df()$value)*1.1))
    )
    )
  })
  
  # Render the uploaded Data
  # output$rainCloudData <- renderDataTable({
  #   processedData$df()
  # })

  # Generate the Plot Code 
  plotCode <- reactive({createPlot(input)})
  
  ## Plot the plot
  output$rainCloudPlot <- renderPlot(
    height = function(x) input$height,
    width = function(x) input$width,
    {plotData = processedData$df()
    p <- eval(parse(text = glue(plotCode())))
    p
  })
  
  # Print the summary code
  output$rainCloudCode <- renderText({
    
    plotSummary <- glue(plotCode())
  
    ## We don't want all "+" to be followed by a linebreak, so only the ones 
    ## have a space before them will do.
    plotSummary <- str_replace_all(plotSummary, " \\+ ", " +\n  ")
    ## Add a space before the rest now.
    plotSummary <- str_replace_all(plotSummary, "\\)\\+ ", ") + ")

    plotSummary
  })

  ## last_plot() is not updated if we change the input data.
  ## returnPlot()$plot is a ggghost object, not a ggplot object. Careful.
  ## returnPlot()$plot is not updated if we change the input data. I assume that
  ## is a problem with reactivity, modules and ids but I am not knowledgeable 
  ## enough with that.
  # output$rainCloudpng <- callModule(downloadPlot, id = "rainCloudpng",
  #                                   plot = print(returnPlot()$plot),
  #                                   fileType = "png",
  #                                   width = input$width / 72,
  #                                   height = input$height / 72)
  # output$rainCloudtiff <- callModule(downloadPlot, id = "rainCloudtiff", 
  #                                   plot = returnPlot()$plot,
  #                                   fileType = 'tiff',
  #                                   width = input$width / 72,
  #                                   height = input$height / 72)
  # output$rainCloudpdf <- callModule(downloadPlot, id = "rainCloudpdf",
  #                                   plot = returnPlot()$plot,
  #                                   fileType = "pdf",
  #                                   width = input$width / 72,
  #                                   height = input$height / 72)
  
  ## Temporal solution.
  output$png <- downloadHandler(
    filename = function() {
      paste(processedData$name(), "png", sep = ".")
    },
    content = function(file) {
      ggsave(
        filename = file,
        plot = print(returnPlot()$plot),
        device = "png",
        width = input$width / 72,
        height = input$height / 72,
        units = "in",
        dpi = 300
      )
    }
  )
  
  output$pdf <- downloadHandler(
    filename = function() {
      paste(processedData$name(), "pdf", sep = ".")
    },
    content = function(file) {
      ggsave(
        filename = file,
        plot = print(returnPlot()$plot),
        device = "pdf",
        width = input$width / 72,
        height = input$height / 72,
        units = "in",
        dpi = 300
      )
    }
  )
  
  output$tiff <- downloadHandler(
    filename = function() {
      paste(processedData$name(), "tiff", sep = ".")
    },
    content = function(file) {
      ggsave(
        filename = file,
        plot = print(returnPlot()$plot),
        device = "tiff",
        width = input$width / 72,
        height = input$height / 72,
        units = "in",
        dpi = 300
      )
    }
  )
  
  # Should probably move that but it's convenient while editing.
  output$rainCloudAbout <- renderUI ({
    HTML("<h2>Raincloud Plots</h2>
<p>The idea behind Raincloud plots was introduced by <a href='https://micahallen.org/2018/03/15/introducing-raincloud-plots/'>Micah Allen on his blog</a>. My coworkers and I found it really interesting to display our data but they did not have any R experience, so I made this shiny app to provide a smooth transition to R and ggplot.</p>
<p>Please cite the preprint (<a href='https://peerj.com/preprints/27137v1/'>here</a>) if you use it in any kind of publication.</p>
<small>The source code for this shiny app can be found in <a href='https://github.com/gabrifc/raincloud-shiny'>Github</a></small>
")
  })
}