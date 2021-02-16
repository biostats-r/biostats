library(shiny)
library(tidyverse)
library(broom)
source("../Templates/biostats_theme.R")
theme_set(theme_bw())


ui <-  fluidPage(
  # Application title
  titlePanel("Simulating linear regressions"),
  
  sidebarLayout(
   
    # Sidebar with a slider input
    sidebarPanel(
      radioButtons("type", label = "Type of predictor variable", choices = c("Categorical", "Continuous"), selected = "Categorical"),
      sliderInput(
        "n",
        "Number of observations:",
        min = 2,
        max = 100,
        value = 10,
        step = 1
      ),
      sliderInput(
        "delta",
        "True difference in means:",
        min = 0,
        max = 10,
        value = 5
      ),
      sliderInput(
        "sd",
        "Standard deviation of each group:",
        min = 0,
        max = 10,
        value = 5
      ),
      sliderInput(
        "p",
        "p level:",
        min = 0,
        max = 1,
        value = 0.05, 
        step = 0.01
      )
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
      h4("Population distributions"),
      plotOutput("pop_plot"),
      h4(textOutput("samp_size")),
      plotOutput("sample_plot"),
      h4("Confidence intervals on 100 trials"),
      plotOutput("uncertainty_plot"),
      h4("Effect size of 100 trials"),
      plotOutput("effect_plot"),
      h4("P-values of 100 trials"),
      plotOutput("p_plot")
    )
  ))

#### Server ####
server <- function(input, output) {
  max_continuous <- 2
  
  output$samp_size <- renderText({
    if (input$type == "Categorical") {
      glue::glue("Sample of {input$n} observations for each treatment")
    } else {
      glue::glue("Sample of {input$n} observations") 
    }
  })
    
  output$pop_plot <- renderPlot({
    
    if (input$type == "Categorical") {
      upper <- max(0, input$delta) + input$sd * 3
      lower <- min(0, input$delta) - input$sd * 3
      
      dist <- bind_rows(
        control = tibble(
          x = seq(lower, upper, length.out = 101),
          y = dnorm(x, mean = 0, sd = input$sd)
        ),
        treatment = tibble(
          x = seq(lower, upper, length.out = 101),
          y = dnorm(x, mean = input$delta, sd = input$sd)
        ),
        .id = "treatment"
      )
      
      pop_plot <- ggplot(data = dist, aes(x = x, y = y, fill = treatment)) +
        geom_area(alpha = 0.3, position = "identity") +
        geom_vline(mapping = aes(xintercept = x, colour = treatment), data = tibble(x = c(0, input$delta), treatment = c("control", "treat")), show.legend = FALSE) +
        labs(x = "Value", y = "Density", fill = "Treatment") 
    } else {
      
      dist <- tibble(x = seq(0, max_continuous, length.out = 50),
                     value = x * input$delta) 
      
      pop_plot <- ggplot(data = dist, aes(x = x, y = value)) +
        geom_ribbon(aes(ymin = value - 2 * input$sd, ymax = value + 2 * input$sd), alpha = 0.3) +
        geom_ribbon(aes(ymin = value - input$sd, ymax = value + input$sd), alpha = 0.3) +
        geom_line() +
        labs(x = "Predictor", y = "Response") 
    }
    pop_plot
  })
  
  
  #simulate data
  mods <- reactive({
    if (input$type == "Categorical") {
      sims <- rerun(100, tibble(treatment = rep(c("control", "treat"), each = input$n),
                                value = rnorm(n = input$n * 2, 
                                              mean = rep(c(0, input$delta), each = input$n), 
                                              sd = input$sd)
      ))
    } else { #simulate continuous data
      sims <- rerun(100, tibble(treatment = runif(input$n, 0, max_continuous),
                                value = treatment * input$delta + 
                                  rnorm(n = input$n, mean = 0, sd = input$sd)
      ))
    }

  
  
  list(
    result = map(sims, ~lm(formula = value ~ treatment, data = .x)) %>% 
    map_dfr(tidy) %>% 
    filter(term != "(Intercept)") %>%
    arrange(estimate) %>% 
    mutate(n = row_number()),
    sample = sims[[1]]
  )
  
  })
  
  output$p_plot <- renderPlot({
    ggplot(mods()$result, aes(x = p.value, fill = p.value < input$p)) + 
      geom_histogram(boundary = 0, bins = 100) +
      xlim(0, 1) +
      geom_vline(xintercept = input$p, colour = "red", linetype = "dashed") +
      labs(x = "P value", fill = glue::glue("p < {input$p}"))
  })
  
 output$effect_plot <- renderPlot({
  ggplot(mods()$result, aes(x = estimate, fill = p.value < input$p)) + 
    geom_histogram(bins = 25) +
    geom_vline(xintercept = input$delta) +
    labs(
      x = if_else(input$type == "Categorical", "Estimated difference in means", "Estimated slope"),
      fill = glue::glue("p < {input$p}"))
})
 
 output$uncertainty_plot <- renderPlot({
   ggplot(mods()$result, aes(x = estimate, xmin =  estimate - 1.96 * std.error, xmax = estimate + 1.96 * std.error, y = n)) + 
     geom_errorbarh() +
     geom_point() +
     geom_vline(xintercept = input$delta) +
     geom_vline(xintercept = 0, linetype = "dashed") +
     labs(x = if_else(input$type == "Categorical", "Estimated difference in means", "Estimated slope"), 
          y = "Simulation number")
 })
 
 output$sample_plot <- renderPlot({
     if (input$type == "Categorical") {
       ggplot(mods()$sample, aes(x = treatment, y = value)) + 
         geom_boxplot(aes(fill = treatment), alpha = 0.3, outlier.shape = NA) + 
         geom_jitter(aes(colour = treatment), height = 0) +
         #    stat_summary(fun.data = "mean_sd") +
         # geom_vline(xintercept = input$delta) +
         # geom_vline(xintercept = 0, linetype = "dashed") +
         labs(x = "Treatment", y = "Response") +
         theme(legend.position = "none")
     } else {
       ggplot(mods()$sample, aes(x = treatment, y = value)) + 
         geom_point() +
         geom_smooth(method = "lm", formula = y ~ x) +
         labs(x = "Predictor", y = "Response")
     }
 })
 
  output
}
  
shinyApp(ui, server)
