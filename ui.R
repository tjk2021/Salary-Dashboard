# # Author: Tanushree Koshti
# # Project: Salary Dashboard
# # Date: February 19, 2024

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
      menuItem("About", tabName = "about"),
      menuItem("Data Table", tabName = "tab1"),
      menuItem("Bar Plot", tabName = "tab2"),
      menuItem("Histogram", tabName = "tab3"),
      menuItem("Scatter Plot", tabName = "tab4"),
      menuItem("Bubble Charts", tabName = "tab5")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "about",
              fluidRow(
                column(width = 12, uiOutput("summary_col1")) # Full-width column
              )
      ),
      tabItem(tabName = "tab1",
              h4("Data Table"),
              fluidRow(
                column(width = 12, withSpinner(DTOutput("data_table"))) # Full-width column
              )
      ),
      tabItem(tabName = "tab2",
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
                    tabItem(tabName = "tab3",
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
                    tabItem(tabName = "tab4",
                            h4("Scatter Plot"),
                            #verbatimTextOutput("data_table")
                            fluidPage(
                              #withSpinner(plotlyOutput("bubble_chart_male"))
                              column(width = 6, withSpinner(plotlyOutput("scatter_plot"))),
                              column(width = 6, withSpinner(plotlyOutput("scatter_plot2")))
                            )
                    ),
                    tabItem(tabName = "tab5",
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

