reshapeData <- function(input, output, session, data) {
  req(input$excelFile)
  tryCatch({
    data <- read.delim2(
      input$excelFile$datapath,
      header = input$header,
      sep = input$sep,
      quote = input$quote,
      check.names = FALSE
    )
  },
  error = function(e) {
    # return a safeError if a parsing error occurs
    stop(safeError(e))
  })
  
  # Reshape the data
  treatments <- colnames(data)
  reshapedData <- gather(data,
                         treatment,
                         value,
                         treatments,
                         factor_key = TRUE)
  reshapedData <- reshapedData[complete.cases(reshapedData),]
  return(reshapedData)
}