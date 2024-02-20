# server.R 
library(shiny)
library(tidyr)

# Importing the dataset
salary_data <- read.csv("salary.csv")
#head(salary_data)

# Converting data into long format
long_data <- gather(salary_data, key = "variable", value = "value", -c(Age, Gender, `Education.Level`, `Job.Title`, `Years.of.Experience`, Salary, Country, Race, Senior))

# Define server logic
shinyServer(function(input, output) {
  
  # Reactive expression to subset the first 10 rows of the dataset
  data_subset <- reactive({
    head(long_data, 10)
  })
  
  # Render the data table
  output$data_table <- renderTable({
    data_subset()
  })
})
