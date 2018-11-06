# Raincloud-shiny

Raincloud-shiny is a shiny app for creating and customizing RainCloudPlots. A demo is hosted [here](https://gabrifc.shinyapps.io/raincloudplots/). The idea behind Raincloud plots was introduced by [Micah Allen on his blog](https://micahallen.org/2018/03/15/introducing-raincloud-plots/). My coworkers and I found it really interesting to display our data but they did not have any R experience, so I made this shiny app to provide a smooth transition to R and ggplot.

![Raincloud plots shiny app](https://raw.githubusercontent.com/gabrifc/raincloud-shiny/master/rainCloudPlots.PNG)

## Citing RainCloudPlots
Please refer to the [original RainCloudPlots source](https://github.com/RainCloudPlots/RainCloudPlots#citing-raincloudplots) for citations and licenses.

TL;DR: Until the final manuscript is published, cite the original preprint ([here](https://peerj.com/preprints/27137v1/)).

## Credits

The code of RainCloud-Shiny makes use / is inspired by the following open source projects:
<ul>
	<li><a href="https://github.com/RainCloudPlots/RainCloudPlots">RainCloudPlots</a>: The original code provided by the manuscript authors.</li>
	<li><a href="https://shiny.rstudio.com/">RShiny</a>: Shiny is an R package that makes it easy to build interactive web apps straight from R.</li>
	<li><a href="https://dreamrs.github.io/shinyWidgets/index.html">shinyWidgets</a>: An extension of the default widgets available in Shiny.</li>
	<li><a href="https://www.tidyverse.org/">Tidyverse</a>: An opinionated collection of R packages designed for data science. This app makes use of the following packages to wrangle and display data:
		<ul>
			<li><a href="https://tidyr.tidyverse.org/">Tidyr</a>.</li>
			<li><a href="https://glue.tidyverse.org">Glue</a>.</li>
			<li><a href="https://stringr.tidyverse.org">Stringr</a>.</li>
			<li><a href="https://ggplot2.tidyverse.org/">ggplot2</a>.</li>
		</ul>
	</li>
	<li><a href="https://gist.github.com/dgrtwo/eb7750e74997891d7c20">geom_flat_violin.R</a>: a ggplot2 extension to make one side flat violins.</li>
	<li><a href="https://github.com/wilkelab/cowplot">Cowplot</a>: Create publication-ready figures.</li>
	<li><a href="https://cran.r-project.org/web/packages/RColorBrewer/index.html">RColorBrewer</a>: Provides Color Theme Palettes designed by Cynthia Brewer as described at <a href="http://colorbrewer2.org">Colorbrewer 2.0.</a></li>
	<li><a href="https://nanx.me/ggsci/">ggsci</a>: Scientific Journal and Sci-Fi Themed Color Palettes for ggplot2</li>
	<li><a href="http://www.sthda.com/english/rpkgs/ggpubr/">ggpubr</a>: Makes it possible to automatically add p-values and significance levels.</li>
	<li><a href="https://github.com/eclarke/ggbeeswarm">ggbeeswarm</a>: Provides methods to create beeswarm-style plots using ggplot2.</li>
	<li><a href="http://biostat.mc.vanderbilt.edu/wiki/Main/Hmisc">Hmisc</a>: Miscellaneous utilities from Frank Harrell. Here used to calculate the 95% Confidence Intervals.</li>
</ul>
