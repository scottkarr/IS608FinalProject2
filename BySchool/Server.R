require(raster)
require(rgdal)
library(dplyr)
library(ggplot2)

df <- read.csv(file="https://raw.githubusercontent.com/scottkarr/IS608FinalProject/master/data/ELAScoresBySchool.csv", header=TRUE, sep=",",stringsAsFactors=FALSE)

shinyServer(
  function(input, output) {
      
      selectedData <- reactive({
        dfSlice <- df %>%
          filter(Year == input$year, Grade == input$grade)
        
        dfSlice <- dfSlice[,c(2,4,6,7,8,10,20)]
        dfSlice <- dfSlice[complete.cases(dfSlice),]

    })

    output$plot1 <- renderPlot({
      
      dfSlice <- df %>%
        filter(Year == input$year, Grade == input$grade)
      
        dfSlice[,c(2,4,6,7,8,10,20)]
        dfSlice[complete.cases(dfSlice),]
        
        ggplot(selectedData(), aes(x = District, y = as.numeric(Lvl_Pass_Pct), color = Borough, size = Headcount)) +
        geom_point() +
        xlab("NYC School District") +
        ylab("Passing Percentage") +
        ggtitle("NYC State Test Clustered by Passing Percentage")
    })
    
    # Generate a summary of the data
    output$summary <- renderPrint({
      summary(selectedData())
    })
    
    # Generate an HTML table view of the data
    output$table <- renderTable({
      
      dfSlice <- df %>%
        filter(Year == input$year, Grade == input$grade)
      
      data.frame(x=selectedData())
    })
  }
)