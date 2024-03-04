# Author: Tanushree Koshti
# Project: Salary Dashboard
# Date: February 19, 2024

# # UI code
# ui <- fluidPage(
#   titlePanel("Salary Dashboard"),
#   
#   # Data table output
#   mainPanel(
#     tabsetPanel(
#       tabPanel("Data Table", tableOutput("data_table")),
#       tabPanel("Bar Plot", 
#                selectInput(inputId = "country", label = "Select Country", choices = c("All", "UK", "USA", "Canada", "China", "Australia")),
#                plotOutput("bar_plot")),  
#       tabPanel("Bubble Chart", plotOutput("bubble_chart"))  
#     )
#   )
# )

library(shiny)
library(plotly)
library(DT)
library(shinycssloaders)

# Importing the dataset
salary_data <- read.csv("salary.csv")

# Define UI
# ui <- fluidPage(
#   titlePanel("Salary Dashboard"),
#   tabsetPanel(
#     tabPanel("Bar Plot", 
#              sidebarLayout(
#                sidebarPanel(
#                  selectInput("country", "Select Country:",
#                              choices = unique(salary_data$Country))
#                ),
#                mainPanel(
#                  plotOutput("bar_plot"),
#                  textOutput("bar_summary")  # Add text output for summary
#                )
#              )
#     ),
#     tabPanel("Other Visualization", 
#              # Add your other visualization or summary here
#              plotOutput("other_plot")
#     )
#   )
# )

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

