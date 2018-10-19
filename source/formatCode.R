library("gsubfn")

formatCode <- function(input, code) {
  # print(summaryPrint)
  
  # Easy but doesn't add quotes where needed.
  # summaryPrint2 <- glue(gsub("(input\\$\\w+)", "\\{\\1\\}", summaryPrint))
  # print(summaryPrint2)
  
  # Exactly same result
  # summaryPrint5 <- strsplit(gsub("(input\\$\\w+)", "@\\1@", summaryPrint), 
  #                           split = "@")
  # for (line in 1:length(summaryPrint5[[1]])) {
  #   if (line %% 2 == 0) {
  #     summaryPrint5[[1]][line] <- eval(parse(text = summaryPrint5[[1]][line]))
  #   }
  # }
  # summaryPrint5 <- paste0(unlist(summaryPrint5), collapse = "")
  # print(summaryPrint5)
  
  # Same as glue
  # summaryPrint3 <- gsubfn("input\\$\\w+", function(x) eval(parse(text = x)), 
  #                        summaryPrint)
  # print(summaryPrint3)
  
  # Sometimes does not work
  # summaryPrint4 <- gsubfn("input\\$\\w+", function(x) identity(x), 
  #                        summaryPrint)
  # print(summaryPrint4)
  
  # Directly gives error
  # summaryPrint5 <- fn$identity(summaryPrint) -- should work but gives Error
  # print(summaryPrint5)
  
  # Manually add quotes
  checkQuotes <- function (x) {
    # Doesn't  work
    # x <- identity(x)
    x <- eval(parse(text = x))
    # Check if only numbers
    if(!grepl("[A-Za-z]", x)) {
      return(x)
    } else {
      # There are letters, add quotes
      return(shQuote(x))
    }
  }
  
  code <- gsubfn("input\\$\\w+", function(x) checkQuotes(x), 
                 code)
  ## Add linebreaks
  code <- gsub('\\+ (\\D)', "+ \n\t\\1", code)
  
  #writeLines(gsub('\\+', "+ \n", cat(summaryPrint[[1]], sep = "\"")))
  
  return(code)
}