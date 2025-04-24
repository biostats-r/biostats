# copy assets
fs::dir_create("docs/figures")
fs::file_copy("figures/icons_all.png", "docs/figures/icons_all.png")
fs::file_copy("figures/favicon.png", "docs/figures/favicon.png")

# Front page
quarto::quarto_render("frontpage")


# Git and GitHub
quarto::quarto_render("DataManagement")


# # R markdown superseded by quarto book

# withr::with_dir("Rmarkdown/", {
#   bookdown::render_book('index.Rmd', 'bookdown::bs4_book',  output_dir = "../docs/rmarkdown")
#   bioceed_links("../docs/rmarkdown")
# })

# R packages
quarto::quarto_render("writing_a_package")

# working in R
fs::file_delete(list.files(here::here("docs/workingInR/"), recursive = TRUE, full.names = TRUE))
quarto::quarto_render("WorkingInR")

# quarto markdown
quarto::quarto_render("quarto")
{
  quarto::quarto_render(input = "quarto/demo_presentation.qmd", output_file = "demo_presentation.html")
  fs::dir_copy("quarto/demo_presentation_files/", "docs/quarto/demo_presentation_files/", overwrite = TRUE)
  fs::dir_delete("quarto/demo_presentation_files/")
  fs::file_copy("demo_presentation.html", "docs/quarto/demo_presentation.html", overwrite = TRUE)
  fs::file_delete("demo_presentation.html")
}

# targets
quarto::quarto_render("targets")


# Statistics in R
quarto::quarto_render("StatisticsInR")


# data lifecycle
quarto::quarto_render("data_lifecycle")
