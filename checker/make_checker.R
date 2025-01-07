# load packages
library(checker)
library(tidyverse)
library(here)

chk_dir <- "checker"

# basic check
pak <- read.csv(
  text = 'package, recommended, minimum, message
        tidyverse, 2.0.0, NA, "install tidyverse with install.packages(\"tidyverse\")"
        palmerpenguins, NA, NA, NA
        remotes, NA, NA, NA',
  strip.white = TRUE
)

prog <- read.csv(
  text = 'program, recommended, minimum, message
             rstudio, 2023.3.0.386, 2022.12.0.353, NA
             R, "4.3.0", "4.2.1", NA',
  strip.white = TRUE
)
opt <- read.csv(
  text = 'option, value, message
             "save_workspace", "never", NA
             "load_workspace", "FALSE", "For reproducibility"',
  strip.white = TRUE
)


chk_make(
  path = here(chk_dir, "basic.yaml"),
  programs = prog,
  packages = pak,
  options = opt
)
chk_requirements(here(chk_dir, "basic.yaml"))

# map check

# quarto check
pak_quarto <- pak |>
  add_row(package = "quarto", recommended = "1.2")
prog_quarto <- prog |>
  add_row(program = "quarto", recommended = "1.3.2")


chk_make(
  path = here(chk_dir, "quarto.yaml"),
  programs = prog_quarto,
  packages = pak_quarto,
  options = opt
)
chk_requirements(here(chk_dir, "quarto.yaml"))
