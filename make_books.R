
# Git and GitHub
withr::with_dir("DataManagement/", {
  bookdown::render_book('index.Rmd', 'bookdown::bs4_book')
})


# R markdown
withr::with_dir("Rmarkdown/", {
  bookdown::render_book('index.Rmd', 'bookdown::bs4_book')
})

# R packages
withr::with_dir("writing_a_package/", {
  bookdown::render_book('index.Rmd', 'bookdown::bs4_book')
})

#working in R

withr::with_dir("WorkingInR/", {
  bookdown::render_book('index.Rmd', 'bookdown::bs4_book')
})