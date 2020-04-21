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

gitURL = 'https://raw.githubusercontent.com/LieberInstitute/SpatialTissueLocator/master/data'

totalReads = as.matrix(read_csv(file.path(gitURL, 'totalReads.csv')))
totalGenes = as.matrix(read_csv(file.path(gitURL, 'totalGenes.csv')))
clusterMat = as.matrix(read_csv(file.path(gitURL, 'clusterMat.csv')))
spots = read_csv(file.path(gitURL, 'spots.csv'))




colnames(totalReads) = c("C1", "C2", "D1", "D2", "E2")
colnames(totalGenes) = c("C1", "C2", "D1", "D2", "E2")
colnames(clusterMat) = c("C1", "C2", "D1", "D2", "E2")

makePlot = function(im, xlim, ylim, spots, cols) {

  plot(NULL, xlim=c(min(spots$row)+xlim[1], max(spots$row)+xlim[2]), ylim=c(-1*max(spots$col)+ylim[1], -1*min(spots$col)+ylim[2]), asp=1)
  rasterImage(im, min(spots$row)+xlim[1], -1*max(spots$col)+ylim[1], max(spots$row)+xlim[2], -1*min(spots$col)+ylim[2])
  points(spots$row, -1*spots$col, pch=19, col=pal(2)[cols])
}
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  output$tissuePlot <- renderPlot({

    scale = input$scale
    trans.min = -scale/2
    trans.max = scale/2
    updateSliderInput(session, "translate.x", min=trans.min, max=trans.max)
    updateSliderInput(session, "translate.y", min=trans.min, max=trans.max)
    xlim = c(trans.min+input$translate.x,
             trans.max+input$translate.x)
    ylim = c(trans.min+input$translate.y,
             trans.max+input$translate.y)
    imName = input$image
    im = readImage(file.path(gitURL, paste0(imName, '_histology_small.png')))
    if (input$metric=="K-means clusters (k=2)") {
      x = clusterMat[,imName]
      cols = x
      makePlot(im, xlim, ylim, spots, cols)
      updateCheckboxInput(session, "log", value=FALSE)
      updateSliderInput(session, "thresh", value=0, min=0, max=0)
    } else if (input$metric=="Total Reads") {
      x = totalReads[,imName]
      if (input$log) {
        x = log2(x+1)
      }
      updateSliderInput(session, "thresh", min=min(x), max=max(x))
      cols = ifelse(x > input$thresh, 2, 1)
      makePlot(im, xlim, ylim, spots, cols)
    } else if (input$metric=="Total Genes") {
      x = totalGenes[,imName]
      if (input$log) {
        x = log2(x+1)
      }
      updateSliderInput(session, "thresh", min=min(x), max=max(x))
      cols = ifelse(x > input$thresh, 2, 1)
      makePlot(im, xlim, ylim, spots, cols)
    }



  })

  output$histPlot = renderPlot({
    imName = input$image
    if (input$metric=="K-means clusters (k=2)") {
      x = clusterMat[,imName]
      thresh = 1.5
    } else if (input$metric=="Total Reads") {
      x = totalReads[,imName]
      if (input$log) {
        x = log2(x+1)
      }
      thresh = input$thresh
    } else if (input$metric=="Total Genes") {
      x = totalGenes[,imName]
      if (input$log) {
        x = log2(x+1)
      }
      thresh = input$thresh
    }
    hist(x, breaks=100)
    abline(v=thresh, col="red")

  })

  #saveStuff <- eventReactive(input$save, {
  #  imName = input$image
  #  scale = input$scale
  #  trans.min = -scale/2
  #  trans.max = scale/2
  #  xlim = c(trans.min+input$translate.x,
  #           trans.max+input$translate.x)
  #  ylim = c(trans.min+input$translate.y,
  #           trans.max+input$translate.y)
  # save(xlim, ylim, paste0('/media/joecat/storage/Histology/ST/', imName, '_translation.Rdata))
  #})

})
