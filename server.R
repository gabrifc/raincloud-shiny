#
# TODO: Download Zip.
# TODO: Modularize downloads.
# TODO: Add About & Intro.
# TODO: Add plot Templates.
#

library('glue')
library('stringr')

source("source/createPlot.R", local = TRUE)
source("source/formatCode.R", local = TRUE)
#source("source/downloadPlot.R", local = TRUE)
source("source/dataUpload.R", local = TRUE)

server <- function(input, output, session) {
  
  inputData <- callModule(dataUpload, "rainCloud")
  
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
    
    combinationList <- combn(input$filterColumns, 2, FUN = paste, 
                             collapse = 'vs')
    selectInput("statsCombinations", 
                label = h4("Conditions To Test"),
                choices = combinationList,
                multiple = TRUE)
  })

  output$DataFilterColumns <- renderUI({
    req(inputData$conditions())
    selectInput('filterColumns',
                label = h4("Select Columns to Plot"), 
                choices = inputData$conditions(),
                selected = inputData$conditions(),
                multiple = TRUE)
  })
  
  output$statsLabelUI <- renderUI({
    numericInput('statsLabelY',
                 label = h4("Multiple Significance Label Y height"), 
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
  
  # Process the data. This is a reactive!
  processedData <- reactive({callModule(dataManipulation, "rainCloud", 
                              inputData,
                              input$filterColumns)})
  # Generate the Plot Code 
  plotCode <- reactive({createPlot(input)})
  
  plotFigure <- reactive({
    plotData <- processedData()$df()
    eval(parse(text = glue(plotCode())))
  })
  
  ## Output the plot
  output$rainCloudPlot <- renderPlot(
    height = function(x) input$height,
    width = function(x) input$width,
    {plotFigure()})
  
  # Print the code
  output$rainCloudCode <- renderText({
    ## We don't render the Code without a file.
    req(inputData$name())
    formatCode(input, inputData$code(), processedData()$code(), plotCode())
  })
  
  output$downloadPlot <- downloadHandler(
    filename = function() {
      paste(paste('rainCloudPlot-',inputData$name(), sep = ""), 
            input$downloadFormat, sep = ".")
    },
    content = function(file) {
      ggsave(file,
             plot = plotFigure(),
             device = input$downloadFormat,
             width = input$width / 72,
             height = input$height / 72,
             units = "in",
             dpi = 300)
    }
  )
  
  # callModule(downloadPlot, id = "rainCloudDownload",
  #            plot = plotFigure(),
  #            fileName = inputData$name(),
  #            width = input$width / 72,
  #            height = input$height / 72)

  # Should probably move that but it's convenient while editing.
  output$rainCloudAbout <- renderUI ({
    HTML("<h2>Raincloud Plots</h2>
<p>The idea behind Raincloud plots was introduced by <a href='https://micahallen.org/2018/03/15/introducing-raincloud-plots/'>Micah Allen on his blog</a>. My coworkers and I found it really interesting to display our data but they did not have any R experience, so I made this shiny app to provide a smooth transition to R and ggplot.</p>
<p>Please cite the preprint (<a href='https://peerj.com/preprints/27137v1/'>here</a>) if you use it in any kind of publication.</p>
<small>The source code for this shiny app can be found in <a href='https://github.com/gabrifc/raincloud-shiny'>Github</a></small>
")
  })
}