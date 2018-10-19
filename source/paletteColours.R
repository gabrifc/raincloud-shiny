## Adding RColorBrewer here also becaus 'brewer.pal.info' is required to load
## the UI at this moment. Same thing with ggsci
library("ggsci")
library("RColorBrewer")

# For the palette UI
library("shinyWidgets")

# Prepare the palette picker
colors_pal <- lapply(
  X = split(
    x = brewer.pal.info,
    f = factor(brewer.pal.info$category, 
               labels = c("Diverging", "Qualitative", "Sequential"))
  ),
  FUN = rownames
)

# GSEA doesn't work right now.

colors_pal$Scientific <- c('NPG', 'AAAS', 'NEJM','Lancet', 'JAMA', 'JCO',
                           'UCSCGB', 'LocusZoom', 'IGV', 'UChicago', 
                           'UChicago Light', 'UChicago Dark', 'Star Trek',
                           'Tron Legacy', 'Futurama', 'Rick and Morty', 
                           'The Simpsons')

# Get all colors given a palette name(s)
get_brewer_name <- function(name) {
  pals <- brewer.pal.info[rownames(brewer.pal.info) %in% name, ]
  res <- lapply(
    X = seq_len(nrow(pals)),
    FUN = function(i) {
      brewer.pal(n = pals$maxcolors[i], name = rownames(pals)[i])
    }
  )
  unlist(res)
}

background_pals <- sapply(unlist(colors_pal, use.names = FALSE), 
                          get_brewer_name)
background_pals$NPG <- pal_npg()(10)
background_pals$AAAS <- pal_aaas()(10)
background_pals$NEJM <- pal_nejm()(8)
background_pals$Lancet <- pal_lancet()(9)
background_pals$JAMA <- pal_jama()(7)
background_pals$JCO <- pal_jco()(10)
background_pals$UCSCGB <- pal_ucscgb()(10)
background_pals$LocusZoom <- pal_locuszoom()(7)
background_pals$IGV <- pal_igv()(10)
background_pals$UChicago <- pal_uchicago()(9)
background_pals$`UChicago Light` <- pal_uchicago("light")(9)
background_pals$`UChicago Dark` <- pal_uchicago("dark")(9)
background_pals$`Star Trek` <- pal_startrek()(7)
background_pals$`Tron Legacy` <- pal_tron()(7)
background_pals$Futurama <- pal_futurama()(12)
background_pals$`Rick and Morty` <- pal_rickandmorty()(12)
background_pals$`The Simpsons` <- pal_simpsons()(16)
#background_pals$GSEA <- pal_gsea()(12)


# Calc linear gradient for CSS
linear_gradient <- function(cols) {
  x <- round(seq(from = 0, to = 100, length.out = length(cols)+1))
  ind <- c(1, rep(seq_along(x)[-c(1, length(x))], each = 2), length(x))
  m <- matrix(data = paste0(x[ind], "%"), ncol = 2, byrow = TRUE)
  res <- lapply(
    X = seq_len(nrow(m)),
    FUN = function(i) {
      paste(paste(cols[i], m[i, 1]), paste(cols[i], m[i, 2]), sep = ", ")
    }
  )
  res <- unlist(res)
  res <- paste(res, collapse = ", ")
  paste0("linear-gradient(to right, ", res, ");")
}

background_pals <- unlist(lapply(X = background_pals, FUN = linear_gradient))

colortext_pals <- rep(c("white", "black", "black", "black"), 
                      times = sapply(colors_pal, length))