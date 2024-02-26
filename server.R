# Author: Tanushree Koshti
# Project: Salary Dashboard
# Date: February 19, 2024

# server.R 
library(shiny)
library(tidyr)
library(ggplot2) # For visualization

# Importing the dataset
salary_data <- read.csv("salary.csv")
#head(salary_data)

# Converting data into long format
long_data <- gather(salary_data, key = "variable", value = "value", -c(Age, Gender, `Education.Level`, `Job.Title`, `Years.of.Experience`, Salary, Country, Race, Senior))

# Define server logic
shinyServer(function(input, output) {
  
  # Reactive expression to subset the first 10 rows of the dataset
  data_subset <- reactive({
    head(long_data, 5)
  })
  
  # Render the data table
  output$data_table <- renderTable({
    data_subset()
  })
  
  # Render a simple bar plot for demonstration
  output$bar_plot <- renderPlot({
    # Calculate average salary by gender
    average_salary <- aggregate(Salary ~ Gender, data = long_data, FUN = mean)
    
    # Create the bar plot
    ggplot(average_salary, aes(x = Gender, y = Salary)) + 
      geom_bar(stat = "identity", fill = "skyblue") +
      labs(title = "Average Salary by Gender", x = "Gender", y = "Average Salary")
  })
  
})
