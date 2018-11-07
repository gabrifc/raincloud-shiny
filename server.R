#
# TODO: DRY ggsave calls into function.
# TODO: Add Intro to the functions and files.
# TODO: Add plot Templates.
#

library('glue')
library('stringr')
library('svglite')

source("source/createPlot.R", local = TRUE)
source("source/formatCode.R", local = TRUE)
#source("source/downloadPlot.R", local = TRUE)
source("source/dataUpload.R", local = TRUE)

server <- function(input, output, session) {
  
  # Read the input data.
  inputData <- callModule(dataUpload, "rainCloud")
  
  # Process the data. This is a reactive depending on the inputData!
  processedData <- reactive({callModule(dataManipulation, "rainCloud", 
                              inputData,
                              input$filterColumns)})

  # UI - Data - Filter the data.
  output$DataFilterColumnsUI <- renderUI({
    req(inputData$conditions())
    selectInput('filterColumns',
                label = h4("Select Columns to Plot"), 
                choices = inputData$conditions(),
                selected = inputData$conditions(),
                multiple = TRUE)
  })
  
  # UI - Stats - pairwise comparison input.
  output$statsCombinationsUI <- renderUI({
    combinationList <- combn(input$filterColumns, 2, FUN = paste, 
                             collapse = 'vs')
    selectInput("statsCombinations", 
                label = h4("Conditions To Test"),
                choices = combinationList,
                multiple = TRUE)
  })
  
  # UI - Stats - default multiple comparison label height.
  output$statsLabelUI <- renderUI({
    numericInput('statsLabelY',
                 label = h4("Multiple Significance Label Y height"), 
                 min = 0, 
                 value = round(max(processedData()$df()$value)*1.05))
  })
  
  # UI - Plot - default scale limits.
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
                          value = round(max(processedData()$df()$value)*1.1))
      )
    )
  })
  
  # Generate the plot code based on input options but do not evaluate yet.
  plotCode <- reactive({createPlot(input)})
  
  # Evaluate the code based on the processed data.
  plotFigure <- reactive({
    plotData <- processedData()$df()
    eval(parse(text = glue(plotCode())))
  })
  
  # Render the plot.
  output$rainCloudPlot <- renderPlot({
    # We don't render the plot without inputData.
    req(inputData$name())
    plotFigure()},
    height = function(x) input$height,
    width = function(x) input$width)
  
  # ScriptCode
  scriptCode <- reactive({
    formatCode(input, inputData$code(), processedData()$code(), plotCode())
  })
  
  # Print the code.
  output$rainCloudCode <- renderText({
    # We don't render the code without inputData.
    req(inputData$name())
    scriptCode()
  })
  
  # Download button
  output$downloadPlot <- downloadHandler(
    filename = function() {
      # rainCloudPlot-inputdata.txt.pdf
      paste(paste('rainCloudPlot-',inputData$name(), sep = ""), 
            input$downloadFormat, sep = ".")
    },
    content = function(file) {
      if(input$downloadFormat == 'tiff') {
        ggsave(file,
               plot = plotFigure(),
               device = input$downloadFormat,
               # Width and height are in inches. We increase the dpi to 300, so we
               # have to divide by 72 (original default pixels per inch) 
               width = input$width / 72,
               height = input$height / 72,
               compression = "lzw",
               units = "in",
               dpi = 300)
      } else {
        ggsave(file,
               plot = plotFigure(),
               device = input$downloadFormat,
               # Width and height are in inches. We increase the dpi to 300, so we
               # have to divide by 72 (original default pixels per inch) 
               width = input$width / 72,
               height = input$height / 72,
               units = "in",
               dpi = 300)
      }
    }
  )
  
  # callModule(downloadPlot, id = "rainCloudDownload",
  #            plot = plotFigure(),
  #            fileName = inputData$name(),
  #            width = input$width / 72,
  #            height = input$height / 72)
  
  # Download zip file with script, data, and plots.
  output$downloadZip <- downloadHandler(
    filename = function() {
      paste0("RainCloudPlot-", inputData$name(), ".zip")
    },
    content = function(fname) {
      fs <- c()
      tmpdir <- tempdir()
      # inputData

      # Copy inputData to tmpDir
      file.copy(from = c(inputData$datapath()),
                to = tmpdir)

      # Copy halfViolinPlots.R to tmpDir
      file.copy(from = c("source/halfViolinPlots.R"), 
                to = tmpdir)
      
      # Move to the tmpDir to work with the tmpFiles
      setwd(tmpdir)
      
      # Change the name of the uploaded file so that the code still works.
      tmpInputFile <- basename(inputData$datapath())
      file.rename(from = tmpInputFile,
                  to = inputData$name())
    
      # Code
      write(scriptCode(), "rainCloudPlot.R")

      fs <- c(fs, inputData$name(), "rainCloudPlot.R", "halfViolinPlots.R")
      
      # Create all images (except tiff that is compressed).
      for (format in c('pdf','svg','eps','png')) {
        file <- paste(paste0('rainCloudPlot-',inputData$name()),
                      format, sep = ".")
        ggsave(file,
               plot = plotFigure(),
               device = format,
               width = input$width / 72,
               height = input$height / 72,
               units = "in",
               dpi = 300)
        fs <- c(fs, file)
      }
      
      # Add compressed .tiff
      tiffFile <- paste(paste0('rainCloudPlot-',inputData$name()),
                        'tiff', sep = ".")
      ggsave(tiffFile,
             plot = plotFigure(),
             device = 'tiff',
             compression = "lzw",
             width = input$width / 72,
             height = input$height / 72,
             units = "in",
             dpi = 300)
      fs <- c(fs, tiffFile)
      
      # And create the zip
      zip(zipfile=fname, files=fs)
    },
    contentType = "application/zip"
  )
}