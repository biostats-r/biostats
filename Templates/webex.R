library(webexercises)

print_multichoice <- function(questions) {
  for (i in seq_along(questions)) {
    cat("**Question", paste0(i, ":"), questions[[i]]$question, "**\n\n")
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
