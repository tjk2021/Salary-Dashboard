# ui.R
library(shiny)

shinyUI(fluidPage(
  
  # Author name
  h3("Author: Tanushree"),
  
  # Title
  h1("Salary Dashboard"),
  
  # Date
  h4("Date: February 19, 2024"),
  
  # Table output for displaying data
  tableOutput("data_table")
))
