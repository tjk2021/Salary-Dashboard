# Author: Tanushree Koshti
# Project: Salary Dashboard
# Date: February 19, 2024

# server.R 
library(shiny)
library(tidyr)
library(ggplot2) # For visualization
library(plotly)
library(dplyr)   # For data manipulation
library(highcharter) 


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
  
  # # Render a simple bar plot for demonstration
  output$bar_plot <- renderPlotly({
    # Calculate average salary by gender
    average_salary <- data_subset()

    # Create the bar plot using plot_ly
    plot_ly(average_salary, x = ~Gender, y = ~Salary, type = "bar",
            marker = list(color = "skyblue"),
            hoverinfo = "text",
            text = ~paste("Average Salary: $", format(Salary, big.mark = ",", scientific = FALSE))) %>%
      layout(title = "Average Salary by Gender",
             xaxis = list(title = "Gender"),
             yaxis = list(title = "Average Salary"),
             showlegend = FALSE, # Remove legend
             hoverlabel = list(bgcolor = "white", font = list(color = "black")))
  })

  # Render text summary for the first tab
  output$bar_summary <- renderText({
    paste("This bar plot displays the average salary by gender for the selected country:", input$country)
  })
  
  # Render a histogram with average salary on the y-axis
  output$histogram_plot <- renderPlotly({
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
    
    # Define colors for bars
    colors <- ifelse(input$gender == "Male", "skyblue", "pink")
    
    # Plot histogram using plotly
    plot_ly(avg_salary, x = ~AgeGroup, y = ~AvgSalary, type = 'bar', color = input$gender, 
            text = ~paste("Average Salary:", round(AvgSalary, 2)),
            hoverinfo = 'text', colors = colors) %>%
      layout(title = paste("Average Salary Histogram for", input$gender),
             xaxis = list(title = "Age Group"),
             yaxis = list(title = "Average Salary"),
             showlegend = FALSE)
  })
  
  # Rendering a Scatter Plot
  output$scatter_plot <- renderPlotly({
    # Take a random sample of 100 data points
    sampled_data <- salary_data %>% sample_n(100)
    
    # Create separate data frames for Male and Female
    male_data <- sampled_data[sampled_data$Gender == "Male", ]
    female_data <- sampled_data[sampled_data$Gender == "Female", ]
    
    # Create the scatter plot using plot_ly
    p <- plot_ly() %>%
      add_trace(data = male_data, x = ~Education.Level, y = ~Salary, type = "scatter", mode = "markers", 
                color = I("skyblue"), name = "Male") %>%
      add_trace(data = female_data, x = ~Education.Level, y = ~Salary, type = "scatter", mode = "markers", 
                color = I("pink"), name = "Female") %>%
      layout(title = "Salary vs Education Level",
             xaxis = list(title = "Education Level", tickmode = "linear", dtick = 1),
             yaxis = list(title = "Salary"),
             showlegend = TRUE,
             margin = list(l = 50, r = 50, b = 50, t = 50), # Adjust margins
             height = 500,  # Adjust height
             width = 400)   # Adjust width 
  
    # Return the plot
    return(p)
  })
  
  
})

