library("readr")
library("ggplot2")
library("dplyr")
# library(lavaan)
# library(smooth)
# library(Hmisc)
library("shiny")
# For hidden
# library("shinyjs")
library("tidyr")
library("tidyverse")
library("RColorBrewer")
library("cowplot")
library("ggsci")
library("ggghost")
library("ggpubr")
# Check if still needed
library("gsubfn")
library("glue")
# For the beeswarm dots
library("ggbeeswarm")


# packages <- c("cowplot", "readr", "ggplot2" , "dplyr", "lavaan", "smooth",
#               "Hmisc", "shiny", "tidyr", "tidyverse", "RColorBrewer",
#               "shinyWidgets")

# Check if packages are installed and/or install
# if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
#   install.packages(setdiff(packages, rownames(installed.packages())))
# }

# Load the packages
# lapply(packages, library, character.only = TRUE)
# rm(packages)

# GGROUGH, not ready yet
# if (!require("ggrough")) {
#   devtools::install_github("xvrdm/ggrough")
# }
#
# library('ggrough')