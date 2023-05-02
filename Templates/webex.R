suppressPackageStartupMessages({
  library(webexercises)
})

knitr::knit_hooks$set(webex.hide = function(before, options, envir) {
  if (before) {
    if (is.character(options$webex.hide)) {
      hide(options$webex.hide)
    } else {
      hide()
    }
  } else {
    unhide()
  }
})


print_multichoice <- function(questions) {
  for(i in seq_along(questions)){
    cat("#### Question", paste0(i, ":"), questions[[i]]$question, "{.unlisted .unnumbered}\n\n")
    cat(longmcq(questions[[i]]$choice))
    if (!is.null(questions[[i]]$hint)) {
      cat(hide("hint"))
      cat(questions[[i]]$hint)
      cat(unhide())
    }
    if (!is.null(questions[[i]]$explanation)) {
      cat(hide("explanation"))
      cat(questions[[i]]$explanation)
      cat(unhide())
    }
  }
}
