#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Gene Expression Data to locate tissue"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("image",
                  label="Select Image",
                  choices=c("C1",
                            "C2",
                            "D1",
                            "D2",
                            "E2"),
                  selected="C1"),
      selectInput("metric",
                  label="Select Metric",
                  choices=c("Total Reads",
                            "Total Genes",
                            "K-means clusters (k=2)"),
                  selected="K-means clusters (k=2)"),
      checkboxInput("log",
                    label="Log2",
                    value=FALSE),
       sliderInput("thresh",
                   "Threshold",
                   min = 0,
                   max = 0,
                   value = 0)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("tissuePlot"),
       plotOutput("histPlot")
    )
  )
))
