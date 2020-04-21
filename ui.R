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
                  value = 0),
      plotOutput("histPlot")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tags$div(sliderInput("scale",
                  "Scale Tissue",
                  min = 0,
                  max = 20,
                  value = 10,
                  step = 0.1),
                  style="display: inline-block;vertical-align:top"),
      tags$div(style="display: inline-block;vertical-align:top; width: 20px;",HTML("<br>")),
      tags$div(sliderInput("translate.x",
                  "Translate Tissue: x",
                  min = -5,
                  max = 5,
                  value = 0,
                  step = 0.1),
                  style="display: inline-block;vertical-align:top"),
      tags$div(style="display: inline-block;vertical-align:top; width: 20px;",HTML("<br>")),
      tags$div(sliderInput("translate.y",
                  "Translate Tissue: y",
                  min = -5,
                  max = 5,
                  value = 0,
                  step = 0.1),
                  style="display: inline-block;vertical-align:top"),
      #tags$div(style="display: inline-block;vertical-align:top; width: 20px;",HTML("<br>")),
      #tags$div(actionButton("save",
      #                    "Save Scale and Translation Values"),
      #         style="display: inline-block;vertical-align:top"),
      plotOutput("tissuePlot", height="800px")
       
    )
  )
))
