library('shiny')
source("source/dataUploadUI.R", local = TRUE)
source("source/downloadPlotUI.R", local = TRUE)
source("source/paletteColours.R", local = TRUE)

ui <- fluidPage (
  
  # Application title
  titlePanel("Raincloud Plots"),
  
  # Sidebar  
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(type = "pills",
                  tabPanel("Data",
                           dataUploadUI("rainCloud", label = "File input")),
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
                                                  column(6,
                                                         numericInput("minScale", 
                                                                      label = h4("Min Scale Limit"), 
                                                                      value = 0)
                                                  ),
                                                  column(6,
                                                         numericInput("maxScale", 
                                                                      label = h4("Max Scale Limit"), 
                                                                      value = 2000)
                                                  )
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
                                                             "<div style='width:100%%;padding:5px;border-radius:4px;background:%s;color:%s'>%s</div>",
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
                  # column(12,
                  #       h3('Roughify')),
                  # column(12,
                  #        checkboxInput("ggrough", 
                  #                      "Add ggrough", 
                  #                      FALSE)),
                  # column(6,
                  #        selectInput("ggroughFillStyle", 
                  #                    label = h4("Fill Style"),
                  #                    choices = list(
                  #                      "solid",
                  #                      "hachure",
                  #                      "cross-hatch",
                  #                      "dotdash"
                  #                    ),
                  #                    selected = "hachure")
                  #        ),
                  # column(6,
                  #        sliderInput("ggroughAngle", 
                  #                    label = h4("Line Angle"),
                  #                    min = 0,
                  #                    max = 360,
                  #                    value = 60,
                  #                    step = 10)
                  # ),
                  # column(6,
                  #        sliderInput("ggroughFillWeight", 
                  #                    label = h4("Fill Weight"),
                  #                    min = 1,
                  #                    max = 10,
                  #                    value = 4,
                  #                    step = 1)
                  # ),
                  # column(6,
                  #        sliderInput("ggroughRoughness", 
                  #                    label = h4("Roughness"),
                  #                    min = 0,
                  #                    max = 4,
                  #                    value = 1.5,
                  #                    step = 0.25)
                  # )
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
                                  checkboxInput("violinPlots", 
                                                "Plot Violins", 
                                                TRUE)),
                           conditionalPanel(
                             condition = 'input.violinPlots == true',
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
                                                  TRUE)
                             ),
                             column(6,
                                    sliderInput("violinAlpha", 
                                                label = h4("Transparency"),
                                                min = 0,
                                                max = 1,
                                                value = 1,
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
                                    column(12,
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
                                                                  FALSE)))
                                    ),
                           conditionalPanel(
                             condition = '(input.statsType == "nonParametric" && input.statsWilcoxon == true) || (input.statsType == "parametric" && input.statsTtest == true)',
                             column(12,
                                    uiOutput("statsCombinationsUI"))),
                           column(6,
                                  uiOutput("statsLabelUI")
                           ),
                           column(6,
                                  selectInput('statsLabelFormat',
                                              label = h4("Pariwise value Format"),
                                              choices = list(
                                                'Significance (stars)' = 'p.signif',
                                                'P Values' = 'p.format'
                                              )))),
                           
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
                         h3("Save the plot")),
      ## Code is prepared for a selectInput with the option formats, but users
      ## requested these 3 buttons as they find it easier. 
      ## Harcoding fixes problem with plotting outdated data, 
      ## but needs to be studied.
      column(12,
             p("Select the format in which you wish to save the generated plot."),
             column(4,
                    # downloadPlotUI(id = "rainCloudpng", 
                    #                label = "png"),
                    downloadButton("png", 
                                   label = "png")),
             column(4,
                    # downloadPlotUI(id = "rainCloudtiff", 
                    #                label = "tiff"),
                    downloadButton("tiff", 
                                   label = "tiff")),
             column(4,
                    # downloadPlotUI(id = "rainCloudpdf", 
                    #                label = "pdf"),
                    downloadButton("pdf", 
                                   label = "pdf"))),
      ## Clearfix
      tags$div(class = 'clearfix')
      ),
    
      ## The mainPanel output
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Plot & Code",
                             plotOutput("rainCloudPlot", 
                                        height = "auto"),
                             h3("Relevant Plot Code"),
                             verbatimTextOutput("rainCloudCode")),
                    tabPanel("About",
                             htmlOutput("rainCloudAbout"))
                    # tabPanel("Processed Data",
                    #          dataTableOutput("rainCloudDataSummary"),
                    #          dataTableOutput("rainCloudData"))
        )
      )
    )
  )
  