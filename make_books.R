
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
quarto::quarto_render("WorkingInR")

# quarto markdown
quarto::quarto_render("quarto")
{
quarto::quarto_render(input = "quarto/demo_presentation.qmd", output_file = "demo_presentation.html")
fs::dir_copy("quarto/demo_presentation_files/", "docs/quarto/demo_presentation_files/")
fs::dir_delete("quarto/demo_presentation_files/") 
fs::file_copy("demo_presentation.html", "docs/quarto/demo_presentation.html")
fs::file_delete("demo_presentation.html") 
}

# targets
quarto::quarto_render("targets")


# Statistics in R
quarto::quarto_render("StatisticsInR")


# Data collection
quarto::quarto_render("DataCollection")
