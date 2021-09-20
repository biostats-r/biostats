
# Git and GitHub
withr::with_dir("DataManagement/", {
  bookdown::render_book('index.Rmd', 'bookdown::bs4_book',  output_dir = "../docs/github")
})


# R markdown
withr::with_dir("Rmarkdown/", {
  rmarkdown::render("formatting.Rmd", output_format = "pdf_document")
  bookdown::render_book('index.Rmd', 'bookdown::bs4_book',  output_dir = "../docs/rmarkdown")
})

# R packages
withr::with_dir("writing_a_package/", {
  bookdown::render_book('index.Rmd', 'bookdown::bs4_book', output_dir = "../docs/package")
})

#working in R

withr::with_dir("WorkingInR/", {
  bookdown::render_book('index.Rmd', 'bookdown::bs4_book', output_dir = "../docs/workingInR")
})


