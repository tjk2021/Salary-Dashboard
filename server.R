# Author: Tanushree Koshti
# Project: Salary Dashboard
# Date: February 19, 2024

# server.R 
library(shiny)
library(tidyr)
library(ggplot2) # For visualization
library(plotly)
library(dplyr)   # For data manipulation


# Define server logic
shinyServer(function(input, output) {
  
  # Importing the dataset
  salary_data <- read.csv("salary.csv")
  
  # Reactive expression to subset the data by country and calculate average salary by gender
  data_subset <- reactive({
    req(input$country)
    df <- salary_data %>%
      filter(Country == input$country) %>%
      group_by(Gender) %>%
      summarise(Salary = mean(Salary))
    return(df)
  })
  
  # Render data table
  output$data_table <- renderDT({
    datatable(salary_data, rownames = FALSE)
  })
  
  # Render a simple bar plot for demonstration
  output$bar_plot <- renderPlot({
    # Calculate average salary by gender
    average_salary <- data_subset()
    
    # Create the bar plot
    ggplot(average_salary, aes(x = Gender, y = Salary)) + 
      geom_bar(stat = "identity", fill = "skyblue") +
      labs(title = "Average Salary by Gender", x = "Gender", y = "Average Salary")
  })
  
  # Render text summary for the first tab
  output$bar_summary <- renderText({
    paste("This bar plot displays the average salary by gender for the selected country:", input$country)
  })

  # Render a histogram with average salary on the y-axis
  # Histogram where user can select gender and then we see average salary for age groups
  output$histogram_plot <- renderPlot({
    # Filter data by selected gender
    filtered_data <- salary_data %>%
      filter(Gender == input$gender)
    
    # Print the minimum and maximum values of the Age variable
    #cat("Minimum Age:", min(filtered_data$Age), "\n")
    #cat("Maximum Age:", max(filtered_data$Age), "\n")
    
    # Create bins for age groups
    bins <- seq(15, 65, by = 5)  # Adjust the bin width as needed
    
    # Calculate average salary for each age group
    avg_salary <- filtered_data %>%
      mutate(AgeGroup = cut(Age, bins, include.lowest = TRUE)) %>%
      group_by(AgeGroup) %>%
      summarise(AvgSalary = mean(Salary, na.rm = TRUE))
    
    # Format the labels of AgeGroup
    avg_salary$AgeGroup <- gsub("\\((\\d+),(\\d+)\\]", "\\1 - \\2", avg_salary$AgeGroup)  # Format labels
    
    # Define colors based on gender
    color <- ifelse(input$gender == "Male", "skyblue", "pink")
    
    # Plot histogram
    ggplot(avg_salary, aes(x = AgeGroup, y = AvgSalary, fill = input$gender, tooltip = AvgSalary)) +
      geom_col() +
      labs(title = paste("Average Salary Histogram for", input$gender),
           x = "Age Group", y = "Average Salary") +
      scale_x_discrete(labels = avg_salary$AgeGroup) + 
      scale_fill_manual(values = c(Male = "skyblue", Female = "pink")) +
      theme(legend.position = "none") 
    
  })
  
})

