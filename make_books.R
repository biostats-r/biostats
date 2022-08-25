library(tidyverse)

bioceed_links <- function(dir, front_page = FALSE, quarto = FALSE){
  files <- list.files(dir, pattern = "html$", full.names = TRUE, recursive = !front_page)
  print(files)
  map(files, ~{
    f <- readLines(.x)
    if(isTRUE(quarto)){
      p1 <- grep(
        pattern = '<div id="quarto-margin-sidebar" class="sidebar margin-sidebar">',
        x = f)
      p2 <- grep(
        pattern= '<nav id="TOC" role="doc-toc">',
        x = f)
    }
    else {
      p1 <- grep(
        pattern = '</div></main><div class="col-md-3 col-lg-2 d-none d-md-block sidebar sidebar-chapter">',
        x = f)
      p2 <- grep(
        pattern= '<nav id="toc" data-toggle="toc" aria-label="On this page"><h2>On this page</h2>',
        x = f)
    }
    if (length(p1) == 1 & length(p2) == 1) {
      if (p2 - p1 == 1) {
        f <- c(f[1:p1], 
               '<style>
               img.site-logo {
  height: auto;
  width: 95%;
}
      </style>',
               '<p><a  href="https://biostats.w.uib.no/" aria-label="bioST@TS | When biology adds up, at last&#8230;"><img class="site-logo" src="https://biostats.w.uib.no/files/2020/01/biostats-button-res2.png" alt="BioST@TS homepage" width="250" height="101"  data-no-retina class=" attachment-11864" title = "BioST@TS homepage"/></a>  ',
               ifelse(isFALSE(front_page), '<br><a  href="../index.html" aria-label="bioST@TS | When biology adds up, at last&#8230;"><img class="site-logo" src="../figures/icons_all.png" alt= "BioST@TS books" width="250" height="101"  data-no-retina class=" attachment-11864", title = "BioST@TS books"/></a>   </p>', ' </p>'), 
               f[p2:length(f)])
      }  
    }
    writeLines(f, con = .x)
  })
  invisible()
}

# Front page
quarto::quarto_render("frontpage")
bioceed_links("docs/", front_page = TRUE, quarto = TRUE)

# Git and GitHub
quarto::quarto_render("DataManagement", quarto = TRUE)
bioceed_links("docs/github", quarto = TRUE)


# R markdown
withr::with_dir("Rmarkdown/", {
  rmarkdown::render("formatting.Rmd", output_format = "pdf_document")
  bookdown::render_book('index.Rmd', 'bookdown::bs4_book',  output_dir = "../docs/rmarkdown")
  bioceed_links("../docs/rmarkdown")
})

# R packages
quarto::quarto_render("writing_a_package")
bioceed_links("docs/package", quarto = TRUE)

# working in R
quarto::quarto_render("WorkingInR")
bioceed_links("docs/workingInR", quarto = TRUE)

# quarto markdown
quarto::quarto_render("quarto")
bioceed_links("docs/quarto", quarto = TRUE)
{
quarto::quarto_render(input = "quarto/demo_presentation.qmd", output_file = "docs/quarto/demo_presentation.html")
fs::dir_copy("quarto/demo_presentation_files/", "docs/quarto/demo_presentation_files/")
fs::dir_delete("quarto/demo_presentation_files/") 
}


# Statistics in R
quarto::quarto_render("StatisticsInR")
bioceed_links("docs/statisticsInR", quarto = TRUE)