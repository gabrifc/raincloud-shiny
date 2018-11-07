library('shiny')
source("source/dataUploadUI.R", local = TRUE)
#source("source/downloadPlotUI.R", local = TRUE)
source("source/paletteColours.R", local = TRUE)

ui <- fluidPage (
  # CSS, fixes palette picker (//github.com/gabrifc/raincloud-shiny/issues/12)
  tags$style(".bootstrap-select .dropdown-menu li a span.text {width: 100%;}
             #downloadPlot {margin-top: 25px}"), 
  
  # Application title
  titlePanel("Raincloud Plots"),
  
  # Sidebar  
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(type = "pills",
                  tabPanel("Data",
                           dataUploadUI("rainCloud", label = "File input"),
                           column(12,
                                  uiOutput('DataFilterColumnsUI')),
                           column(12,
                                  hr())),
                  tabPanel("Plot Options", 
                           tabsetPanel(type = "pills",
                                       tabPanel("Titles and Scale",
                                                column(12,
                                                       h3("Titles")),
                                                column(12,
                                                       textInput("plotTitle", 
                                                                 label = h4("Main Plot Title"), 
                                                                 value = "Main Plot Title")),
                                                column(6,
                                                       textInput("xAxisTitle", 
                                                                 label = h4("x Axis Title"), 
                                                                 value = "x Axis Title")
                                                ),
                                                column(6,
                                                       textInput("yAxisTitle", 
                                                                 label = h4("y Axis Title"), 
                                                                 value = "y Axis Title")
                                                ),
                                                column(6,
                                                       numericInput("titleFontSize", 
                                                                    label = h4("Main Title Font Size"), 
                                                                    value = 20,
                                                                    min = 0)),
                                                column(6,
                                                       numericInput("axisFontSize", 
                                                                    label = h4("Axis Title Font Size"), 
                                                                    value = 15,
                                                                    min = 0)),
                                                column(12,
                                                       h3("Scale")),
                                                column(12,
                                                       checkboxInput("autoScale", 
                                                                     "Automatic Scale Limits", 
                                                                     TRUE)),
                                                conditionalPanel(
                                                  condition = "input.autoScale == false",
                                                  uiOutput("scaleLimitsUI")
                                                ),
                                                column(12,
                                                       hr())),
                                       tabPanel("Graphical Options",
                                                column(12,
                                                       h3("Size")),
                                                column(6,
                                                       numericInput("height", 
                                                                    label = h4("Plot Height"), 
                                                                    value = 600)
                                                ),
                                                column(6,
                                                       numericInput("width", 
                                                                    label = h4("Plot Width"), 
                                                                    value = 600)
                                                ),
                                                column(6,
                                                       checkboxInput("plotLegend", 
                                                                     "Show Legend", 
                                                                     FALSE)
                                                ),
                                                column(6,
                                                       checkboxInput("plotFlip", 
                                                                     "Make it rain! (Flip the Axis)", 
                                                                     FALSE)
                                                ),
                                                column(6,
                                                       checkboxInput("plotMajorGrid", 
                                                                     "Plot Major Grid", 
                                                                     FALSE)
                                                ),
                                                column(6,
                                                       conditionalPanel(
                                                         condition = 'input.plotMajorGrid == true',
                                                         checkboxInput("plotMinorGrid", 
                                                                       "Plot Minor Grid", 
                                                                       FALSE))
                                                ),
                                                column(12,
                                                       h3("Theme and colors")),
                                                
                                                column(12,
                                                       selectInput("plotTheme", 
                                                                   label = h4("Theme"),
                                                                   choices = list(
                                                                     "Default (Grey)" = "theme_grey()",
                                                                     "Black & White" = "theme_bw()",
                                                                     "Linedraw" = "theme_linedraw()",
                                                                     "Light" = "theme_light()",
                                                                     "Dark" = "theme_dark()",
                                                                     "Minimal" = "theme_minimal()",
                                                                     "Classic" = "theme_classic()",
                                                                     "Void" = "theme_void()",
                                                                     "Cowplot" = "theme_cowplot()"
                                                                   ),
                                                                   selected = "theme_cowplot()")),
                                                column(12,
                                                       pickerInput(
                                                         inputId = "plotPalette", 
                                                         label = h4("Palette"),
                                                         choices = colors_pal, 
                                                         selected = "Set1", 
                                                         width = "100%",
                                                         choicesOpt = list(
                                                           content = sprintf(
                                                             "<div style='width:100%%;padding:2px;border-radius:4px;background:%s;color:%s'>%s</div>",
                                                             unname(background_pals), 
                                                             colortext_pals, 
                                                             names(background_pals)
                                                           )
                                                         )
                                                       )),
                                                column(12,
                                                       h3('Extra Horizontal Line')),
                                                column(12,
                                                       checkboxInput("horizontalLine", 
                                                                     "Show Horizontal Line", 
                                                                     FALSE)),
                                                conditionalPanel(
                                                  condition = 'input.horizontalLine == true',
                                                  column(6,
                                                         numericInput("horizontalLinePosition", 
                                                                      label = h4("Position"), 
                                                                      value = 100)
                                                  ),
                                                  column(6,
                                                         selectInput("horizontalLineType", 
                                                                     label = h4("Linetype"),
                                                                     choices = list(
                                                                       "solid",
                                                                       "dashed",
                                                                       "dotted",
                                                                       "dotdash"
                                                                     ),
                                                                     selected = "dashed")
                                                  ),
                                                  column(6,
                                                         sliderInput("horizontalLineSize", 
                                                                     label = h4("Line Size"),
                                                                     min = 0,
                                                                     max = 2,
                                                                     value = 0.2,
                                                                     step = 0.1)
                                                  ),
                                                  column(6,
                                                         sliderInput("horizontalLineAlpha", 
                                                                     label = h4("Transparency"),
                                                                     min = 0,
                                                                     max = 1,
                                                                     value = 1,
                                                                     step = 0.05)
                                                  )
                                                ),
                                                column(12,
                                                       hr())))),
                  tabPanel("Dots",
                           column(12,
                                  h3("Data Points")),
                           column(12,
                                  checkboxInput("plotDots", 
                                                "Plot Data Points", 
                                                TRUE)),
                           conditionalPanel(
                             condition = 'input.plotDots == true',
                             column(12,
                                    selectInput("dotColumnType", 
                                                label = h4("Column Type"),
                                                choices = list(
                                                  "Jitter" = 'jitterDots',
                                                  "Beeswarm" = 'beeswarm'
                                                ),
                                                selected = 'jitterDots')),
                             column(6,
                                    numericInput("dotSize", 
                                                 label = h4("Dot Size"), 
                                                 value = 2)
                             ),
                             column(6,
                                    selectInput("dotShape", 
                                                label = h4("Dot Shape"),
                                                choices = list(
                                                  "Empty Dot" = 1,
                                                  "Filled Dot" = 16,
                                                  "Square" = 15,
                                                  "Triangle" = 17),
                                                selected = 16)
                             ),
                             column(6,
                                    sliderInput("dotsWidth", 
                                                label = h4("Plot Width"),
                                                min = 0,
                                                max = 0.5,
                                                value = 0.15,
                                                step = 0.05)),
                             column(6,
                                    sliderInput("dotAlpha", 
                                                label = h4("Transparency"),
                                                min = 0,
                                                max = 1,
                                                value = 1,
                                                step = 0.05))),
                           column(12,
                                  hr())),
                  tabPanel("Violin", 
                           column(12,
                                  h3("Violin Plots")),
                           column(12,
                                  checkboxInput("plotViolins", 
                                                "Plot Violins", 
                                                TRUE)),
                           conditionalPanel(
                             condition = 'input.plotViolins == true',
                             column(6,
                                    selectInput("violinType", 
                                                label = h4("Type of Violin"),
                                                choices = list(
                                                  "Full Violin" = "geom_violin",
                                                  "Half Violin" = "geom_flat_violin"
                                                ),
                                                selected = "geom_flat_violin")
                             ),
                             column(6,
                                    sliderInput("violinNudge", 
                                                label = h4("Center Offset"),
                                                min = 0,
                                                max = 0.5,
                                                value = 0.20,
                                                step = 0.05)
                             ),
                             column(6,
                                    selectInput("violinScale", 
                                                label = h4("Scale of the violin"),
                                                choices = list(
                                                  "Same Area" = "area",
                                                  "Maximum Width" = "width"
                                                ),
                                                selected = "width")
                             ),
                             column(6,
                                    numericInput("violinAdjust", 
                                                 label = h4("Bandwidth Adjustement"), 
                                                 value = 2,
                                                 min = 1)
                             ),
                             column(6,
                                    checkboxInput("violinTrim", 
                                                  "Trim Edges to Data Points", 
                                                  TRUE),
                                    conditionalPanel(
                                      condition =' input.violinType == "geom_violin"',
                                      checkboxInput("violinQuantiles",
                                                    "Draw 50% Quantile",
                                                    TRUE)
                                    )
                             ),
                             column(6,
                                    sliderInput("violinAlpha", 
                                                label = h4("Transparency"),
                                                min = 0,
                                                max = 1,
                                                value = 0.6,
                                                step = 0.05)
                             )
                           ),
                           
                           column(12,
                                  hr())),
                  tabPanel("Boxplot",
                           column(12,
                                  h3("Boxplots")),
                           column(12,
                                  checkboxInput("boxPlots", 
                                                "Plot Boxplots", 
                                                TRUE)
                           ),
                           conditionalPanel(
                             condition = 'input.boxPlots == true',
                             column(6,
                                    checkboxInput("boxplotNotch", 
                                                  "Add Notch", 
                                                  FALSE),
                                    checkboxInput("boxplotBoxWidth",
                                                  "Width Proportional to Data",
                                                  FALSE),
                                    checkboxInput("boxplotOutliers",
                                                  "Plot Outliers",
                                                  FALSE)
                             ),
                             ## I don't like this one.
                             # column(6,
                             #        selectInput("boxplotOutliers",
                             #             label = h4("Show Outliers"),
                             #             choices = list(
                             #               "Yes" = 16,
                             #               "No" = NA
                             #             ),
                             #             selected = NA)),
                             column(6,
                                    sliderInput("boxplotWidth", 
                                                label = h4("Boxplot Width"),
                                                min = 0,
                                                max = 0.5,
                                                value = 0.1,
                                                step = 0.05)
                             ),
                             column(6,
                                    sliderInput("boxplotNudge", 
                                                label = h4("Center Offset"),
                                                min = 0,
                                                max = 0.5,
                                                value = 0.20,
                                                step = 0.05)
                             ),
                             column(6,
                                    sliderInput("boxplotAlpha", 
                                                label = h4("Transparency"),
                                                min = 0,
                                                max = 1,
                                                value = 0.3,
                                                step = 0.05)
                             )),
                           column(12,
                                  hr())), 
                  tabPanel("Statistics",
                           column(12,
                                  h3("Significance")),
                           column(12,
                                  checkboxInput("statistics", 
                                                "Compare the means", 
                                                FALSE)
                           ),
                           ## I could do all of that with updateSelectInput probably but I like how this looks.
                           conditionalPanel(
                             condition = 'input.statistics == true',
                             column(6,
                                    selectInput("statsType", 
                                                label = h4("Type of Test"),
                                                choices = list(
                                                  "Parametric" = "parametric",
                                                  "Non-parametric" = "nonParametric"),
                                                selected = "nonParametric")
                             ),
                             ## Parametric
                             conditionalPanel(
                               condition = 'input.statsType == "parametric"',
                               column(6,
                                      checkboxInput("statsTtest", 
                                                    "Pairwise (T-test)", 
                                                    FALSE),
                                      checkboxInput("statsAnova", 
                                                    "Multiple (ANOVA)", 
                                                    FALSE)
                               )),
                             ## Non Parametric
                             conditionalPanel(
                               condition = 'input.statsType == "nonParametric"',
                               column(6,
                                      checkboxInput("statsWilcoxon", 
                                                    "Pairwise (Wilcoxon Test)", 
                                                    FALSE),
                                      checkboxInput("statsKruskal", 
                                                    "Multiple (Kruskal-Wallis)", 
                                                    FALSE))),
                             div(class="clearfix"),
                             conditionalPanel(
                               ## Pairwise
                               condition = '(input.statsType == "nonParametric" && input.statsWilcoxon == true) || (input.statsType == "parametric" && input.statsTtest == true)',
                               column(12,
                                      uiOutput("statsCombinationsUI")),
                               column(6,
                                      selectInput('statsLabelFormat',
                                                  label = h4("Pairwise value Format"),
                                                  choices = list(
                                                    'Significance (stars)' = '..p.signif..',
                                                    'P Values' = '..p.adj..'
                                                  ))),
                               # column(6,
                               #        sliderInput('statsLabelDigits',
                               #                    label = h4("P-Value digits"),
                               #                    min = 1,
                               #                    max = 5,
                               #                    value = 3,
                               #                    step = 1))
                               column(6,
                                      selectInput(('statsPairwiseCorrection'), 
                                                  label = h4("Pairwise Multitest Correction"),
                                                  choices = list(
                                                    'Holm (1979)' = 'holm', 
                                                    'Hochberg (1988)' = 'hochberg', 
                                                    'Hommel (1988)' = 'hommel', 
                                                    'Bonferroni' = 'bonferroni', 
                                                    'Benjamini & Hochberg (1995) (FDR)' = 'BH', 
                                                    'Benjamini & Yekutieli (2001)'= 'BY',
                                                    'Tukey' = 'tukey',
                                                    'None' = 'none'
                                                  ),
                                                  selected = 'BH'))
                             ),
                             conditionalPanel(
                               condition = '(input.statsType == "nonParametric" && input.statsKruskal == true) || (input.statsType == "parametric" && input.statsAnova == true)',
                               column(6,
                                      uiOutput("statsLabelUI")))),
                           ## Mean
                           column(12,
                                  h3("Mean")),
                           column(12,
                                  checkboxInput("statsMean", 
                                                "Plot mean", 
                                                FALSE)
                           ),
                           conditionalPanel(
                             ## Maybe change to a dropdown menu with options.
                             condition = "input.statsMean == true",
                             column(6,
                                    selectInput('statsMeanErrorBars',
                                                label = h4("Add error bars to the mean"),
                                                choices = list(
                                                  'None' = 'none',
                                                  '95% Confidence Interval' = 'mean_cl_boot',
                                                  'Stardard Error' = 'mean_se',
                                                  'Standard Deviation' = 'mean_sd'
                                                ),
                                                selected = 'none')
                             ),
                             column(6,
                                    sliderInput("statsMeanWidth", 
                                                label = h4("Mean Width"),
                                                min = 0,
                                                max = 1,
                                                value = 0.5,
                                                step = 0.05)
                             ),
                             column(6,
                                    sliderInput("statsMeanNudge", 
                                                label = h4("Center Offset"),
                                                min = 0,
                                                max = 0.5,
                                                value = 0.20,
                                                step = 0.05)
                             ),
                             column(6,
                                    sliderInput("statsMeanSize", 
                                                label = h4("Line Size"),
                                                min = 0,
                                                max = 2,
                                                value = 0.2,
                                                step = 0.1)
                             )
                           ),
                           
                           column(12,
                                  hr()))
      ),
      column(12,
             h3("Download the plot image")),
      # downloadPlotUI(id = 'rainCloudDownload',
      #                label = "Image format",
      #                buttonLabel = "Download"),
      column(6,
             selectInput("downloadFormat",
                         label = "Image format",
                         choices = list(
                           "Vectorial" = list(
                             "pdf" = "pdf",
                             "svg" = "svg",
                             "eps" = "eps"
                           ),
                           "Non-vectorial" = list(
                             "tiff" = "tiff",
                             "png" = "png")
                         ),
                         selected = "pdf")),
      column(6,
             downloadButton("downloadPlot", 
                            label = "Download")),
      column(12,
             p("Or, alternatively, download a zip file with the script and data
               used to generate the plot."),
             downloadButton('downloadScript',
                            label = 'Download Zip File')),

      ## Clearfix
      tags$div(class = 'clearfix')
    ),
    
    ## The mainPanel output
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Plot",
                           plotOutput("rainCloudPlot", 
                                      height = "auto")),
                  tabPanel("R Code",
                           column(8,
                                  h3("Plot Code"),
                                  verbatimTextOutput("rainCloudCode"))),
                  tabPanel("About",
                           includeHTML("www/about.html"))
                  # tabPanel("Processed Data",
                  #          dataTableOutput("rainCloudDataSummary"),
                  #          dataTableOutput("rainCloudData"))
      )
    )
  )
)
