# For gather
library("tidyr")
# For the code (already loaded from server.R)
# library("glue")

dataUpload <- function(input, output, session) {
  
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
  
  name <- reactive({userFile()$name})
  
  code <- reactive({
    quoteCode <- ifelse(input$quote == '\'', '"{input$quote}"', '\'{input$quote}\'')
    sepCode <- ifelse(input$sep == '\t', '\\t', '{input$sep}')
    glue('## Load the data
  inputData <- read.delim2("{name()}",
  header = {input$header},
  sep = \'', sepCode, '\',
  quote = ', quoteCode, ',
  check.names = FALSE,
  dec = \'{input$decimalPoint}\')\n\n')})
  
  return(list(
    inputData = inputData,
    conditions = conditions,
    name = name,
    code = code
  ))
}

dataManipulation <- function(input, output, session, inputData, filterConditions) {
  req(filterConditions)
  # Cleaning here is good for the 'as.numeric' of the boxplots.
  cleanedData <- inputData$inputData()[,filterConditions]
  
  df <- reactive({
    gather(cleanedData,
           condition,
           value,
           filterConditions,
           factor_key = TRUE) %>%
      filter(condition %in% filterConditions) %>%
      filter(value != "")
  })
  
  
## Add code for selecting columns or rearranging them.
  filterConditionsText <- 'c('
  for (i in 1:length(filterConditions)) {
    filterConditionsText <- glue(filterConditionsText, '"{filterConditions[i]}",')
  }
  filterConditionsText <- substr(filterConditionsText,1,nchar(filterConditionsText)-2)
  filterConditionsText <- glue(filterConditionsText, ')')

    code <- reactive({
    glue('## Select the columns and reorder the data if needed
inputData <- inputData[,{filterConditionsText}]

## Reformat the data for ggplot
plotData <- gather(inputData,
  condition,
  value,
  colnames(inputData),
  factor_key = TRUE) %>%
  filter(value != "") \n\n')})
  
  return(list(
    df = df,
    code = code
  ))
}
