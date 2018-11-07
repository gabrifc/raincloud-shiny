dataUploadUI <- function(id, label = "File input") {
  
  ns <- NS(id)
  
  tagList(
    column(12,
           h3("File Upload"),
           p("Upload a txt or csv file with the different 
                             conditions and values separated by columns."),
           fileInput(ns("excelFile"), 
                     label = h4(label),
                     multiple = FALSE,
                     accept = c("text/csv",
                                "text/comma-separated-values,text/plain",
                                ".csv")),
           p("If a plot does not directly appear on the right, edit the file details here.")),
    column(6,
           checkboxInput(ns("header"), "Header", TRUE)),
    column(6,
           radioButtons(ns("decimalPoint"), "Decimal separator",
                        choices = c(Comma = ',',
                                    Point = '.'),
                        selected = ',',
                        inline = TRUE)),
    column(6,
           radioButtons(ns("sep"), "Column Delimiter",
                        choices = c(Comma = ",",
                                    Semicolon = ";",
                                    Tab = "\t"),
                        selected = "\t")
    ),
    column(6,
           radioButtons(ns("quote"), "Quote",
                        choices = c(None = "",
                                    "Double Quote" = "\"",
                                    "Single Quote" = "'"),
                        selected = "")),
    column(12,
           checkboxInput(ns("sampleData"), "Use sample data", FALSE))
  )
}
