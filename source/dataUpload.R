dataUploadAndManipulation <- function(input, output, session) {
  
  # The selected file, if any
  userFile <- reactive({
    # If no file is selected, don't do anything
    # validate(need(input$excelFile, message = FALSE))
    # return(input$excelFile)
    if (!is.null(input$excelFile)){
      return(input$excelFile)
    } else {
      if(input$sampleData) {
        return(list('name' = 'sampleData',
                    'datapath' = 'source/1.txt'
        ))
      }
      req(input$excelFile)
    }
  })
  # Alt. req(input$excelFile)
  
  inputData <- reactive({
    read.delim2(
      userFile()$datapath,
      header = input$header,
      sep = input$sep,
      quote = input$quote,
      check.names = FALSE,
      dec = input$decimalPoint
    )
  })
  
  conditions <- reactive({
    colnames(inputData())
  })
  
  df <- reactive({
    gather(inputData(),
           condition,
           value,
           conditions(),
           factor_key = TRUE) %>%
      filter(value != "")
  })
  
  # finalData <- reactive({reshapedData[complete.cases(reshapedData()),]})
  
  return(list(
    df = df,
    conditions = conditions
  ))
}