# Author: Tanushree Koshti
# Project: Salary Dashboard
# Date: February 19, 2024

library(shiny)
library(plotly)
library(DT)
library(shinycssloaders)

# Importing the dataset
salary_data <- read.csv("salary.csv")

# Define UI
navbarPage(  
  "Salary Dashboard",
  tabPanel(
    "Summary",
    fluidPage(
      withSpinner(DTOutput("summary"))
    )
  ),
  tabPanel(
    "The Data",
    fluidPage(
      withSpinner(DTOutput("data_table"))
    )
  ),
  tabPanel("Bar Graph", 
           sidebarLayout(
             sidebarPanel(
               selectInput("country", "Select Country:",
                           choices = unique(salary_data$Country))
             ),
             mainPanel(
               withSpinner(plotOutput("bar_plot")),
               textOutput("bar_summary")  # Add text output for summary
             )
           )
  ),
  tabPanel(
    "Histogram",
    sidebarLayout(
      sidebarPanel(
        selectInput("gender", "Select Gender:", choices = c("Male", "Female"), selected = "Male")
      ),
      mainPanel(
        withSpinner(plotOutput("histogram_plot")),
        textOutput("historgram_summary")  # Add text output for summary
      )
    )
  ),
  
collapsible = TRUE,
)

