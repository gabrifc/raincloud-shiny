formatCode <- function(input, dataLoadingCode, dataManipulationCode, plotCode) {
  
  librariesCode <- getLibrariesCode(input)
  
  prePlotCode <- '## And plot the data'
  
  allCode <- glue(paste(librariesCode, 
                        dataLoadingCode, 
                        dataManipulationCode,
                        prePlotCode, 
                        plotCode, 
                        sep = "\n"))
  ## We don't want all "+" to be followed by a linebreak, so only the ones 
  ## have a space before them will do.
  allCode <- str_replace_all(allCode, " \\+ ", " +\n  ")
  ## Add a space before the rest now.
  allCode <- str_replace_all(allCode, "\\)\\+ ", ") + ")
  
  return(allCode)
}

getLibrariesCode <- function(input) {
  librariesUsed <- c('ggplot2', 'tidyr', 'dplyr')
  if(input$plotTheme == 'theme_cowplot()') {
    librariesUsed <- c(librariesUsed, 'cowplot')
  }
  ggsciPalettes <- c("NPG", "AAAS", "NEJM", "Lancet", "JAMA", "JCO", "UCSCGB", 
                     "LocusZoom", "IGV", "UChicago", "UChicago Light", 
                     "UChicago Dark", "Star Trek", "Tron Legacy", "Futurama", 
                     "Rick and Morty", "The Simpsons")
  if(input$plotPalette %in% ggsciPalettes) {
    librariesUsed <- c(librariesUsed, 'ggsci')
  } else {
    librariesUsed <- c(librariesUsed, 'RColorBewer')
  }
  if(input$plotDots && (input$dotColumnType == 'beeswarm')) {
    librariesUsed <- c(librariesUsed, 'ggbeeswarm')
  }
  if(input$statistics) {
    librariesUsed <- c(librariesUsed, 'ggpubr')
  }
  if(input$statsMeanErrorBars == 'mean_cl_boot') {
    librariesUsed <- c(librariesUsed, 'Hmisc')
  }
  
  librariesCode <- paste(paste0('library("',librariesUsed, '") \n'), 
                         collapse = "")
  if(input$plotViolins && (input$violinType == 'geom_flat_violin')) {
    librariesCode <- paste0(librariesCode, 'source("halfViolinPlots.R") \n')
  }
  
  librariesCode <- paste0('## Load the required libraries\n', librariesCode)
  
  return(librariesCode)
}
source(file = "source/halfViolinPlots.R")