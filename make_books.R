copy_delete <- function(output, docs) {
  if(missing(docs)) {
    docs <- output
  }
  fs::dir_copy(
    file.path(output, "output"), 
    file.path("docs", docs), 
    overwrite = TRUE
  )
  fs::dir_delete(file.path(output, "output"))
}


# copy assets
fs::dir_create("docs/figures")
fs::file_copy("figures/icons_all.png", "docs/figures/icons_all.png")
fs::file_copy("figures/favicon.png", "docs/figures/favicon.png")

# Front page
quarto::quarto_render("frontpage")
copy_delete("frontpage", "")

# Git and GitHub
quarto::quarto_render("DataManagement")
copy_delete("DataManagement", "github")



# # R markdown superseded by quarto book

# withr::with_dir("Rmarkdown/", {
#   bookdown::render_book('index.Rmd', 'bookdown::bs4_book',  output_dir = "../docs/rmarkdown")
#   bioceed_links("../docs/rmarkdown")
# })

# R packages
quarto::quarto_render("writing_a_package")
copy_delete("writing_a_package", "package")


# working in R
fs::file_delete(list.files(here::here("docs/workingInR/"), recursive = TRUE, full.names = TRUE))
quarto::quarto_render("WorkingInR")
copy_delete("WorkingInR", "workingInR")


# quarto markdown
fs::file_delete(list.files(here::here("docs/quarto/"), recursive = TRUE, full.names = TRUE))
quarto::quarto_render("quarto")
copy_delete("quarto", "quarto")
{
  quarto::quarto_render(input = "quarto/demo_presentation.qmd", output_file = "demo_presentation.html")
  fs::dir_copy("quarto/demo_presentation_files/", "docs/quarto/demo_presentation_files/", overwrite = TRUE)
  fs::dir_delete("quarto/demo_presentation_files/")
  fs::file_copy("demo_presentation.html", "docs/quarto/demo_presentation.html", overwrite = TRUE)
  fs::file_delete("demo_presentation.html")
}

# targets
quarto::quarto_render("targets")
copy_delete("targets", "targets")


# Statistics in R
quarto::quarto_render("StatisticsInR")
copy_delete("StatisticsInR", "statisticsInR")


# data lifecycle
fs::file_delete(list.files(here::here("docs/data_lifecycle/"), recursive = TRUE, full.names = TRUE))
quarto::quarto_render("data_lifecycle")
copy_delete("data_lifecycle", "data_lifecycle")
