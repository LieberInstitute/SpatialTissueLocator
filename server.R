#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(RColorBrewer)
library(EBImage)

pal = colorRampPalette(c("blue", "red"))

totalReads = read_rds('../totalReads.rds')
totalGenes = read_rds('../totalGenes.rds')
clusterMat = read_rds('../clusterMat.rds')
spots = read_rds('../spots.rds')
xlims = list()
xlims$C1 = c(-5, 5)
xlims$C2 = c(-5, 5)
xlims$D1 = c(-5, 5)
xlims$D2 = c(-5, 5)
xlims$E2 = c(-8, 6)
ylims= list()
ylims$C1 = c(-6, 0)
ylims$C2 = c(-5, 1)
ylims$D1 = c(-4, 2)
ylims$D2 = c(-4, 2)
ylims$E2 = c(-6, 4)

colnames(totalReads) = c("C1", "C2", "D1", "D2", "E2")
colnames(totalGenes) = c("C1", "C2", "D1", "D2", "E2")
colnames(clusterMat) = c("C1", "C2", "D1", "D2", "E2")

makePlot = function(im, xlim, ylim, spots, cols) {
  
  plot(NULL, xlim=c(xlim[1], max(spots$row)+xlim[2]), ylim=c(-1*max(spots$col)+ylim[1], ylim[2]))
  rasterImage(im, xlim[1], -1*max(spots$col)+ylim[1], max(spots$row)+xlim[2], ylim[2])
  points(spots$row, -1*spots$col, pch=19, col=pal(2)[cols])
}
makeHist = function(x, thresh) {
  hist(x)
  abline(v=thresh, col="red")
}
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
  output$tissuePlot <- renderPlot({
    
    imName = input$image
    im = readImage(paste0('../', imName, '_histology_small.jpg'))
    if (input$metric=="K-means clusters (k=2)") {
      x = clusterMat[,imName]
      cols = x
      p = makePlot(im, xlims[imName][[1]], ylims[imName][[1]], spots, cols)
      updateCheckboxInput(session, "log", value=FALSE)
      updateSliderInput(session, "thresh", value=0, min=0, max=0)
    } else if (input$metric=="Total Reads") {
      x = totalReads[,imName]
      if (input$log) {
        x = log2(x)
      }
      updateSliderInput(session, "thresh", min=min(x), max=max(x))
      cols = ifelse(x > input$thresh, 2, 1)
      p = makePlot(im, xlims[imName][[1]], ylims[imName][[1]], spots, cols)
    } else if (input$metric=="Total Genes") {
      x = totalGenes[,imName]
      if (input$log) {
        x = log2(x)
      }
      updateSliderInput(session, "thresh", min=min(x), max=max(x))
      cols = ifelse(x > input$thresh, 2, 1)
      p = makePlot(im, xlims[imName][[1]], ylims[imName][[1]], spots, cols)
    }
    
    
    
  })
  
  output$histPlot = renderPlot({
    if (input$metric=="K-means clusters (k=2)") {
      x = clusterMat[,imName]
      thresh = 1.5
    } else if (input$metric=="Total Reads") {
      x = totalReads[,imName]
      if (input$log) {
        x = log2(x)
      }
      thresh = input$thresh
    } else if (input$metric=="Total Genes") {
      x = totalGenes[,imName]
      if (input$log) {
        x = log2(x)
      }
      thresh = input$thresh
    }
    h = makeHist(x, thresh)
    
  })
  
})
