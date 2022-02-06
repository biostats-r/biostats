bioceed_links <- function(dir){
  files <- list.files(dir, pattern = "html", full.names = TRUE, recursive = TRUE)
  map(files, ~{
    #browser()
    f <- readLines(.x)
    p1 <- grep(pattern = '</div></main><div class="col-md-3 col-lg-2 d-none d-md-block sidebar sidebar-chapter">', x = f)
    p2 <- grep(pattern= '<nav id="toc" data-toggle="toc" aria-label="On this page"><h2>On this page</h2>', x = f)
    print(.x)
    if (length(p1) == 1 & length(p2) == 1) {
      if (p2 - p1 == 1) {
        f <- c(f[1:p1], 
               '<p><a href = "https://biostats.w.uib.no/">Biost@ts Homepage</a></p>',
               '<p><a href = "https://biostats-r.github.io/biostats/">All BioCeed Biost@ts  Books</a></p>', 
               f[p2:length(f)])
      }  
    }
    writeLines(f, con = .x)
  })
  invisible()
}

# Front page
bookdown::render_book('index.Rmd', 'bookdown::bs4_book',  output_dir = "docs")

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
  bioceed_links("../docs/workingInR")
})


