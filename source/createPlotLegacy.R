library("ggplot2")
library("cowplot")
## Save the ggplot calls for easier recovering on format
library("ggghost")
## Statistics
library("ggpubr")
## Beeswarm dots
library("ggbeeswarm")
## Already loaded from ui.R
## Colour themes
# library("ggsci")
# library("RColorBrewer")
## The half violin geom
source(file = "source/halfViolinPlots.R")

createPlot <- function(input, plotData) {
  
  ## Start the plot and pipe into ggghost.
  plot %g<% ggplot(plotData, aes(x = condition, y = value, 
                                 fill = condition, color = condition))
  
  ## Get the input into supp data so that we can use ggghost. Clunky, but works.
  ## Maybe do not rely on ggghost for next iterations.
  supp_data(plot) <- input
  
  ## Titles
  ## With if(input$plotTitle != "") {} we couldn't leave empty titles.
  plot <- plot + ggtitle(input$plotTitle) + ylab(input$yAxisTitle) + 
    xlab(input$xAxisTitle)
  
  ## Colour Palette. Could shorten with eval(parse(text=xxx)) but XSS?
  if (input$plotPalette != "default") {
    ## ggsci
    if (input$plotPalette == "NPG") {
      plot <- plot + scale_color_npg() + scale_fill_npg()
    } else if (input$plotPalette == "AAAS") {
      plot <- plot + scale_color_aaas() + scale_fill_aaas()
    } else if (input$plotPalette == "NEJM") {
      plot <- plot + scale_color_nejm() + scale_fill_nejm()
    } else if (input$plotPalette == "Lancet") {
      plot <- plot + scale_color_lancet() + scale_fill_lancet()
    } else if (input$plotPalette == "JAMA") {
      plot <- plot + scale_color_jama() + scale_fill_jama()
    } else if (input$plotPalette == "JCO") {
      plot <- plot + scale_color_jco() + scale_fill_jco()
    } else if (input$plotPalette == "UCSCGB") {
      plot <- plot + scale_color_ucscgb() + scale_fill_ucscgb()
    } else if (input$plotPalette == "LocusZoom") {
      plot <- plot + scale_color_locuszoom() + scale_fill_locuszoom()
    } else if (input$plotPalette == "IGV") {
      plot <- plot + scale_color_igv() + scale_fill_igv()
    } else if (input$plotPalette == "UChicago") {
      plot <- plot + scale_color_uchicago() + scale_fill_uchicago()
    } else if (input$plotPalette == "UChicago Light") {
      plot <- plot + scale_color_uchicago("light") + scale_fill_uchicago("light")
    } else if (input$plotPalette == "UChicago Dark") {
      plot <- plot + scale_color_uchicago("dark") + scale_fill_uchicago("dark")
    } else if (input$plotPalette == "Star Trek") {
      plot <- plot + scale_color_startrek() + scale_fill_startrek()
    } else if (input$plotPalette == "Tron Legacy") {
      plot <- plot + scale_color_tron() + scale_fill_tron()
    } else if (input$plotPalette == "Futurama") {
      plot <- plot + scale_color_futurama() + scale_fill_futurama()
    } else if (input$plotPalette == "Rick and Morty") {
      plot <- plot + scale_color_rickandmorty() + scale_fill_rickandmorty()
    } else if (input$plotPalette == "The Simpsons") {
      plot <- plot + scale_color_simpsons() + scale_fill_simpsons()
    } else {
      # Color Brewer
      plot <- plot + scale_colour_brewer(palette = input$plotPalette) + 
        scale_fill_brewer(palette = input$plotPalette)
    }
  }
  
  #else if (input$plotPalette == "GSEA") {
  #plot <- plot + scale_color_gsea() + scale_fill_gsea()
  #} 
  
  ## Background Horizontal Line
  if (input$horizontalLine) {
    plot <- plot + geom_hline(yintercept = input$horizontalLinePosition, 
                              linetype = input$horizontalLineType, 
                              size = as.numeric(input$horizontalLineSize), 
                              alpha = input$horizontalLineAlpha)
  }
  
  ## Data Points
  if(input$plotDots) {
    
    if (input$dotColumnType == 'jitterDots') {
      ## Jitter Dots
      ## I prefer to do it like this instead of shape = ifelse() because the code
      ## output is cleaner (see boxplots)
      if (input$dotShape == "treatment") {
        plot <- plot + geom_point(position = position_jitter(input$dotsWidth), 
                                  size = input$dotSize, alpha = input$dotAlpha, 
                                  aes(shape = condition))
      } else {
        plot <- plot + geom_point(position = position_jitter(input$dotsWidth), 
                                  size = input$dotSize, alpha = input$dotAlpha, 
                                  shape = as.numeric(input$dotShape))
      }
    } else {
      ## Beeswarm
      if (input$dotShape == "treatment") {
        plot <- plot + geom_beeswarm(dodge.width = input$dotsWidth, 
                                     size = input$dotSize, alpha = input$dotAlpha, 
                                     aes(shape = condition))
      } else {
        plot <- plot + geom_beeswarm(dodge.width = input$dotsWidth, 
                                     size = input$dotSize, alpha = input$dotAlpha, 
                                     shape = as.numeric(input$dotShape))
      }
    }
  }
  
  
  
  
  # Violin Plots
  if (input$violinPlots) {
    if (input$violinType == "half") {
      plot <- plot + geom_flat_violin(position = position_nudge(x = input$violinNudge, 
                                                                y = 0), 
                                      adjust = input$violinAdjust, 
                                      alpha = input$violinAlpha, 
                                      trim = input$violinTrim, 
                                      scale = input$violinScale)
    } else {
      plot <- plot + geom_violin(position = position_nudge(x = input$violinNudge, 
                                                           y = 0), 
                                 adjust = input$violinAdjust, 
                                 alpha = input$violinAlpha, 
                                 trim = input$violinTrim, 
                                 scale = input$violinScale)
    }
  }
  # BoxPlots // doesn't work because of ggghost
  # if (input$boxplotOutliers) {
  #   outlierShape = 16
  # } else {
  #   outlierShape = NA
  # }
  if (input$boxPlots) {
    plot <- plot + geom_boxplot(aes(x = as.numeric(condition) + input$boxplotNudge, 
                                    y = value), 
                                notch = input$boxplotNotch, 
                                width = input$boxplotWidth, 
                                varwidth = input$boxplotBoxWidth, 
                                ## This will not look good in the code output
                                outlier.shape = ifelse(input$boxplotOutliers, 16, NA), 
                                alpha = input$boxplotAlpha, 
                                colour = "BLACK", 
                                show.legend = FALSE)
  }
  ## Plotting the mean
  if (input$statsMean) {
    ## Just the mean
    plot <- plot + stat_summary(fun.ymin = mean,
                                fun.ymax = mean,
                                geom = "errorbar",
                                width = input$statsMeanWidth,
                                position = position_nudge(x = input$statsMeanNudge,
                                                          y = 0),
                                size = input$statsMeanSize,
                                color = "black")
    if (input$statsMeanSEM) {
      ## Adding the SEM
      plot <- plot + stat_summary(fun.data = mean_se,
                                  geom = "errorbar",
                                  width = input$statsMeanWidth,
                                  position = position_nudge(x = input$statsMeanNudge,
                                                            y = 0),
                                  size = input$statsMeanSize,
                                  color = "black")
    }
    if(input$statsMeanCI) {
      ## What about mean_cl_boot? Could also work? Doesn't assume parametric.
      plot <- plot + stat_summary(fun.data = mean_ci,
                                  geom = "errorbar",
                                  width = input$statsMeanWidth,
                                  position = position_nudge(x = input$statsMeanNudge,
                                                            y = 0),
                                  size = input$statsMeanSize,
                                  color = "black")
    }
    if (input$statsMeanSD) {
      ## This is gonna be huge
      plot <- plot + stat_summary(fun.data = mean_sd,
                                  geom = "errorbar",
                                  width = input$statsMeanWidth,
                                  position = position_nudge(x = input$statsMeanNudge,
                                                            y = 0),
                                  size = input$statsMeanSize,
                                  color = "black")
    } 
  }
  
  ## We are not correcting for multiple comparisons in right now. Could probably
  ## do it. At least we should print a notice. Take a look at package rstatix 
  ## (https://github.com/kassambara/rstatix)
  
  if (input$statistics) {
    ## Significance
    if(input$statsType == 'parametric') {
      ## Parametric
      if(input$statsTtest && !is.null(input$statsCombinations)) {
        ## tTest
        ## The comparison method is 'peculiar', see server.R for info.
        plot <- plot + stat_compare_means(method = "t.test", 
                                          label = input$statsLabelFormat,
                                          comparisons = strsplit(input$statsCombinations, 'vs'))
      } 
      if (input$statsAnova) {
        ## ANOVA
        plot <- plot + stat_compare_means(method = "anova", 
                                          label.y = input$statsLabelY)
      }
    } else {
      ## Non Parametric
      if(input$statsWilcoxon && !is.null(input$statsCombinations)) {
        ## The comparison method is 'peculiar', see server.R for info.
        plot <- plot + stat_compare_means(method = 'wilcox.test',
                                          label = input$statsLabelFormat,
                                          comparisons = strsplit(input$statsCombinations, 'vs'))
        ## Wilcoxon
      } 
      if(input$statsKruskal) {
        ## Kruskal-Wallis
        plot <- plot + stat_compare_means(label.y = input$statsLabelY)
      }
    }
  }

  ## Theme - Hacky and long, but works for now 
  ## Could probably use (eval(text = input$plotTheme)) from list but XSS???
  
  if(input$plotTheme != "cowplot") {
    plot <- plot + eval(parse(text = input$plotTheme))
  }
  
  # if (input$plotTheme == "default") {
  #   plot <- plot + theme_grey()
  # } else if (input$plotTheme == "bw") {
  #   plot <- plot + theme_bw()
  # } else if (input$plotTheme == "linedraw") {
  #   plot <- plot + theme_linedraw()
  # } else if (input$plotTheme == "light") {
  #   plot <- plot + theme_light()
  # } else if (input$plotTheme == "dark") {
  #   plot <- plot + theme_dark()
  # } else if (input$plotTheme == "minimal") {
  #   plot <- plot + theme_minimal()
  # } else if (input$plotTheme == "classic") {
  #   plot <- plot + theme_classic()
  # } else if (input$plotTheme == "void") {
  #   plot <- plot + theme_void()
  # }
  
  if (input$plotMajorGrid == TRUE) {
    if (input$plotMinorGrid == TRUE) {
      plot <- plot + background_grid(major = "xy", minor = "xy")
    } else {
      plot <- plot + background_grid(major = "xy", minor = "none")
    }
  }
  if (input$plotLegend == FALSE) {
    plot <- plot + theme(legend.position = "none", 
                         plot.title = element_text(size = input$titleFontSize),
                         axis.title = element_text(size = input$axisFontSize))
  } else {
    plot <- plot + theme(plot.title = element_text(size = input$titleFontSize),
                         axis.title = element_text(size = input$axisFontSize))
  }
  if (input$autoScale == FALSE) {
    plot <- plot + ylim(input$minScale, input$maxScale)
  }
  if (input$plotFlip) {
    plot <- plot + coord_flip()
  }
  
  # if(input$ggrough) { options <- list(
  # Background=list(roughness=12),
  # GeomViolin=list(fill_style=input$ggroughFillStyle,
  # bowing=0, roughness=input$ggroughRoughness, fill_weight =
  # input$ggroughFillWeight, angle = input$ggroughFillWeight))
  # get_rough_chart(plot, options) } else { plot }
  
  return(list(plot = plot, 
              summary = summary(plot, combine = TRUE)))
}
