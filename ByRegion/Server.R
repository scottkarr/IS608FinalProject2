library(raster)
library(rgdal)
library(dplyr)
library(ggplot2)
library(colorspace)

setwd("/Users/scottkarr/IS608Spring2017/Project/nysd_17a")
df <- read.csv(file="https://raw.githubusercontent.com/scottkarr/IS608FinalProject/master/data/ELAScoresBySchool.csv", header=TRUE, sep=",",stringsAsFactors=FALSE)

shinyServer(
  function(input, output) {
      
      selectedData <- reactive({
        
        dfSlice <- df %>%
          filter(Year == input$year, Grade == input$grade)
        
        dfSlice <- dfSlice[,c(2,4,7,8,20)]
        dfSlice <- dfSlice[complete.cases(dfSlice),]

    })

    output$plot1 <- renderPlot({
      
      shpfile <- readOGR(getwd(), "nysd")
      
      dfSlice <- df %>%
        filter(Year == input$year, Grade == input$grade)
      
      dfSlice <- dfSlice[,c(2,4,7,8,20)]
      dfSlice <- dfSlice[complete.cases(dfSlice),]
        
      dfSum <- dfSlice %>% 
        group_by (Borough, District) %>%
        summarize(Pass = mean(as.numeric(Lvl_Pass_Pct), na.rm = TRUE))
      
      shpfile@data <- left_join(shpfile@data, dfSum, by=c("SchoolDist" = "District"))
      spplot(shpfile, z="Pass",  main = "New York City", sub = "ELA Pass Rate Pct by School District")
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