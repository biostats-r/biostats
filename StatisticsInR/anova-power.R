library(shiny)
library(tidyverse)
library(broom)
source("../Templates/biostats_theme.R")
theme_set(theme_bw())


ui <-  fluidPage(
  # Application title
  titlePanel("Simulating an ANOVA"),
  
  sidebarLayout(
    # Sidebar with a slider input
    sidebarPanel(
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

server <- function(input, output) {
  
  output$samp_size <- renderText(glue::glue("Sample of {input$n} observations for each treatment"))
    
  output$pop_plot <- renderPlot({
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
    
    pop_plot
  })
  
  mods <- reactive({
    message("reactive called")
    sims <- rerun(100, tibble(treatment = rep(c("control", "treat"), each = input$n),
                      value = rnorm(n = input$n * 2, 
                                    mean = rep(c(0, input$delta), each = input$n), 
                                    sd = input$sd)
                      ))
  
  
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
      x = "Estimated difference in means",
      fill = glue::glue("p < {input$p}"))
})
 
 output$uncertainty_plot <- renderPlot({
   ggplot(mods()$result, aes(x = estimate, xmin =  estimate - 1.96 * std.error, xmax = estimate + 1.96 * std.error, y = n)) + 
     geom_errorbarh() +
     geom_point() +
     geom_vline(xintercept = input$delta) +
     geom_vline(xintercept = 0, linetype = "dashed") +
     labs(x = "Estimated difference in means")
 })
 
 output$sample_plot <- renderPlot({
   ggplot(mods()$sample, aes(x = treatment, y = value)) + 
     geom_boxplot(aes(fill = treatment), alpha = 0.3, outlier.shape = NA) + 
     geom_jitter(aes(colour = treatment), height = 0) +
 #    stat_summary(fun.data = "mean_sd") +
     # geom_vline(xintercept = input$delta) +
     # geom_vline(xintercept = 0, linetype = "dashed") +
     labs(x = "Treatment") +
     theme(legend.position = "none")
 })
 
  output
}
  
shinyApp(ui, server)
