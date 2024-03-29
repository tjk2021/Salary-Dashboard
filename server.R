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
  
  # Render the summary as HTML for the first column
  output$summary_col1 <- renderUI({
    HTML('
      <div style="background-color: #f8f9fa; padding: 10px; overflow-y: auto; height: calc(100vh - 100px); width: 100%;">
      <h1>Dataset Information</h1>
      <h4><p><strong>Dataset Name:</strong> Salary by Job Title and Country</p>
      <p><strong>Data Source:</strong> Kaggle</p>

      <p><strong>About Dataset:</strong> This dataset provides a comprehensive 
        collection of salary information from various industries and regions across the globe. 
        Sourced from reputable employment websites and surveys, it includes details on job titles, 
        salaries, job sectors, geographic locations, and more. Analyze this data to gain insights 
        into job market trends, compare compensation across different professions, and make informed
        decisions about your career or hiring strategies. The dataset is cleaned and preprocessed 
        for ease of analysis and is available under an open license for research and data 
        analysis purposes.
      </p>
      
      <br>
      
      <p><strong>My Analysis:</strong> I aimed to investigate the disparity in salary 
        between males and females across various dimensions such as geographical location 
        (countries), levels of experience and education, as well as age.
      </p>
      
      <br>
      
      <p>I utilized various types of visualizations to show the correlation between the following factors: </p>
      <ul>
        <li>Location</li>
        <li>Gender</li>
        <li>Age</li>
        <li>Education Levels</li>
        <li>Experience Levels</li>
      </ul>
    </h4></div>
  ')
  })
  
  # Render data table
  output$data_table <- renderDT({
    datatable(salary_data, rownames = FALSE)
  })
  
  # Render a simple bar plot for demonstration
  output$bar_plot <- renderPlotly({
    # Calculate average salary by gender
    average_salary <- data_subset()
    
    # Define colors based on gender
    colors <- ifelse(average_salary$Gender == "Female", "pink", "skyblue")
    
    # Create the bar plot using plot_ly
    plot_ly(average_salary, x = ~Gender, y = ~Salary, type = "bar",
            marker = list(color = colors), # Use the colors defined above
            hoverinfo = "text",
            text = ~paste("Average Salary: $", format(Salary, big.mark = ",", scientific = FALSE))) %>%
      layout(title = "Average Salary by Gender",
             xaxis = list(title = "Gender"),
             yaxis = list(title = "Average Salary"),
             showlegend = FALSE, # Remove legend
             margin = list(l = 50, r = 50, b = 50, t = 75), # Adjust margins
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
             showlegend = FALSE,
             margin = list(l = 50, r = 50, b = 50, t = 75)) # Adjust margins
    
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
             xaxis = list(title = "Education Level", tickmode = "linear", dtick = 1, showline = FALSE),
             yaxis = list(title = "Salary"),
             showlegend = FALSE,
             margin = list(l = 50, r = 50, b = 50, t = 100), # Adjust margins
             height = 500,  # Adjust height
             width = 500)   # Adjust width 
    
    # Return the plot
    return(p)
  })
  
  
  # Rendering a Scatter Plot
  output$scatter_plot2 <- renderPlotly({
    # Take a random sample of 100 data points
    sampled_data <- salary_data %>% sample_n(100)
    
    # Create separate data frames for Male and Female
    male_data <- sampled_data[sampled_data$Gender == "Male", ]
    female_data <- sampled_data[sampled_data$Gender == "Female", ]
    
    # Create the scatter plot using plot_ly
    p <- plot_ly() %>%
      add_trace(data = male_data, x = ~Years.of.Experience, y = ~Salary, type = "scatter", mode = "markers", 
                color = I("skyblue"), name = "Male") %>%
      add_trace(data = female_data, x = ~Years.of.Experience, y = ~Salary, type = "scatter", mode = "markers", 
                color = I("pink"), name = "Female") %>%
      layout(title = "Salary vs Years of Experience",
             xaxis = list(title = "Years of Experience", tickmode = "linear", dtick = 5, showline = FALSE),
             yaxis = list(title = "Salary"),
             showlegend = FALSE,
             margin = list(l = 50, r = 50, b = 50, t = 100), # Adjust margins
             height = 500,  # Adjust height
             width = 500)   # Adjust width 
    
    # Return the plot
    return(p)
  })
  
  # Define reactive expression for filtered data
  filtered_data <- reactive({
    salary_data %>%
      filter(Gender == input$gender)
  })
  
  # Create a random sample of 100 data points for each gender
  male_sample <- salary_data %>%
    filter(Gender == "Male") %>%
    sample_n(100)
  
  female_sample <- salary_data %>%
    filter(Gender == "Female") %>%
    sample_n(100)
  
  # Create separate ggplot objects for each gender
  male_plot <- male_sample %>%
    ggplot(aes(x = Education.Level, y = Years.of.Experience, size = Salary, label = Gender)) + 
    geom_point(alpha = 0.75, color = "skyblue", stroke = 0.2) +
    scale_size(range = c(3, 8)) +
    labs(title = "Male", x = "Education Level", y = "Years of Experience") +
    theme_classic()
  
  
  female_plot <- female_sample %>%
    ggplot(aes(x = Education.Level, y = Years.of.Experience, size = Salary, label = Gender)) + 
    geom_point(alpha = 0.75, color = "pink", stroke = 0.2) +
    scale_size(range = c(3, 8)) +
    labs(title = "Female", x = "Education Level", y = "Years of Experience") +
    theme_classic()
  
  
  # Render the ggplotly objects
  output$bubble_chart_male <- renderPlotly({
    ggplotly(male_plot, width = 500, height = 500) %>%
      layout(xaxis = list(range = c(-0.5, 3.5)),
             yaxis = list(range = c(-1, 30)),
             showlegend = FALSE)
  })
  
  output$bubble_chart_female <- renderPlotly({
    ggplotly(female_plot, width = 500, height = 500) %>%
      layout(xaxis = list(range = c(-0.5, 3.5)),
             yaxis = list(range = c(-1, 30)),
             showlegend = FALSE)
  })
})
