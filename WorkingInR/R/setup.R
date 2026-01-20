library("tidyverse")

source("../Templates/biostats_theme.R")
options(tibble.print_min = 3)
options(max.print = 25) # max elements to print  - affects data.frames

# make penguins into a tibble to improve printing
penguins <- as_tibble(penguins)