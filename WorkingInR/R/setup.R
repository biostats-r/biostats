knitr::opts_chunk$set(echo = TRUE, warning = FALSE, error = TRUE)
library("tidyverse")

data(penguins, package = 'palmerpenguins')

source("../Templates/biostats_theme.R")
options(tibble.print_min = 3)