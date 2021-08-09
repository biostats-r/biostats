
# Git and GitHub
withr::with_dir("DataManagement/", {
  bookdown::render_book('index.Rmd', 'bookdown::bs4_book')
})
