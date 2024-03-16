# Author: Tanushree Koshti
# Project: Salary Dashboard
# Date: February 19, 2024

library(shiny)
library(shinydashboard)
library(plotly)
library(DT)
library(shinycssloaders)

# Importing the dataset
salary_data <- read.csv("salary.csv")

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Salary Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "tab1"),
      menuItem("Data Table", tabName = "tab2"),
      menuItem("Bar Plot", tabName = "tab3"),
      menuItem("Histogram", tabName = "tab4"),
      menuItem("Scatter Plot", tabName = "tab5"),
      menuItem("Bubble Charts", tabName = "tab6")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab1",
              h4("About"),
              verbatimTextOutput("tab1_output")
      ),
      tabItem(tabName = "tab2",
              h4("Data Table"),
              #verbatimTextOutput("data_table")
              fluidPage(
                withSpinner(DTOutput("data_table"))
              )
      ),
      tabItem(tabName = "tab3",
              h4("Bar Plot"),
              sidebarLayout(
                sidebarPanel(
                  selectInput("country", "Select Country:",
                              choices = unique(salary_data$Country))
                ),
                mainPanel(
                  withSpinner(plotlyOutput("bar_plot")),
                  textOutput("bar_summary")  # Add text output for summary
                )
              )
      ),
      tabItem(tabName = "tab4",
              h4("Histogram"),
              sidebarLayout(
                sidebarPanel(
                  selectInput("gender", "Select Gender:", choices = c("Male", "Female"), selected = "Male")
                ),
                mainPanel(
                  withSpinner(plotlyOutput("histogram_plot")),
                  textOutput("historgram_summary")  # Add text output for summary
                )
              )
      ),
      tabItem(tabName = "tab5",
              h4("Scatter Plot"),
              #verbatimTextOutput("data_table")
              fluidPage(
                #withSpinner(plotlyOutput("bubble_chart_male"))
                column(width = 6, withSpinner(plotlyOutput("scatter_plot"))),
                column(width = 6, withSpinner(plotlyOutput("scatter_plot2")))
              )
      ),
      tabItem(tabName = "tab6",
              h4("Bubble Charts"),
              #verbatimTextOutput("data_table")
              fluidPage(
                #withSpinner(plotlyOutput("bubble_chart_male"))
                column(width = 6, withSpinner(plotlyOutput("bubble_chart_male"))),
                column(width = 6, withSpinner(plotlyOutput("bubble_chart_female")))
              )
      )
    )
  )
)
